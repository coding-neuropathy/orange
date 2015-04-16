//
//  FanViewController.m
//  orange
//
//  Created by huiter on 15/1/28.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "FanViewController.h"
#import "UserSingleListCell.h"
#import "GKAPI.h"
#import "NoDataView.h"

@interface FanViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayForUser;
@property (nonatomic, strong) NoDataView * noDataView;

@end

@implementation FanViewController

- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, 44.)];
        _noDataView.backgroundColor = [UIColor clearColor];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.title = NSLocalizedStringFromTable(@"followers", kLocalizedFile, nil);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"fanView"];
    [MobClick beginLogPageView:@"fanView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"fanView"];
    [MobClick endLogPageView:@"fanView"];
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
    
    [GKAPI getUserFanListWithUserId:self.user.userId offset:0 count:30 success:^(NSArray *userArray) {
        self.dataArrayForUser = [NSMutableArray arrayWithArray:userArray];
        if (self.dataArrayForUser.count == 0) {
            self.tableView.tableFooterView = self.noDataView;
            self.noDataView.text = @"没有任何粉丝";
        } else {
            self.tableView.tableFooterView = nil;
        }
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"加载失败"];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
}
- (void)loadMore
{
    [GKAPI getUserFanListWithUserId:self.user.userId offset:self.dataArrayForUser.count count:30 success:^(NSArray *userArray) {
        [self.dataArrayForUser addObjectsFromArray:userArray];
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"加载失败"];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrayForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"UserSingleListCell";
    UserSingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UserSingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.user = [self.dataArrayForUser objectAtIndex:indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserSingleListCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

@end
