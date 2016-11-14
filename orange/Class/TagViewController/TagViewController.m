//
//  TagViewController.m
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "TagViewController.h"
//#import "HMSegmentedControl.h"
#import "EntitySingleListCell.h"
//#import "API.h"

@interface TagViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArrayForEntity;
//@property (nonatomic, assign) NSUInteger        index;
//@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation TagViewController

static NSString *EntityCellIdentifer = @"EntityCell";

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) : CGRectMake(0.f, 0.f, kScreenWidth - kTabBarWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
        
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundView = nil;
        _tableView.backgroundColor = UIColorFromRGB(0xffffff);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
    }
    return _tableView;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.tableView registerClass:[EntitySingleListCell class] forCellReuseIdentifier:EntityCellIdentifer];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.dataArrayForEntity.count == 0) {
//        [self.tableView.pullToRefreshView startAnimating];
//        [self refresh];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [AVAnalytics beginLogPageView:@"TagView"];
    [MobClick beginLogPageView:@"TagView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [AVAnalytics endLogPageView:@"TagView"];
    [MobClick endLogPageView:@"TagView"];
}


#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    if (self.dataArrayForEntity.count == 0) {
        [self.tableView triggerPullToRefresh];
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
    [API getEntityListWithUserId:self.user.userId tag:self.tagName offset:0 count:30 success:^(GKUser *user, NSArray *entityArray) {
        self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];

}
//
//- (void)loadMore
//{
//    if (self.index == 0) {
//        [API getEntityListWithUserId:self.user.userId tag:self.tagName offset:self.dataArrayForEntity.count count:30 success:^(GKUser *user, NSArray *entityArray) {
//            [self.dataArrayForEntity addObjectsFromArray:entityArray];
//            [self.tableView.infiniteScrollingView stopAnimating];
//            [self.tableView reloadData];
//        } failure:^(NSInteger stateCode) {
//            [self.tableView.infiniteScrollingView stopAnimating];
//        }];
//    }
//    else if (self.index == 1)
//    {
//
//    }
//    return;
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrayForEntity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:EntityCellIdentifer forIndexPath:indexPath];
    cell.entity = [self.dataArrayForEntity objectAtIndex:indexPath.row];
    return cell;
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EntitySingleListCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}

//
//#pragma mark - HMSegmentedControl
//- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    NSUInteger index = segmentedControl.selectedSegmentIndex;
//    self.index = index;
//    [self.tableView reloadData];
//    switch (index) {
//        case 0:
//        {
//            if (self.dataArrayForEntity.count ==0) {
//                [self refresh];
//            }
//        }
//            break;
//        case 1:
//        {
//            if (self.dataArrayForEntity.count ==0) {
//                [self refresh];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//}


@end
