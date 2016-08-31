//
//  AlluserResultController.m
//  orange
//
//  Created by D_Collin on 16/7/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "AlluserResultController.h"
#import "UserSingleListCell.h"
#import "NoDataView.h"


@interface AlluserResultController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong)UITableView * tableView;

@property (nonatomic , strong)NSMutableArray * dataArrayForUser;

@property (nonatomic , strong)NoDataView * noDataView;



@end

@implementation AlluserResultController

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
        _tableView = [[UITableView alloc]initWithFrame:IS_IPHONE ? CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) : CGRectMake(0.f, 0.f, kScreenWidth - kTabBarWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xffffff);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = YES;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.title = NSLocalizedStringFromTable(@"users", kLocalizedFile, nil);
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

- (void)refresh
{
    [API searchUserWithString:self.keyword offset:0 count:30 success:^(NSArray *userArray) {
        if (userArray.count == 0) {
            
            self.dataArrayForUser = [NSMutableArray arrayWithArray:userArray];
            self.tableView.tableFooterView = self.noDataView;
            
        }
        else
        {
            self.dataArrayForUser = [NSMutableArray arrayWithArray:userArray];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API searchUserWithString:self.keyword offset:self.dataArrayForUser.count count:30 success:^(NSArray *userArray) {
        if (self.dataArrayForUser.count == 0) {
            self.dataArrayForUser = [NSMutableArray array];
        }
        [self.dataArrayForUser addObjectsFromArray:userArray];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
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
         
         self.tableView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
