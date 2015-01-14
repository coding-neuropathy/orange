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
        
        
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 45)];
        [segmentedControl setSectionTitles:@[@"热门商品", @"推荐分类",@"人气图文"]];
        [segmentedControl setSelectedIndex:0];
        [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
        [segmentedControl setTextColor:UIColorFromRGB(0x999999)];
        [segmentedControl setSelectionIndicatorColor:[UIColor clearColor]];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 45.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight -kTabBarHeight-45) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
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
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        
    }
    return;
}
- (void)loadMore
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return ceil(self.dataArrayForEntity.count / (CGFloat)3);
    }
    else if (self.index == 1)
    {
        return ceil(self.dataArrayForArticle.count / (CGFloat)1);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        static NSString *CellIdentifier = @"Cell";
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
        return [[UITableViewCell alloc] init];
    }
    return [[UITableViewCell alloc] init];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        return [EntityThreeGridCell height];
    }
    else if (self.index == 1)
    {
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedIndex;
    self.index = index;
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
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
    
    [self.searchBar setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xe3e3e3) andSize:CGSizeMake(10, 48)] stretchableImageWithLeftCapWidth:5 topCapHeight:5]  forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(2.f, 0.f);
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.showsSearchResultsButton = NO;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = self.searchBar;
    
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchDC.searchResultsDataSource = self;
    self.searchDC.searchResultsDelegate = self;
    self.searchDC.searchResultsTableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.searchDC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDC.searchResultsTableView.separatorColor = UIColorFromRGB(0xffffff);
    
}

@end
