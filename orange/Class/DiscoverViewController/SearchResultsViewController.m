//
//  SearchResultsViewController.m
//  orange
//
//  Created by huiter on 15/8/6.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "HMSegmentedControl.h"
#import "NoSearchResultView.h"
#import "CategoryGridCell.h"
#import "EntitySingleListCell.h"
#import "ArticleListCell.h"
#import "UserSingleListCell.h"
#import "PinyinTools.h"

#import "DataStructure.h"

@interface SearchResultsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView * tableView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControlForSearch;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NoSearchResultView * noResultView;
@property (nonatomic, weak) UISearchBar * searchBar;

@property (assign, nonatomic) SearchType searchType;

@property (nonatomic, strong) NSMutableArray * dataArrayForEntityForSearch;
@property (nonatomic, strong) NSMutableArray * dataArrayForUserForSearch;
@property (nonatomic, strong) NSMutableArray * dataArrayForLikeForSearch;
@property (strong, nonatomic) NSMutableArray * articleArray;

@property (nonatomic, strong) NSMutableArray * dataArrayForOffsetForSearch;
@end

@implementation SearchResultsViewController

- (NoSearchResultView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[NoSearchResultView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    }
    return _noResultView;
}
- (HMSegmentedControl *)segmentedControlForSearch
{
    if (!_segmentedControlForSearch) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [segmentedControl setSectionTitles:@[ @"商品",@"图文",@"品类",@"用户"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x9d9e9f) forKey:NSForegroundColorAttributeName];
        [segmentedControl setTitleTextAttributes:dict];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObject:UIColorFromRGB(0xFF1F77) forKey:NSForegroundColorAttributeName];
        [segmentedControl setSelectedTitleTextAttributes:dict2];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xFF1F77)];
        [segmentedControl setSelectionIndicatorHeight:1.5];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        self.segmentedControlForSearch = segmentedControl;
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,self.segmentedControlForSearch.deFrameHeight-0.5, kScreenWidth, 0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            //[self.segmentedControlForSearch addSubview:H];
        }
    }
    return _segmentedControlForSearch;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight-kStatusBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchType = EntityType;
    
    [self.view addSubview:self.tableView];
     __weak __typeof(&*self)weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AVAnalytics beginLogPageView:@"SearchResultView"];
    [MobClick beginLogPageView:@"SearchResultView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AVAnalytics endLogPageView:@"SearchResultView"];
    [MobClick endLogPageView:@"SearchResultView"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)searchText:(NSString *)string
{
    [self handleSearchText:string];
}

#pragma mark - Data
- (void)loadMore
{
    switch (self.segmentedControlForSearch.selectedSegmentIndex) {
        case EntityType:
        {
            [API searchEntityWithString:self.keyword type:@"all" offset:self.dataArrayForEntityForSearch.count count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
                if (self.dataArrayForEntityForSearch.count == 0) {
                    self.dataArrayForEntityForSearch = [NSMutableArray array];
                }
                [self.dataArrayForEntityForSearch addObjectsFromArray:entityArray];
                [self.tableView.infiniteScrollingView stopAnimating];
                [self.tableView reloadData];
            } failure:^(NSInteger stateCode) {
                DDLogError(@"code %ld", (long)stateCode);
                [self.tableView.infiniteScrollingView stopAnimating];
            }];
        }
            break;
            
        case ArticleType:
        {
            NSInteger page = ceilf(self.articleArray.count / 10.) + 1;
            [API searchArticlesWithString:self.keyword Page:page Size:10 success:^(NSArray *articles) {
                [self.articleArray addObjectsFromArray:articles];
                [self.tableView.infiniteScrollingView stopAnimating];
                [self.tableView reloadData];
            } failure:^(NSInteger stateCode) {
                [self.tableView.infiniteScrollingView stopAnimating];
            }];
        }
            break;
        case CategoryType:
        {
            [self.tableView.infiniteScrollingView stopAnimating];
            return;
        }
            break;
            
        case UserType:
        {
            [API searchUserWithString:self.keyword offset:self.dataArrayForUserForSearch.count count:30 success:^(NSArray *userArray) {
                if (self.dataArrayForUserForSearch.count == 0) {
                    self.dataArrayForUserForSearch = [NSMutableArray array];
                }
                [self.dataArrayForUserForSearch addObjectsFromArray:userArray];
                [self.tableView.infiniteScrollingView stopAnimating];
                [self.tableView reloadData];
            } failure:^(NSInteger stateCode) {
                [self.tableView.infiniteScrollingView stopAnimating];
            }];
        }
            break;
//        default:
//            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = self.segmentedControlForSearch.selectedSegmentIndex;
    
    switch (index) {
        case EntityType:
        {
            return self.dataArrayForEntityForSearch.count;
        }
            break;
            
        case ArticleType:
            return self.articleArray.count;
            break;
            
        case CategoryType:
            return ceil(self.filteredArray.count /(CGFloat)4);
            break;
            
        case UserType:
            return self.dataArrayForUserForSearch.count;
            break;
    }
    return 0;
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = self.segmentedControlForSearch.selectedSegmentIndex;
    
    switch (index) {
        case EntityType:
        {
            static NSString *CellIdentifier = @"EntitySingleListCell";
            EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.entity = [self.dataArrayForEntityForSearch objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        
        case ArticleType:
        {
            static NSString * CellIdentifier = @"ArticleCell";
            ArticleListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.article = [self.articleArray objectAtIndex:indexPath.row];
            return cell;
        }
        case CategoryType:
        {
            static NSString *CellIdentifier = @"CategoryCell";
            CategoryGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[CategoryGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            
            NSArray *categoryDictArray = self.filteredArray;
            
            NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
            
            NSUInteger offset = indexPath.row * 4;
            int i = 0;
            for (; offset < categoryDictArray.count ; offset++) {
                [categoryArray addObject:categoryDictArray[offset]];
                i++;
                if (i>=4) {
                    break;
                }
            }
            cell.categoryArray = categoryArray;
            return cell;
        }
            break;
        case UserType:
        {
            static NSString *CellIdentifier = @"UserSingleListCell";
            UserSingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UserSingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.user = [self.dataArrayForUserForSearch objectAtIndex:indexPath.row];
            
            return cell;
        }
            break;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger index = self.segmentedControlForSearch.selectedSegmentIndex;
    
    switch (index) {
        case EntityType:
        {
            return [EntitySingleListCell height];
        }
            break;
        case ArticleType:
            return 110.;
            break;
        case CategoryType:
        {
            return [CategoryGridCell height];
        }
            break;
        case UserType:
            return [UserSingleListCell height];
            break;
    }
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - <UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentedControlForSearch;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.segmentedControlForSearch.selectedSegmentIndex == ArticleType) {
        GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
        [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.dataArrayForOffsetForSearch) {
        self.dataArrayForOffsetForSearch = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),@(0),nil];
    }
    [self.dataArrayForOffsetForSearch setObject:@(scrollView.contentOffset.y) atIndexedSubscript:self.segmentedControlForSearch.selectedSegmentIndex];
    [self.searchBar resignFirstResponder];

}
#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    if(segmentedControl == self.segmentedControlForSearch)
    {
        
        CGFloat y = [[self.dataArrayForOffsetForSearch objectAtIndexedSubscript:self.segmentedControlForSearch.selectedSegmentIndex] floatValue];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, y) animated:NO];
        NSUInteger index = segmentedControl.selectedSegmentIndex;
        switch (index) {
            case CategoryType:
            {
                [self handleSearchText:self.keyword];
            }
                break;
            case EntityType:
            {
                if (self.dataArrayForEntityForSearch.count == 0) {
                    [self handleSearchText:self.keyword];
                }
            }
                break;
            case ArticleType:
            {
                if (self.articleArray.count == 0) {
                    [self handleSearchText:self.keyword];
                }
            }
                break;
            case UserType:
            {
                if (self.dataArrayForUserForSearch.count == 0) {
                    [self handleSearchText:self.keyword];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    

    self.tableView.tableFooterView = nil;
    [self.tableView.pullToRefreshView startAnimating];
    
    
    switch (self.segmentedControlForSearch.selectedSegmentIndex) {
        case EntityType:
        {
            [API searchEntityWithString:self.keyword type:@"all" offset:0 count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
                //            DDLogInfo(@"search result %@", entityArray);
                if (entityArray.count == 0) {
                    self.dataArrayForEntityForSearch = [NSMutableArray arrayWithArray:entityArray];;
                    self.tableView.tableFooterView = self.noResultView;
                    self.noResultView.type = NoResultType;
                    //                DDLogInfo(@"%@", self.noResultView);
                } else {
                    self.dataArrayForEntityForSearch = [NSMutableArray arrayWithArray:entityArray];
                }
                [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView reloadData];
            } failure:^(NSInteger stateCode) {
                [self.tableView.pullToRefreshView stopAnimating];
            }];
        }
            break;
            
        case ArticleType:
        {
            [API searchArticlesWithString:self.keyword Page:1 Size:10 success:^(NSArray *articles) {
                if (articles.count == 0) {
//                    self.articleArray = [NSMutableArray arrayWithArray:articles];
                    self.tableView.tableFooterView = self.noResultView;
                    self.noResultView.type = NoResultType;
                    //                DDLogInfo(@"%@", self.noResultView);
                } else {
                    self.articleArray = [NSMutableArray arrayWithArray:articles];
                }
//                NSLog(@"article count %ld", self.articleArray.count);
                
                [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView reloadData];
            } failure:^(NSInteger stateCode) {
                [self.tableView.pullToRefreshView stopAnimating];
            }];
        }
            break;
        case CategoryType:
        {
            self.filteredArray = [NSMutableArray array];
            for (GKEntityCategory *word in kAppDelegate.allCategoryArray) {
                NSString *screenName = word.categoryName;
                if ([PinyinTools ifNameString:screenName SearchString:searchText]) {
                    [_filteredArray addObject:word];
                }
            }
            [self.filteredArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
            [self.tableView.pullToRefreshView stopAnimating];
            if(self.filteredArray.count == 0)
            {
                self.tableView.tableFooterView = self.noResultView;
                self.noResultView.type = NoResultType;
            }
            [self.tableView reloadData];
        }
            break;
            
        case UserType:
        {
            [API searchUserWithString:self.keyword offset:0 count:30 success:^(NSArray *userArray) {
                if (userArray.count == 0) {
                    self.dataArrayForUserForSearch = [NSMutableArray arrayWithArray:userArray];
                    self.tableView.tableFooterView = self.noResultView;
                    self.noResultView.type = NoResultType;
                } else {
                    self.dataArrayForUserForSearch = [NSMutableArray arrayWithArray:userArray];
                }
                
                [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView reloadData];
            } failure:^(NSInteger stateCode) {
                [self.tableView.pullToRefreshView stopAnimating];
            }];
        }
            break;
    }
}


#pragma mark - <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.searchBar = searchController.searchBar;
//    DDLogInfo(@"keyword %@", searchController.searchBar.text);
    self.keyword = [searchController.searchBar.text Trimed];
    if (self.keyword.length == 0) {
        
        return;
    }
    [self.tableView triggerPullToRefresh];
    [self handleSearchText:self.keyword];
    

    
    
}

@end
