//
//  FriendViewController.m
//  orange
//
//  Created by huiter on 15/1/28.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "FriendViewController.h"
#import "UserSingleListCell.h"
//#import "API.h"
#import "NoDataView.h"

static NSString *CellIdentifier = @"UserSingleListCell";

@interface FriendViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayForUser;
@property (nonatomic, strong) NoDataView * noDataView;
/* 下拉刷新次数 */
@property (nonatomic, assign) NSInteger refreshNum;
@end

@implementation FriendViewController

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
    self.title = NSLocalizedStringFromTable(@"following", kLocalizedFile, nil);
    
    _tableView = [[UITableView alloc] initWithFrame:IS_IPHONE?CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight):CGRectMake(0.f, 0.f, kScreenWidth - kTabBarWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.tableView registerClass:[UserSingleListCell class] forCellReuseIdentifier:CellIdentifier];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [AVAnalytics beginLogPageView:@"friendView"];
    [MobClick beginLogPageView:@"friendView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [AVAnalytics endLogPageView:@"friendView"];
    [MobClick endLogPageView:@"friendView"];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        //        [weakSelf.entityList refreshWithCategoryId:weakSelf.cateId];
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        //        [weakSelf.entityList loadWithCategoryId:weakSelf.cateId];
        [weakSelf loadMore];
    }];
    
    if (self.dataArrayForUser.count == 0)
    {
        [self.tableView triggerPullToRefresh];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         self.tableView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark - Data
- (void)refresh
{

        [API getUserFollowingListWithUserId:self.user.userId offset:0 count:30 success:^(NSArray *userArray) {
            self.dataArrayForUser = [NSMutableArray arrayWithArray:userArray];
            if (self.dataArrayForUser.count == 0) {
                self.tableView.tableFooterView = self.noDataView;
                self.noDataView.text = @"没有关注任何人";
            } else {
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            self.refreshNum = 1;
            
        } failure:^(NSInteger stateCode) {
            //[SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [SVProgressHUD dismiss];
            [self.tableView.pullToRefreshView stopAnimating];
        }];

}
- (void)loadMore
{
    [API getUserFollowingListWithUserId:self.user.userId offset:self.refreshNum * 30 count:30 success:^(NSArray *userArray) {
        [self.dataArrayForUser addObjectsFromArray:userArray];
    
        [self.tableView reloadData];
        
        self.refreshNum += 1;
        
        [self.tableView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        //[SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [SVProgressHUD dismiss];
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
    UserSingleListCell *cell    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.user                   = [self.dataArrayForUser objectAtIndex:indexPath.row];
    cell.TapAvatarAction        = ^(GKUser *user) {
        [[OpenCenter sharedOpenCenter] openWithController:self User:user];
    };
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [UIView new];
//}


@end
