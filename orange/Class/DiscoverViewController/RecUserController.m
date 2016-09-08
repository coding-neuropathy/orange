//
//  RecUserController.m
//  orange
//
//  Created by D_Collin on 16/2/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "RecUserController.h"

#import "UserSingleListCell.h"
#import "NoDataView.h"



@interface RecUserController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong)UITableView * tableView;

@property (nonatomic , strong)NSMutableArray * dataArrayForUser;

@property (nonatomic , strong)NoDataView * noDataView;

@property (nonatomic , assign)NSInteger page;

@end

@implementation RecUserController

static NSString * CellIdentifier = @"UserSingleListCell";

- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[NoDataView alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, 44.)];
        _noDataView.backgroundColor = [UIColor clearColor];
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:IS_IPHONE ? CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) : CGRectMake(0.f, 0.f, kScreenWidth - kTabBarWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
        
        _tableView              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.deFrameSize  = IS_IPAD ? CGSizeMake(kPadScreenWitdh, kScreenHeight)
                                        : CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
        
        if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight
            || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft)
            _tableView.center = CGPointMake((kScreenWidth - kTabBarWidth) / 2, kScreenHeight / 2);
        _tableView.dataSource   = self;
        _tableView.delegate     = self;
        _tableView.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.sep
        self.tableView.showsVerticalScrollIndicator = YES;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.title = NSLocalizedStringFromTable(@"recommendation user", kLocalizedFile, nil);
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.tableView registerClass:[UserSingleListCell class] forCellReuseIdentifier:CellIdentifier];

}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    [self refresh];
    if (self.dataArrayForUser == 0) {
        [self.tableView triggerPullToRefresh];
    }
    
}

#pragma mark - Data
- (void)refresh
{
    self.page = 1;
    
    [API getAuthorizedUserWithPage:self.page Size:30 success:^(NSArray *users, NSInteger page) {
        self.dataArrayForUser = [NSMutableArray arrayWithArray:users];
        self.page += 1;
        if (self.dataArrayForUser.count == 0) {
            self.tableView.tableFooterView = self.noDataView;
            self.noDataView.text = @"暂无认证用户";
        }
        else
        {
            self.tableView.tableFooterView = nil;
        }
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
}
- (void)loadMore
{
    
    [API getAuthorizedUserWithPage:self.page Size:30 success:^(NSArray *users, NSInteger page) {
        [self.dataArrayForUser addObjectsFromArray:users];
        self.page += 1;
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD dismiss];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
//         self.tableView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight
             || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
             self.tableView.frame = CGRectMake(128., 0., kPadScreenWitdh, kScreenHeight);
         else
             self.tableView.frame = CGRectMake(0., 0., kPadScreenWitdh, kScreenHeight);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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
    UserSingleListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
