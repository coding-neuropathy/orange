//
//  DiscoverViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "DiscoverViewController.h"
#import "HMSegmentedControl.h"
#import "GKAPI.h"
#import "EntityThreeGridCell.h"
#import "CategoryGridCell.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDC;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, strong) NSMutableArray * dataArrayForCategory;
@property(nonatomic, strong) NSMutableArray * dataArrayForArticle;
@property(nonatomic, assign) NSUInteger index;
@end

@implementation DiscoverViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_icon_eye"] selectedImage:[UIImage imageNamed:@"tabbar_icon_eye"]];
        
        self.tabBarItem = item;
        
        self.title = @"发现";
        
        
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
        [segmentedControl setSectionTitles:@[@"热门商品", @"推荐分类",@"人气图文"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationNone];
        [segmentedControl setTextColor:UIColorFromRGB(0x343434)];
        [segmentedControl setSelectedTextColor:UIColorFromRGB(0x2b2b2b)];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0x999999)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentedControl];
        
        [self configSearchBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 32.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight -kTabBarHeight-32) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    /*
     [self.tableView addInfiniteScrollingWithActionHandler:^{
     [weakSelf loadMore];
     }];
     */
    
    [self.tableView.pullToRefreshView startAnimating];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Data
- (void)refresh
{
    if (self.index == 0) {
        [GKAPI getHotEntityListWithType:@"weekly" success:^(NSArray *dataArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:dataArray];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        [GKAPI getAllCategoryWithSuccess:^(NSArray *fullCategoryGroupArray) {
        
                NSMutableArray *categoryGroupArray = [NSMutableArray array];
                NSMutableArray *allCategoryArray = [NSMutableArray array];
                
                for (NSDictionary *groupDict in fullCategoryGroupArray) {
                    NSArray *categoryArray = groupDict[@"CategoryArray"];
                    
                    NSMutableArray *filteredCategoryArray = [NSMutableArray array];
                    for (GKEntityCategory *category in categoryArray) {
                        [allCategoryArray addObject:category];
                        
                        if (category.status) {
                            [filteredCategoryArray addObject:category];
                        }
                    }
                    NSDictionary *filteredGroupDict = @{@"GroupId"       : groupDict[@"GroupId"],
                                                        @"GroupName"     : groupDict[@"GroupName"],
                                                        @"Status"        : groupDict[@"Status"],
                                                        @"Count"         : @(categoryArray.count),
                                                        @"CategoryArray" : filteredCategoryArray};
                    if ([groupDict[@"Status"] integerValue] > 0) {
                        [categoryGroupArray addObject:filteredGroupDict];
                    }
                }
            
            self.dataArrayForCategory = categoryGroupArray;
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
    
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            
        }];
    }
    return;
}
- (void)loadMore
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.index == 0) {
        return 1;
    }
    else if (self.index == 1)
    {
        return ceil(self.dataArrayForCategory.count / (CGFloat)1);
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        if (self.index == 0) {
            return ceil(self.dataArrayForEntity.count / (CGFloat)3);
        }
        else if (self.index == 1)
        {
            return (((NSMutableArray *)[[self.dataArrayForCategory objectAtIndex:section] objectForKey:@"CategoryArray"]).count /(CGFloat)4);
        }
        return 0;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        if (self.index == 0) {
            static NSString *CellIdentifier = @"EntityCell";
            EntityThreeGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[EntityThreeGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSArray *entityArray = self.dataArrayForEntity;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSUInteger offset = indexPath.row * 3;
            for (NSUInteger i = 0; i < 3 && offset < entityArray.count; i++) {
                [array addObject:entityArray[offset++]];
            }
            
            cell.entityArray = array;
            
            return cell;
        }
        else if (self.index == 1)
        {
            static NSString *CellIdentifier = @"CategoryCell";
            CategoryGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[CategoryGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSDictionary *groupDict = self.dataArrayForCategory[indexPath.section];
            NSArray *categoryDictArray = [groupDict objectForKey:@"CategoryArray"];
            
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
        return [[UITableViewCell alloc] init];
    }
    else
    {
        return [[UITableViewCell alloc] init];
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        if (self.index == 0) {
            return [EntityThreeGridCell height];
        }
        else if (self.index == 1)
        {
            return [CategoryGridCell height];
        }
        return 0;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        if(self.index == 1)
        {
            return 32;
        }
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        
        if(self.index == 1)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 6.f, CGRectGetWidth(tableView.frame)-20, 20.f)];
            label.text = [self.dataArrayForCategory[section] valueForKey:@"GroupName"];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont boldSystemFontOfSize:14];
            [label sizeToFit];
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 32)];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:label];
            
            return view;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    self.index = index;
    [self.tableView reloadData];
    switch (index) {
        case 0:
        {

        }
            break;
        case 1:
        {
            if (self.dataArrayForCategory.count == 0) {
                [self.tableView.pullToRefreshView startAnimating];
                [self refresh];
            }
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ConfigSearchBar
- (void)configSearchBar
{
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)];
    self.searchBar.tintColor = UIColorFromRGB(0x666666);
    
    [self.searchBar setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(10, 48)] stretchableImageWithLeftCapWidth:5 topCapHeight:5]  forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(10, 28)]  forState:UIControlStateNormal];
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(2.f, 0.f);
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = self.searchBar;
    
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchDC.searchResultsDataSource = self;
    self.searchDC.searchResultsDelegate = self;
    self.searchDC.searchResultsTableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.searchDC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDC.searchResultsTableView.separatorColor = UIColorFromRGB(0xffffff);
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.searchDC setActive:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDC setActive:NO];
    return YES;
}
@end
