//
//  ActiveController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ActiveController.h"
#import "FeedCell.h"
#import "NoMessageView.h"

@interface ActiveController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayForFeed;
@property (nonatomic, strong) NoMessageView * noMessageView;

@end

@implementation ActiveController

static NSString *FeedCellIdentifier = @"FeedCell";

- (UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:IS_IPHONE?CGRectMake(0., 0., kScreenWidth, kScreenHeight):CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.deFrameSize = IS_IPAD    ? CGSizeMake(kPadScreenWitdh, kScreenHeight)
                                            : CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight);
        
        if (self.app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft
            || self.app.statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            _tableView.deFrameLeft = 128.;
        }
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
    }
    return _tableView;
}

- (NoMessageView *)noMessageView
{
    if (!_noMessageView) {
        _noMessageView = [[NoMessageView alloc] initWithFrame: IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - 200)
                                                                        : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - 200)];
        //        _noMessageView.backgroundColor = [UIColor redColor];
    }
    return _noMessageView;
}

- (void)loadView
{
//    self.view = self.tableView;
    [super loadView];
    
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor greenColor];
    if (IS_IPAD) self.navigationItem.title = NSLocalizedStringFromTable(@"activity", kLocalizedFile, nil);
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:FeedCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.scrollsToTop = YES;
//    [AVAnalytics beginLogPageView:@"ActiveView"];
    [MobClick beginLogPageView:@"ActiveView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
    
//    [AVAnalytics endLogPageView:@"ActiveView"];
    [MobClick endLogPageView:@"ActiveView"];
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
    if (self.dataArrayForFeed.count == 0)
    {
        [self.tableView triggerPullToRefresh];
    }
    
}

#pragma mark - get data
- (void)refresh
{
    [API getFeedWithTimestamp:[[NSDate date] timeIntervalSince1970] type:@"entity" scale:@"friend" success:^(NSArray *feedArray) {
        self.dataArrayForFeed = [NSMutableArray arrayWithArray:feedArray];
        if (self.dataArrayForFeed.count == 0) {
            self.tableView.tableFooterView = self.noMessageView;
            self.noMessageView.type = NoFeedType;
        } else {
            self.tableView.tableFooterView = nil;
        }
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    NSTimeInterval timestamp = [self.dataArrayForFeed.lastObject[@"time"] doubleValue];
    [API getFeedWithTimestamp:timestamp type:@"entity" scale:@"friend" success:^(NSArray *feedArray) {
        [self.dataArrayForFeed addObjectsFromArray:feedArray];
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrayForFeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell * cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier forIndexPath:indexPath];
    cell.feed = self.dataArrayForFeed[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeedCell height:self.dataArrayForFeed[indexPath.row]];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight || self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
             self.tableView.frame = CGRectMake(128., 0., kPadScreenWitdh, kScreenHeight);
         else
             self.tableView.frame = CGRectMake(0., 0., kPadScreenWitdh, kScreenHeight);
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

@end
