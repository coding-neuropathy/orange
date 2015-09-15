//
//  MessageController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "NoMessageView.h"

@interface MessageController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayForMessage;
@property (nonatomic, strong) NoMessageView * noMessageView;

@end

@implementation MessageController

static NSString *MessageCellIdentifier = @"MessageCell";

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
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
        _noMessageView = [[NoMessageView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - 200)];
        //        _noMessageView.backgroundColor = [UIColor redColor];
    }
    return _noMessageView;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:MessageCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.scrollsToTop = YES;
    
    [AVAnalytics beginLogPageView:@"MessageView"];
    [MobClick beginLogPageView:@"MessageView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
    
    [AVAnalytics endLogPageView:@"MessageView"];
    [MobClick endLogPageView:@"MessageView"];
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
    if (self.dataArrayForMessage.count == 0)
    {
        [self.tableView triggerPullToRefresh];
    }
    
}

#pragma mark - get data
- (void)refresh
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

- (void)loadMore
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
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrayForMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier forIndexPath:indexPath];
    
    cell.message = self.dataArrayForMessage[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell height:self.dataArrayForMessage[indexPath.row]];
}
@end
