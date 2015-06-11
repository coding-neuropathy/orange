//
//  EntityLikerController.m
//  orange
//
//  Created by 谢家欣 on 15/6/10.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityLikerController.h"
#import "UserSingleListCell.h"

@interface EntityLikerController ()

@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger page;

@end

@implementation EntityLikerController

static NSString *CellIdentifier = @"UserCell";

- (instancetype)initWithEntity:(GKEntity *)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
        self.page = 1;
    }
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xffffff);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.rowHeight = 74.;
    }
    return _tableView;
}

#pragma mark - get data
- (void)refresh
{
    [API getEntityLikerWithEntityId:self.entity.entityId Page:self.page success:^(NSArray *dataArray, NSInteger page) {
        DDLogInfo(@"%@", dataArray);
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.page = page;
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getEntityLikerWithEntityId:self.entity.entityId Page:self.page success:^(NSArray *dataArray, NSInteger page) {
        DDLogInfo(@"%@", dataArray);
        [self.dataArray addObjectsFromArray:dataArray];
//        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.page = page;
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UserSingleListCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.title = [NSString stringWithFormat:@"%ld 人喜欢", self.entity.likeCount];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    //
    if (self.dataArray.count <= 0) {
        [self.tableView triggerPullToRefresh];
    }
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [UserSingleListCell height];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserSingleListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.user = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

@end
