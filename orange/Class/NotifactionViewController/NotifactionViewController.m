//
//  NotifactionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NotifactionViewController.h"
#import "HMSegmentedControl.h"
#import "GKAPI.h"

@interface NotifactionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForFeed;
@property(nonatomic, strong) NSMutableArray * dataArrayForMessage;
@property(nonatomic, assign) NSUInteger index;

@end

@implementation NotifactionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"通知" image:[UIImage imageNamed:@"notifaction"] selectedImage:[UIImage imageNamed:@"notifaction"]];
        
        self.tabBarItem = item;
        
        self.title = @"通知";
        
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
        [segmentedControl setSectionTitles:@[@"动态", @"消息"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationNone];
        [segmentedControl setTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setSelectedTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xe4f0fc)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xcde3fb)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl setTag:2];
        self.navigationItem.titleView =  segmentedControl;
        self.index = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight -kTabBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    
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

    }
    else if (self.index == 1)
    {
        [SVProgressHUD showImage:nil status:@"失败"];
        [self.tableView.pullToRefreshView stopAnimating];
    }
    return;
}
- (void)loadMore
{
    if (self.index == 0) {

    }
    else if (self.index == 1)
    {
        [SVProgressHUD showImage:nil status:@"失败"];
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    return;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return ceil(self.dataArrayForFeed.count / (CGFloat)1);
    }
    else if (self.index == 1)
    {
        return ceil(self.dataArrayForMessage.count / (CGFloat)1);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        
        if (1) {
            return [[UITableViewCell alloc]init];
        }
        else
        {
            return [[UITableViewCell alloc]init];
        }
        
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
        if (1) {
            return 100;
        }
        else
        {
            return 100;
        }
        
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
            
        }
            break;
            
        default:
            break;
    }
}

@end
