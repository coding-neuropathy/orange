//
//  ArticlesController.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ArticlesController.h"
#import "ArticleCell.h"
//#import "PreviewArticleController.h"

//#import "WebViewController.h"

@import CoreSpotlight;

@interface ArticlesController () <UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) NSMutableArray * articleArray;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic) NSTimeInterval timestamp;

@end

@implementation ArticlesController

static NSString * ArticleIdentifier = @"ArticleCell";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.page = 1;
        self.size = 20;
        self.timestamp = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

#pragma mark - init View
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.parallaxHeaderAlwaysOnTop = YES;
        
        if (IS_IPAD) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) collectionViewLayout:layout];
        } else {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        }
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

//- (void)registerPreview{
//    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
//    }
//    else {
//        DDLogInfo(@"该设备不支持3D-Touch");
//    }
//}

#pragma mark - get data
- (void)refresh
{
    self.page = 1;
    self.timestamp = [[NSDate date] timeIntervalSince1970];
    [API getArticlesWithTimestamp:self.timestamp Page:self.page Size:self.size success:^(NSArray *articles) {
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        self.page +=1;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        [self saveEntityToIndexWithData:articles];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getArticlesWithTimestamp:self.timestamp Page:self.page Size:self.size success:^(NSArray *articles) {
        self.page += 1;
        [self.articleArray addObjectsFromArray:articles];
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
        [self saveEntityToIndexWithData:articles];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - save to index
- (void)saveEntityToIndexWithData:(NSArray *)data
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<CSSearchableItem *> *searchableItems = [NSMutableArray array];
        
        for (NSDictionary * row in data) {
            CSSearchableItemAttributeSet *attributedSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"article"];
            GKArticle * article = (GKArticle *)row;
            attributedSet.title = article.title;
            attributedSet.contentDescription = article.content;
            attributedSet.identifier = @"article";
            
            /**
             *  set image data
             */
            NSData * imagedata = [ImageCache readImageWithURL:article.coverURL_300];
            if (imagedata) {
                attributedSet.thumbnailData = imagedata;
            } else {
                attributedSet.thumbnailData = [NSData dataWithContentsOfURL:article.coverURL_300];
                [ImageCache saveImageWhthData:attributedSet.thumbnailData URL:article.coverURL_300];
            }
            
            
            CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"article:%ld", (long)article.articleId] domainIdentifier:@"com.guoku.iphone.search.article" attributeSet:attributedSet];
            
            [searchableItems addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.entityImageView setImage:placeholder];
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"index Error %@",error.localizedDescription);
                }
            }];
        });
    });
}


- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[ArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
    
//    [self registerPreview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.scrollsToTop = YES;
//    [AVAnalytics beginLogPageView:@"ArticlesView"];
    [MobClick beginLogPageView:@"ArticlesView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.collectionView.scrollsToTop = NO;
    [MobClick endLogPageView:@"ArticlesView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];

    if (self.articleArray.count == 0)
    {
        [self.collectionView triggerPullToRefresh];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.articleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleIdentifier forIndexPath:indexPath];
    cell.article = [self.articleArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize  = CGSizeMake(0., 0.);
    if (IS_IPAD) {
        cellsize = CGSizeMake(342., 360.);
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight){
            cellsize = CGSizeMake(313., 344.);
        }
//        return cellsize;
    } else {
        GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
    
        cellsize = [ArticleCell CellSizeWithArticle:article ];
    }
    return cellsize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)
    //    {
    //        return UIEdgeInsetsMake(0., 128., 0., 128.);
    //    }
    return UIEdgeInsetsMake(0., 0., 0., 0.);
}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0., 0., 5, 0.);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat linespacing = 0.;
    
    if (IS_IPHONE) {
        linespacing =  10;
    }
    return linespacing;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.collectionView performBatchUpdates:nil completion:nil];
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
//    [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
    [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
}

//#pragma mark - <UIViewControllerPreviewingDelegate>
//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
//{
//    NSIndexPath * indexPath =[self.collectionView indexPathForItemAtPoint:location];
//    
//    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    
//    if (!cell) {
//        return nil;
//    }
//    
//    PreviewArticleController * vc = [[PreviewArticleController alloc] initWIthArticle:[self.articleArray objectAtIndex:indexPath.row]];
//    vc.preferredContentSize = CGSizeMake(0, 0);
//    previewingContext.sourceRect = cell.frame;
//    return vc;
//}
//
//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
//{
//    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
//}

@end
