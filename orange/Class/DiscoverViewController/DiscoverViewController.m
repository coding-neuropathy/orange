//
//  DiscoverViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "DiscoverViewController.h"
#import "HMSegmentedControl.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDC;
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
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        [segmentedControl setTextColor:UIColorFromRGB(0x343434)];
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
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
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


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    //NSLog(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedIndex);
    NSUInteger index = segmentedControl.selectedIndex;
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

@end
