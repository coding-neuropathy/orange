//
//  NotifactionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NotifactionViewController.h"
#import "HMSegmentedControl.h"
#import "API.h"
#import "MessageCell.h"
#import "FeedCell.h"
#import "GTScrollNavigationBar.h"
#import "NoMessageView.h"


static NSString *FeedCellIdentifier = @"FeedCell";
static NSString *MessageCellIdentifier = @"MessageCell";

@interface NotifactionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForFeed;
@property(nonatomic, strong) NSMutableArray * dataArrayForMessage;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) HMSegmentedControl *segmentedControl;
@property(nonatomic, strong) NSMutableArray * dataArrayForOffset;

@property (nonatomic, strong) NoMessageView * noMessageView;

@end

@implementation NotifactionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle: NSLocalizedStringFromTable(@"notify", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_notifaction"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_notifaction"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        self.tabBarItem = item;
        self.index = 0;
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    
    self.title = NSLocalizedStringFromTable(@"notify", kLocalizedFile, nil);

}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        
        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"activity", kLocalizedFile, nil), NSLocalizedStringFromTable(@"message", kLocalizedFile, nil)]];
        [_segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        [_segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        [_segmentedControl setTextColor:UIColorFromRGB(0x9d9e9f)];
        [_segmentedControl setSelectedTextColor:UIColorFromRGB(0x414243)];
        [_segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
        [_segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xFF1F77)];
        [_segmentedControl setSelectionIndicatorHeight:1.5];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setTag:2];
        
        
        UIView * V = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2,44/2-7, 1,14 )];
        V.backgroundColor = UIColorFromRGB(0xebebeb);
        [_segmentedControl addSubview:V];
    }
    return _segmentedControl;
}

- (NoMessageView *)noMessageView
{
    if (!_noMessageView) {
        _noMessageView = [[NoMessageView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - 200)];
//        _noMessageView.backgroundColor = [UIColor redColor];
    }
    return _noMessageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadge) name:@"ShowBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBadge) name:@"HideBadge" object:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0XF8F8F8);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    
    UISwipeGestureRecognizer * leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer * rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];

    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:FeedCellIdentifier];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:MessageCellIdentifier];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    if (kAppDelegate.messageCount) {
        [self addBadge];
    }
    else
    {
        [self removeBadge];
    }
    [AVAnalytics beginLogPageView:@"NotificationView"];
    [MobClick beginLogPageView:@"NotificationView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"NotificationView"];
    [MobClick endLogPageView:@"NotificationView"];
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
    else if (self.index == 1)
    {
        [API getMessageListWithTimestamp:[[NSDate date] timeIntervalSince1970]  count:30 success:^(NSArray *messageArray) {
            self.dataArrayForMessage = [NSMutableArray arrayWithArray:messageArray];
            if (self.dataArrayForMessage.count == 0) {
                self.tableView.tableFooterView = self.noMessageView;
                self.noMessageView.type = NoMessageType;
            } else {
                self.tableView.tableFooterView = nil;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBadge" object:nil userInfo:nil];
            [self.tableView reloadData];
            
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    return;
}
- (void)loadMore
{
    if (self.index == 0) {
        NSTimeInterval timestamp = [self.dataArrayForFeed.lastObject[@"time"] doubleValue];
        [API getFeedWithTimestamp:timestamp type:@"entity" scale:@"friend" success:^(NSArray *feedArray) {
            [self.dataArrayForFeed addObjectsFromArray:feedArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        NSTimeInterval timestamp = [self.dataArrayForMessage.lastObject[@"time"] doubleValue];
        [API getMessageListWithTimestamp:timestamp count:30 success:^(NSArray *messageArray) {
            [self.dataArrayForMessage addObjectsFromArray:messageArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
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
//        static NSString *CellIdentifier = @"FeedCell";
        FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
    
        cell.feed = self.dataArrayForFeed[indexPath.row];
        return cell;
    }
    else if (self.index == 1)
    {
//        static NSString *CellIdentifier = @"MessageCell";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
        cell.message = self.dataArrayForMessage[indexPath.row];
        return cell;
    }
    return [[UITableViewCell alloc] init];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        return [FeedCell height:self.dataArrayForFeed[indexPath.row]];
        
    }
    else if (self.index == 1)
    {
        return [MessageCell height:self.dataArrayForMessage[indexPath.row]];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.segmentedControl;
    }
    else
    {
        return nil;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        if (self.dataArrayForMessage.count == 0 && self.index == 1) {
//            return kScreenHeight;
//        }
//    }
//    return 0.;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        if (self.dataArrayForMessage.count == 0 && self.index == 1)
//            return self.noMessageView;
//    }
//    return nil;
//}

#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    self.index = index;
    CGFloat y = [[self.dataArrayForOffset objectAtIndexedSubscript:self.segmentedControl.selectedSegmentIndex] floatValue];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, y) animated:NO];
    switch (index) {
        case 0:
        {
            if (self.dataArrayForFeed.count == 0) {
                [self.tableView triggerPullToRefresh];
            }
        }
            break;
        case 1:
        {
            if (self.dataArrayForMessage.count == 0) {
                [self.tableView triggerPullToRefresh];
            }
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
            break;
            
        default:
            break;
    }
}

- (void)addBadge
{
    [self removeBadge];
    [self tabBadge:YES];
}

- (void)removeBadge
{
    [self tabBadge:NO];
}

- (void)tabBadge:(BOOL)yes
{
    if (yes) {
        UILabel * badge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
        badge.backgroundColor = UIColorFromRGB(0xFF1F77);
        badge.tag = 100;
        badge.layer.cornerRadius = 3;
        badge.layer.masksToBounds = YES;
        badge.center = CGPointMake(kScreenWidth*3/4+24,10);
        [self.segmentedControl addSubview:badge];
    }
    else
    {
        [[self.segmentedControl viewWithTag:100]removeFromSuperview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        if (!self.dataArrayForOffset) {
            self.dataArrayForOffset = [NSMutableArray arrayWithObjects:@(0),@(0),nil];
        }
        [self.dataArrayForOffset setObject:@(scrollView.contentOffset.y) atIndexedSubscript:self.segmentedControl.selectedSegmentIndex];
    }
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self.segmentedControl setSelectedSegmentIndex:1 animated:YES notify:YES];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.segmentedControl setSelectedSegmentIndex:0 animated:YES notify:YES];
    }
    
}

@end
