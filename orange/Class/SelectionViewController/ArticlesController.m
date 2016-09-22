//
//  ArticlesController.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ArticlesController.h"
#import "ArticleCell.h"

#import "ArticlePreViewController.h"
#import "ArticleWebViewController.h"


//static int lastContentOffset;


@interface ArticlesController () <UIViewControllerPreviewingDelegate>

//@property (strong, nonatomic) GKSelectionArticle * articles;


@end

@implementation ArticlesController

static NSString * ArticleIdentifier = @"ArticleCell";

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (void)dealloc
{
    [self.articles removeTheObserverWithObject:self];
}

- (GKSelectionArticle *)articles
{
    if (!_articles) {
        _articles = [[GKSelectionArticle alloc] init];
        [_articles addTheObserverWithObject:self];
    }
    return _articles;
}

//- (void)loadView
//{
//    self.view = self.collectionView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[ArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
    
//    [self registerPreview];
    if (iOS9)
        [self registerPreview];
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

/**
 *  register 3d-touch
 */
- (void)registerPreview{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
    else {
        DDLogInfo(@"该设备不支持3D-Touch");
    }
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf.articles refresh];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.articles load];
    }];

    if (self.articles.count == 0)
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
    return self.articles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleIdentifier forIndexPath:indexPath];
    cell.article = [self.articles objectAtIndex:indexPath.row];
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
        GKArticle * article = [self.articles objectAtIndex:indexPath.row];
    
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

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         [self.collectionView performBatchUpdates:nil completion:nil];
//     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         
//     }];
//    
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.articles objectAtIndex:indexPath.row];
    [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
}

#pragma mark - <UIViewControllerPreviewingDelegate>
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath =[self.collectionView indexPathForItemAtPoint:location];
    
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell) {
        return nil;
    }
    
    if (iOS10) {
//        Articlevi
        ArticleWebViewController * vc = [[ArticleWebViewController alloc] initWithArticle:[self.articles objectAtIndex:indexPath.row]];
        vc.preferredContentSize         = CGSizeMake(0, 0);
        previewingContext.sourceRect    = cell.frame;
        vc.hidesBottomBarWhenPushed     = YES;
//        vc.forceTouch                   = YES;
        UINavigationController *nav     = [[UINavigationController alloc] initWithRootViewController:vc];
        return nav;
    } else {
    
        ArticlePreViewController * vc = [[ArticlePreViewController alloc] initWithArticle:[self.articles objectAtIndex:indexPath.row]];
        vc.preferredContentSize = CGSizeMake(0, 0);
        previewingContext.sourceRect = cell.frame;
        return vc;
    }
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    if (iOS10) {
        [self presentViewController:viewControllerToCommit animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:viewControllerToCommit animated:NO];
    }

}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isRefreshing"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.articles.error) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [UIView setAnimationsEnabled:NO];
                [self.collectionView reloadData];
                [UIView setAnimationsEnabled:YES];
            } else {
                [self.collectionView.pullToRefreshView stopAnimating];
            }
        }
    }
    if ([keyPath isEqualToString:@"isLoading"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.articles.error) {
                [self.collectionView reloadData];
                [self.collectionView.infiniteScrollingView stopAnimating];
            } else {
                [self.collectionView.infiniteScrollingView stopAnimating];
            }
        }
    }
    
}


@end
