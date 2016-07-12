//
//  NewSearchController.m
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "NewSearchController.h"
#import "EntityResultCell.h"
#import "MoreArticleCell.h"
@interface NewSearchController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UICollectionView * collectionView;

@property (nonatomic , strong)NSMutableArray * categoryArray;
@property (nonatomic , strong)NSMutableArray * userArray;
@property (nonatomic , strong)NSMutableArray * entityArray;
@property (nonatomic , strong)NSMutableArray * articleArray;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, weak) UISearchBar * searchBar;

@end

@implementation NewSearchController

static NSString * EntityResultCellIdentifier = @"EntityResultCell";
static NSString * ArticleResultCellIdentifier = @"ArticleResultCell";

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight - kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[EntityResultCell class] forCellWithReuseIdentifier:EntityResultCellIdentifier];
    [self.collectionView registerClass:[MoreArticleCell class] forCellWithReuseIdentifier:ArticleResultCellIdentifier];
    
    [self.view addSubview:self.collectionView];
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf reFresh];
    }];
    
}

- (void)reFresh
{
    [API searchWithKeyword:self.keyword Success:^(NSArray *entities, NSArray *articles, NSArray *users) {
        self.entityArray = [NSMutableArray arrayWithArray:entities];
        self.userArray = [NSMutableArray arrayWithArray:users];
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
        
            break;
        case 1:
//            count = self.userArray.count;
            break;
        case 2:
            count = self.entityArray.count;
            count = 3;
            break;
        case 3:
            count = self.articleArray.count;
            count = 3;
            break;
        default:
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
      
        case 3:
        {
            MoreArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleResultCellIdentifier forIndexPath:indexPath];
            cell.article = self.articleArray[indexPath.row];
            return cell;
        }
        default:
        {
            EntityResultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityResultCellIdentifier forIndexPath:indexPath];
            cell.entity = self.entityArray[indexPath.row];
            return cell;
        }
            break;
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0., 0.);
    switch (indexPath.section) {
        case 2:
        {
            cellsize = CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32);
        }
            break;
            
        default:
        {
            cellsize = CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32);
        }
            break;
    }
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    switch (section) {
        case 1:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 2:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 3:
            if (IS_IPHONE) {
                edge = UIEdgeInsetsMake(0., 0., 10., 0);
            }
            else
            {
                edge = UIEdgeInsetsMake(0., 20., 0., 20.);
            }
            break;
        default:
            break;
    }
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
    switch (section) {
            
        case 2:
        {
        
            itemSpacing = 1.;
        }
            break;
        default:
            //            itemSpacing = 0;
            break;
    }
    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0;
    switch (section) {
        case 2:
            
            spacing = 1.;
            
            break;
        default:
            
            break;
    }
    return spacing;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//{
//    
//}



#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 2:
        {
            GKEntity * entity = self.entityArray[indexPath.row];
            [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
        }
            break;
            
        default:
        {
            GKArticle * article = self.articleArray[indexPath.row];
            [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
        }
            break;
    }
}

- (void)searchText:(NSString *)string
{
    [self handleSearchText:string];
}

- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    self.keyword = searchText;
    [API searchWithKeyword:searchText Success:^(NSArray *entities, NSArray *articles, NSArray *users) {
        
        self.entityArray = [NSMutableArray arrayWithArray:entities];
        self.userArray = [NSMutableArray arrayWithArray:users];
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

#pragma mark - <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    if ([self.keyword isEqualToString:[searchController.searchBar.text trimedWithLowercase]]) {
        return;
    }
    self.searchBar = searchController.searchBar;
    
    self.keyword = [searchController.searchBar.text trimedWithLowercase];
    if (self.keyword.length == 0) {
        [UIView animateWithDuration:0 animations:^{
            [self.discoverVC.searchVC.view viewWithTag:999].alpha = 1;
        }];
        return;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.discoverVC.searchVC.view viewWithTag:999].alpha = 0;
    }completion:^(BOOL finished) {
                [self handleSearchText:self.keyword];
    }];
}

@end
