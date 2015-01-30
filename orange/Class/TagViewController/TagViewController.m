//
//  TagViewController.m
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "TagViewController.h"
#import "HMSegmentedControl.h"
#import "EntitySingleListCell.h"
#import "GKAPI.h"

@interface TagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight -kTabBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.view addSubview:self.tableView];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 32)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    if (!self.segmentedControl) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
        [segmentedControl setSectionTitles:@[@"私人标签", @"全部"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationNone];
        [segmentedControl setTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setSelectedTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xe4f0fc)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xcde3fb)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.deFrameBottom = headerView.deFrameHeight;
        self.segmentedControl = segmentedControl;
        [headerView addSubview:self.segmentedControl];
        self.index = 0;
    }
    
    
    self.tableView.tableHeaderView = headerView;
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.dataArrayForEntity.count == 0) {
        [self.tableView.pullToRefreshView startAnimating];
        [self refresh];
    }

}

- (void)setTagName:(NSString *)tagName
{
    _tagName = tagName;
    self.title = [NSString stringWithFormat:@"#%@",tagName];
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
        [GKAPI getEntityListWithUserId:self.user.userId tag:self.tagName offset:0 count:30 success:^(GKUser *user, NSArray *entityArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        } failure:^(NSInteger stateCode) {
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
    if (self.index == 0) {
        [GKAPI getEntityListWithUserId:self.user.userId tag:self.tagName offset:0 count:30 success:^(GKUser *user, NSArray *entityArray) {
            [self.dataArrayForEntity addObjectsFromArray:entityArray];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
        } failure:^(NSInteger stateCode) {
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {

    }
    return;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.index == 0) {
        return 1;
    }
    else if (self.index == 1)
    {
        return 1;
    }
    else if (self.index == 2)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 1) {
        return ceil(self.dataArrayForEntity.count / (CGFloat)1);
    }
    else if (self.index == 0)
    {
        return ceil(self.dataArrayForEntity.count / (CGFloat)1);
    }

    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        static NSString *CellIdentifier = @"EntitySingleListCell";
        EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.entity = [self.dataArrayForEntity objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.index == 1)
    {

    }

    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 1) {
        [EntitySingleListCell height];
    }
    else if (self.index == 0)
    {
        return [EntitySingleListCell height];
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
            if (self.dataArrayForEntity.count ==0) {
                [self refresh];
            }
        }
            break;
        case 1:
        {
            if (self.dataArrayForEntity.count ==0) {
                [self refresh];
            }
        }
            break;
            
        default:
            break;
    }
    
}


@end
