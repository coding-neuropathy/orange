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
#import "GKWebVC.h"
#import "pinyin.h"
#import "PinyinTools.h"
#import "GroupViewController.h"
#import "EntitySingleListCell.h"
#import "UserSingleListCell.h"
#import "DiscoverHeaderView.h"
#import "GTScrollNavigationBar.h"
#import "NoSearchResultView.h"
#import "WebViewController.h"


@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate, DiscoverHeaderViewDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDC;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, strong) NSMutableArray * dataArrayForCategory;
@property(nonatomic, strong) NSMutableArray * dataArrayForArticle;

@property(nonatomic, strong) NSMutableArray * dataArrayForEntityForSearch;
@property(nonatomic, strong) NSMutableArray * dataArrayForUserForSearch;
@property(nonatomic, strong) NSMutableArray * dataArrayForLikeForSearch;

@property(nonatomic, strong) NSMutableArray * dataArrayForOffset;
@property(nonatomic, strong) NSMutableArray * dataArrayForOffsetForSearch;


@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) HMSegmentedControl *segmentedControl;
@property(nonatomic, strong) HMSegmentedControl *segmentedControlForSearch;

@property (nonatomic, strong) NSArray *bannerArray;
//@property (nonatomic, strong) UIScrollView *bannerScrollView;
//@property (nonatomic, strong) UIPageControl *bannerPageControl;
//@property (nonatomic, strong) NSTimer *bannerTimer;
@property (nonatomic, strong) DiscoverHeaderView * headerView;

@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NoSearchResultView * noResultView;

@end

@implementation DiscoverViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_discover"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_discover"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        self.tabBarItem = item;

        self.title = NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil);
   
    }
    return self;
}

- (DiscoverHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[DiscoverHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 150.f*kScreenWidth/320+34)];
        _headerView.backgroundColor = UIColorFromRGB(0xffffff);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NoSearchResultView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[NoSearchResultView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        
    }
    return _noResultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.navigationController.navigationBar setAlpha:0.99];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f,kNavigationBarHeight+kStatusBarHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.view addSubview:self.tableView];
    {
        UISwipeGestureRecognizer * leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        UISwipeGestureRecognizer * rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
        [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    }

    
    
    [self configSearchBar];
    
    if (!self.segmentedControl) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"popular", kLocalizedFile, nil), NSLocalizedStringFromTable(@"category", kLocalizedFile, nil)]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        [segmentedControl setTextColor:UIColorFromRGB(0x9d9e9f)];
        [segmentedControl setSelectedTextColor:UIColorFromRGB(0x414243)];
        [segmentedControl setSelectionIndicatorHeight:1.5];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xFF1F77)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.deFrameBottom = self.headerView.deFrameHeight;
        self.segmentedControl = segmentedControl;
        [self.headerView addSubview:self.segmentedControl];
        
        {
            UIView * V = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2,44/2-7, 1,14 )];
            V.backgroundColor = UIColorFromRGB(0xebebeb);
            [segmentedControl addSubview:V];
        }
    }

    
    self.tableView.tableHeaderView = self.headerView;
    
    
    [GKAPI getHomepageWithSuccess:^(NSDictionary *settingDict, NSArray *bannerArray, NSArray *hotCategoryArray, NSArray *hotTagArray) {
        // 过滤可处理的banner类型
        NSMutableArray *showBannerArray = [NSMutableArray array];
        for (NSDictionary *itemDict in bannerArray) {
            NSString *url = [[itemDict objectForKey:@"url"] lowercaseString];
            if ([url hasPrefix:@"guoku://entity"] ||
                [url hasPrefix:@"guoku://category"] ||
                [url hasPrefix:@"guoku://user"] ||
                [url hasPrefix:@"http://"]) {
                [showBannerArray addObject:itemDict];
            }
        }
        self.headerView.bannerArray = showBannerArray;
    } failure:nil];
    

    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
        [GKAPI getHomepageWithSuccess:^(NSDictionary *settingDict, NSArray *bannerArray, NSArray *hotCategoryArray, NSArray *hotTagArray) {
            // 过滤可处理的banner类型
            NSMutableArray *showBannerArray = [NSMutableArray array];
            for (NSDictionary *itemDict in bannerArray) {
                NSString *url = [[itemDict objectForKey:@"url"] lowercaseString];
                if ([url hasPrefix:@"guoku://entity"] ||
                    [url hasPrefix:@"guoku://category"] ||
                    [url hasPrefix:@"guoku://user"] ||
                    [url hasPrefix:@"http://"]) {
                    [showBannerArray addObject:itemDict];
                }
            }
            weakSelf.headerView.bannerArray = showBannerArray;
        } failure:nil];
    }];
    
    [self.tableView.pullToRefreshView startAnimating];
    [self.tableView reloadData];
    [self refresh];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
//    [self.tableView setcon]
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configFooter];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil)  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    [self.navigationController.navigationBar setAlpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [AVAnalytics beginLogPageView:@"DiscoverView"];
    [MobClick beginLogPageView:@"DiscoverView"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*
    [self.navigationController.navigationBar setAlpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
     */
    [self.searchBar resignFirstResponder];
    
    [AVAnalytics endLogPageView:@"DiscovreView"];
    [MobClick endLogPageView:@"DiscovreView"];
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
            [self.tableView.pullToRefreshView stopAnimating];
                        [self.tableView reloadData];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [self.tableView.pullToRefreshView stopAnimating];
                        [self.tableView reloadData];
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
            [categoryGroupArray saveToUserDefaultsForKey:CategoryGroupArrayWithStatusKey];
            [fullCategoryGroupArray saveToUserDefaultsForKey:CategoryGroupArrayKey];
            [allCategoryArray saveToUserDefaultsForKey:AllCategoryArrayKey];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
    
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            
        }];
    }
    return;
}
- (void)loadMore
{
    if(self.segmentedControlForSearch.selectedSegmentIndex == 1)
    {
        [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
        return;
    }
    else if(self.segmentedControlForSearch.selectedSegmentIndex == 0)
    {
        [GKAPI searchEntityWithString:self.keyword type:@"all" offset:self.dataArrayForEntityForSearch.count count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
            if (self.dataArrayForEntityForSearch.count == 0) {
                self.dataArrayForEntityForSearch = [NSMutableArray array];
            }
            [self.dataArrayForEntityForSearch addObjectsFromArray:entityArray];
            [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
        } failure:^(NSInteger stateCode) {
                    [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if(self.segmentedControlForSearch.selectedSegmentIndex == 2)
    {
        [GKAPI searchUserWithString:self.keyword offset:self.dataArrayForUserForSearch.count count:30 success:^(NSArray *userArray) {
            if (self.dataArrayForUserForSearch.count == 0) {
                self.dataArrayForUserForSearch = [NSMutableArray array];
            }
            [self.dataArrayForUserForSearch addObjectsFromArray:userArray];
            [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
        } failure:^(NSInteger stateCode) {
                    [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if(self.segmentedControlForSearch.selectedSegmentIndex == 3)
    {
        [GKAPI searchEntityWithString:self.keyword type:@"like" offset:self.dataArrayForLikeForSearch.count count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
            if (self.dataArrayForLikeForSearch.count == 0) {
                self.dataArrayForLikeForSearch = [NSMutableArray array];
            }
            [self.dataArrayForLikeForSearch addObjectsFromArray:entityArray];
            [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
        } failure:^(NSInteger stateCode) {
                    [self.searchDC.searchResultsTableView.infiniteScrollingView stopAnimating];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableView)
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
    else
    {
        return 1;
    }
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
            return ceil(((NSMutableArray *)[[self.dataArrayForCategory objectAtIndex:section] objectForKey:@"CategoryArray"]).count /(CGFloat)4);
        }
        return 0;
    }
    else
    {
         NSInteger index = self.segmentedControlForSearch.selectedSegmentIndex;
        if (index == 1)
        {
            return ceil(self.filteredArray.count /(CGFloat)4);
        }
        else if(index == 0)
        {
            return self.dataArrayForEntityForSearch.count;
        }
        else if(index == 2)
        {
            return self.dataArrayForUserForSearch.count;
        }
        else if(index == 3)
        {
            return self.dataArrayForLikeForSearch.count;
        }
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
            cell.backgroundColor = UIColorFromRGB(0xf8f8f8);
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
        
        NSInteger index = self.segmentedControlForSearch.selectedSegmentIndex;
        if (index == 1) {
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
        else if(index == 0)
        {
            static NSString *CellIdentifier = @"EntitySingleListCell";
            EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.entity = [self.dataArrayForEntityForSearch objectAtIndex:indexPath.row];
            return cell;
        
        }
        else if(index == 2)
        {
            static NSString *CellIdentifier = @"UserSingleListCell";
            UserSingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UserSingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.user = [self.dataArrayForUserForSearch objectAtIndex:indexPath.row];
            
            return cell;
            
        }
        else if(index == 3)
        {
            static NSString *CellIdentifier = @"EntitySingleListCell";
            EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.entity = [self.dataArrayForLikeForSearch objectAtIndex:indexPath.row];
            return cell;
            
        }
        
        return [UITableViewCell new];
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
        NSInteger index = self.segmentedControlForSearch.selectedSegmentIndex;
        if (index == 1) {
            return [CategoryGridCell height];
        }
        else if (index == 0)
        {
            return [EntitySingleListCell height];
        }
        else if (index == 2)
        {
            return [UserSingleListCell height];
        }
        else if (index == 3)
        {
            return [EntitySingleListCell height];
        }
        return 0;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        if (self.index == 1) {
            return 40;
        }
    }
    else
    {
        return 44;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        if(self.index == 1)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 12.f, CGRectGetWidth(tableView.frame)-20, 20.f)];
            label.text = [self.dataArrayForCategory[section] valueForKey:@"GroupName"];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont boldSystemFontOfSize:14];
            [label sizeToFit];
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 32)];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:label];
            
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            button.tag =section;
            [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FAAngleRight] forState:UIControlStateNormal];
            button.deFrameRight = kScreenWidth -10;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(categoryGroupButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [view addSubview:button];

            
            UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 11)];
            countLabel.font = [UIFont systemFontOfSize:12];
            countLabel.textAlignment = NSTextAlignmentRight;
            countLabel.textColor = UIColorFromRGB(0x9d9e9f);
            countLabel.hidden = NO;
            countLabel.center = label.center;
            [countLabel setText:[NSString stringWithFormat:@"%@个品类",[self.dataArrayForCategory[section] valueForKey:@"Count"]]];
            countLabel.deFrameWidth = ([[self.dataArrayForCategory[section] valueForKey:@"Count"] stringValue].length -1)*12 +100;
            countLabel.center = label.center;
            countLabel.deFrameRight = kScreenWidth - 20;
            [view addSubview:countLabel];
            
            return view;
        }
    }
    else{
        
        if (!self.segmentedControlForSearch) {
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            [segmentedControl setSectionTitles:@[ @"商品",@"品类",@"用户",@"喜爱"]];
            [segmentedControl setSelectedSegmentIndex:0 animated:NO];
            [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
            [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
            [segmentedControl setTextColor:UIColorFromRGB(0x9d9e9f)];
            [segmentedControl setSelectedTextColor:UIColorFromRGB(0x414243)];
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
        
        return self.segmentedControlForSearch;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    if(segmentedControl == self.segmentedControl)
    {
        NSUInteger index = segmentedControl.selectedSegmentIndex;
        self.index = index;
        CGFloat y = [[self.dataArrayForOffset objectAtIndexedSubscript:self.segmentedControl.selectedSegmentIndex] floatValue];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, y) animated:NO];
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
    else if(segmentedControl == self.segmentedControlForSearch)
    {
     
        CGFloat y = [[self.dataArrayForOffsetForSearch objectAtIndexedSubscript:self.segmentedControlForSearch.selectedSegmentIndex] floatValue];
        [self.searchDC.searchResultsTableView reloadData];
        [self.searchDC.searchResultsTableView setContentOffset:CGPointMake(0, y) animated:NO];
        NSUInteger index = segmentedControl.selectedSegmentIndex;
        switch (index) {
            case 1:
            {
                [self handleSearchText:self.keyword];
            }
                break;
            case 0:
            {
                if (self.dataArrayForEntityForSearch.count == 0) {
                    [self handleSearchText:self.keyword];
                }
            }
                break;
            case 2:
            {
                if (self.dataArrayForUserForSearch.count == 0) {
                    [self handleSearchText:self.keyword];
                }
            }
                break;
            case 3:
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
    self.searchBar.placeholder = NSLocalizedStringFromTable(@"search", kLocalizedFile, nil);

    
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchDC.displaysSearchBarInNavigationBar = YES;
    self.searchDC.searchResultsDataSource = self;
    self.searchDC.searchResultsDelegate = self;
    self.searchDC.delegate = self;
    self.searchDC.searchResultsTableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.searchDC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDC.searchResultsTableView.separatorColor = UIColorFromRGB(0xffffff);
    self.searchDC.searchResultsTableView.tableHeaderView = nil;
    
    __weak __typeof(&*self)weakSelf = self;
    
    /*
    [self.searchDC.searchResultsTableView addPullToRefreshWithActionHandler:^{
        [weakSelf handleSearchText:self.keyword];
    }];
     */

     [self.searchDC.searchResultsTableView addInfiniteScrollingWithActionHandler:^{
         [weakSelf loadMore];
     }];
    
    {
        UISwipeGestureRecognizer * leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipesForSearch:)];
        UISwipeGestureRecognizer * rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipesForSearch:)];
        
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.searchDC.searchResultsTableView addGestureRecognizer:leftSwipeGestureRecognizer];
        [self.searchDC.searchResultsTableView addGestureRecognizer:rightSwipeGestureRecognizer];
    }
    
}

#pragma mark - Header View Delegate
- (void)TapBannerImageAction:(NSDictionary *)dict
{
    NSString * url = dict[@"url"];
    [AVAnalytics event:@"banner" attributes:@{@"url": url}];
    [MobClick event:@"banner" attributes:@{@"url": url}];
    if ([url hasPrefix:@"http://"]) {
        if (k_isLogin) {
            NSRange range = [url rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&session=%@",[Passport sharedInstance].session]];
            }
            else
            {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"?session=%@",[Passport sharedInstance].session]];
            }
        }
        NSRange range = [url rangeOfString:@"out_link"];
        if (range.location == NSNotFound) {
//            GKWebVC * VC = [GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:url]];
            WebViewController * VC = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        if (!self.dataArrayForOffset) {
            self.dataArrayForOffset = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),nil];
        }
        [self.dataArrayForOffset setObject:@(scrollView.contentOffset.y) atIndexedSubscript:self.segmentedControl.selectedSegmentIndex];
    }
    else
    {
        if (!self.dataArrayForOffsetForSearch) {
            self.dataArrayForOffsetForSearch = [NSMutableArray arrayWithObjects:@(-64),@(-64),@(-64),@(-64),nil];
        }
        [self.dataArrayForOffsetForSearch setObject:@(scrollView.contentOffset.y) atIndexedSubscript:self.segmentedControlForSearch.selectedSegmentIndex];
    }

    
}

#pragma mark - SearchBar

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    for(UIView * v in controller.searchContentsController.view.subviews)
    {
        if([v isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")])
        {
            //v.alpha = 0
            for(UIView * v1 in v.subviews)
            {
                for(UIView * v2 in v1.subviews)
                {
//                    NSLog(@"%@",[v2 class]);
                    if([v2 isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])
                    {
                        v2.backgroundColor = [UIColor clearColor];
                    }
                }
            }
        }
        
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [[self.searchDC.searchContentsController.view viewWithTag:999] removeFromSuperview];
    return YES;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.97];
    view.tag = 999;
    
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_search"]];
    image.center = CGPointMake(kScreenWidth/2, 0);
    image.deFrameTop = 50+kStatusBarHeight+kNavigationBarHeight;
    [view addSubview:image];
    
    [self.searchDC.searchContentsController.view addSubview:view];
    return YES;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    [searchBar setShowsCancelButton:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([searchText length] == 0) {
        [self.searchDC.searchContentsController.view viewWithTag:999].hidden = NO;
    }
    else
    {
        [self.searchDC.searchContentsController.view viewWithTag:999].hidden = YES;
    }
    
    self.dataArrayForUserForSearch = nil;
    self.dataArrayForEntityForSearch = nil;
    self.dataArrayForLikeForSearch = nil;
    
    self.keyword = self.searchBar.text;
    self.keyword = [self.keyword stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self handleSearchText:self.keyword];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * searchText = self.searchBar.text;
    if ([searchText length] == 0) {
        return;
    }
    self.keyword = searchText;
    [self searchButtonAction];
}
- (void)handleSearchText:(NSString *)searchText
{
    if(self.segmentedControlForSearch.selectedSegmentIndex == 1)
    {
        self.filteredArray = [NSMutableArray array];
        for (GKEntityCategory *word in kAppDelegate.allCategoryArray) {
            NSString *screenName = word.categoryName;
            if ([PinyinTools ifNameString:screenName SearchString:searchText]) {
                [_filteredArray addObject:word];
            }
        }
        [self.filteredArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
        [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
    }
    else if(self.segmentedControlForSearch.selectedSegmentIndex == 0)
    {
        [GKAPI searchEntityWithString:self.keyword type:@"all" offset:0 count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
            self.dataArrayForEntityForSearch = [NSMutableArray arrayWithArray:entityArray];
                    [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
        } failure:^(NSInteger stateCode) {
                    [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
        }];
    }
    else if(self.segmentedControlForSearch.selectedSegmentIndex == 2)
    {
        [GKAPI searchUserWithString:self.keyword offset:0 count:30 success:^(NSArray *userArray) {
            self.dataArrayForUserForSearch = [NSMutableArray arrayWithArray:userArray];
                    [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
        } failure:^(NSInteger stateCode) {
                    [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
        }];
    }
    else if(self.segmentedControlForSearch.selectedSegmentIndex == 3)
    {
        [GKAPI searchEntityWithString:self.keyword type:@"like" offset:0 count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
            self.dataArrayForLikeForSearch = [NSMutableArray arrayWithArray:entityArray];
                    [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
            [self.searchDC.searchResultsTableView reloadData];
        } failure:^(NSInteger stateCode) {
                    [self.searchDC.searchResultsTableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (void)searchButtonAction
{
    [AVAnalytics event:@"search" attributes:@{@"keyword": self.keyword}];
    [MobClick event:@"search" attributes:@{@"keyword": self.keyword}];
    [self handleSearchText:self.keyword];
}

- (void)categoryGroupButtonAction:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        NSUInteger tag = ((UIButton *)sender).tag;
        GroupViewController * vc = [[GroupViewController alloc]initWithGid:[[self.dataArrayForCategory[tag] valueForKey:@"GroupId"]integerValue]];
        vc.navigationItem.title = [self.dataArrayForCategory[tag] valueForKey:@"GroupName"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)configFooter
{
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 23)];
    footer.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.tableView.tableFooterView = footer;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,100)];
    view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    
    UIView * H = [[UIView alloc] initWithFrame:CGRectMake(20,45, kScreenWidth-40, 0.5)];
    H.backgroundColor = UIColorFromRGB(0xebebeb);
    [view addSubview:H];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 120, 20.f)];
    label.backgroundColor = UIColorFromRGB(0xf8f8f8);
    label.font = [UIFont fontWithName:@"FultonsHand" size:14];
    label.center = CGPointMake(kScreenWidth/2, 45);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Live Different";
    label.textColor = UIColorFromRGB(0xcbcbcb);
    [view addSubview:label];
    
    [footer addSubview:view];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self.segmentedControl setSelectedSegmentIndex:1 animated:YES notify:YES];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.segmentedControl setSelectedSegmentIndex:0 animated:YES notify:YES];
    }
    
}

- (void)handleSwipesForSearch:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.segmentedControlForSearch.selectedSegmentIndex !=3) {
            [self.segmentedControlForSearch setSelectedSegmentIndex:self.segmentedControlForSearch.selectedSegmentIndex+1 animated:YES notify:YES];
        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.segmentedControlForSearch.selectedSegmentIndex !=0) {
            [self.segmentedControlForSearch setSelectedSegmentIndex:self.segmentedControlForSearch.selectedSegmentIndex-1 animated:YES notify:YES];
        }
    }
    
}





@end
