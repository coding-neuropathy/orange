//
//  MoreArticlesSubCategoryViewController.m
//  orange
//
//  Created by D_Collin on 16/2/16.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MoreArticlesSubCategoryViewController.h"
#import "MoreArticleCell.h"
@interface MoreArticlesSubCategoryViewController ()



@property (nonatomic ,assign)NSInteger page;

//@property (assign, nonatomic) NSInteger count;
@end

@implementation MoreArticlesSubCategoryViewController

static NSString * ArticleIdentifier = @"MoreArticleCell";

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource
{
    if (self = [super init]) {
        self.dataSource = dataSource;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.tableView];
//    
//    [self.tableView registerClass:[ArticleListCell class] forCellReuseIdentifier:ArticleCellIdentifier];
    [self.collectionView registerClass:[MoreArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
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
    
    if (self.dataSource == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

- (void)refresh
{
    self.page = 1;
    [API getSubCategoryArticlesWithCategroyId:self.cid Page:self.page success:^(NSArray *articles, NSInteger count) {
        self.dataSource = [NSMutableArray arrayWithArray:articles];
        self.page += 1;
        
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
    
}

- (void)loadMore
{
    [API getSubCategoryArticlesWithCategroyId:self.cid Page:self.page success:^(NSArray *articles, NSInteger count) {
        [self.dataSource addObjectsFromArray:articles];
        self.page += 1;
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
    
}

#pragma mark -----------tableView懒加载 ---------------

//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight -kStatusBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
//        
//    }
//    return _tableView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------tableView代理协议-----------------
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleIdentifier forIndexPath:indexPath];
    cell.article = [self.dataSource objectAtIndex:indexPath.row];
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
        
        
        cellsize = CGSizeMake(kScreenWidth, 110.);
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
        linespacing =  1.;
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
    GKArticle * article = [self.dataSource objectAtIndex:indexPath.row];
    //    [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
    [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
