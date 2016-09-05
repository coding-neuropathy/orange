//
//  UserArticleViewController.m
//  orange
//
//  Created by D_Collin on 16/3/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UserArticleViewController.h"
#import "MoreArticleCell.h"

@interface UserArticleViewController ()

/** 用户图文数据源数组 */
@property (nonatomic , strong) NSMutableArray * dataSource;

//@property (nonatomic , strong) UITableView * tableView;
//@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic , assign) NSInteger page;

@end

@implementation UserArticleViewController

static NSString * ArticleCellIdentifier = @"UserArticleCell";

//- (void)loadView
//{
//    self.view = self.collectionView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[MoreArticleCell class] forCellWithReuseIdentifier:ArticleCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    [API getUserArticlesWithUserId:self.Uid Page:self.page Size:15 success:^(NSArray *articles, NSInteger page, NSInteger count) {
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
    [API getUserArticlesWithUserId:self.Uid Page:self.page Size:15 success:^(NSArray *articles, NSInteger page, NSInteger count) {
        [self.dataSource addObjectsFromArray:articles];
        self.page += 1;
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

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
    MoreArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCellIdentifier forIndexPath:indexPath];
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
    return UIEdgeInsetsMake(0., 0., 0., 0.);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat linespacing = 0.;
    
    if (IS_IPHONE) {
        linespacing =  10;
    }
    return linespacing;
}

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
