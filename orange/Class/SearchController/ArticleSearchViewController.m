//
//  ArticleSearchViewController.m
//  orange
//
//  Created by huiter on 15/12/8.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "ArticleSearchViewController.h"
#import "ArticleListCell.h"
#import "NoSearchResultView.h"

#import "MoreArticleCell.h"

@interface ArticleSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (strong, nonatomic)UITableView * tableView;

@property (nonatomic, strong)UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NoSearchResultView * noResultView;
@property (nonatomic, strong) NSString *keyword;

@end

@implementation ArticleSearchViewController

static NSString * ArticleIdentifier = @"MoreArticleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MoreArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
    
        __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf reFresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight-kStatusBarHeight-kNavigationBarHeight-44) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) style:UITableViewStylePlain];
//        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundView = nil;
//        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        _tableView.showsVerticalScrollIndicator = YES;
//        
//    }
//    return _tableView;
//}

#pragma mark - init collction view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

- (NoSearchResultView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[NoSearchResultView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    }
    return _noResultView;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark ----------tableView代理协议-----------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleIdentifier forIndexPath:indexPath];
    cell.article = [self.dataArray objectAtIndex:indexPath.row];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.dataArray objectAtIndex:indexPath.row];
    //    [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
    [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         self.collectionView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    
    self.keyword = searchText;
#warning footer------------------------------------
//    self.tableView.tableFooterView = nil;
    
    [API searchArticlesWithString:searchText Page:1 Size:10 success:^(NSArray *articles) {
        if (articles.count == 0) {
//            self.tableView.tableFooterView = self.noResultView;
            self.noResultView.type = NoResultType;
        } else {
            self.dataArray = [NSMutableArray arrayWithArray:articles];
        }
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Data
- (void)loadMore
{

    NSInteger page = ceilf(self.dataArray.count / 10.) + 1;
    [API searchArticlesWithString:self.keyword Page:page Size:10 success:^(NSArray *articles) {
        [self.dataArray addObjectsFromArray:articles];
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];

}

- (void)reFresh
{
    [API searchArticlesWithString:self.keyword Page:1 Size:10 success:^(NSArray *articles) {
        if (articles.count == 0) {
#warning footer ---------------------
//            self.tableView.tableFooterView = self.noResultView;
            self.noResultView.type = NoResultType;
        }
        else
        {
            self.dataArray = [NSMutableArray arrayWithArray:articles];
        }
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

@end
