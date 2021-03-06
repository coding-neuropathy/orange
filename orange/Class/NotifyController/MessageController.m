//
//  MessageController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "ArticleWebViewController.h"
//#import "NoMessageView.h"

@interface MessageController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayForMessage;
//@property (nonatomic, strong) NoMessageView * noMessageView;

@end

@implementation MessageController

static NSString *MessageCellIdentifier = @"MessageCell";

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.deFrameSize = IS_IPAD    ? CGSizeMake(kPadScreenWitdh, kScreenHeight)
                                            : CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight);
        
        if (self.app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft
            || self.app.statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            _tableView.deFrameLeft = 128.;
        }
        
        _tableView.dataSource                   = self;
        _tableView.delegate                     = self;
        _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.emptyDataSetSource           = self;
        _tableView.emptyDataSetDelegate         = self;
    }
    return _tableView;
}

//- (NoMessageView *)noMessageView
//{
//    if (!_noMessageView) {
//        _noMessageView = [[NoMessageView alloc] initWithFrame:IS_IPHONE?CGRectMake(0., 0., kScreenWidth, kScreenHeight - 200):CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - 200)];
//        //        _noMessageView.backgroundColor = [UIColor redColor];
//    }
//    return _noMessageView;
//}

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
//    self.view.backgroundColor = [UIColor redColor];
    if (IS_IPAD) self.navigationItem.title = NSLocalizedStringFromTable(@"message", kLocalizedFile, nil);

    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:MessageCellIdentifier];
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
//    [AVAnalytics beginLogPageView:@"MessageView"];
    [MobClick beginLogPageView:@"MessageView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
    
//    [AVAnalytics endLogPageView:@"MessageView"];
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
    
    cell.tapLinkBlock   = ^(NSURL   *url) {
            NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
            if([array[0] isEqualToString:@"user"])
            {
                GKUser * user = [GKUser modelFromDictionary:@{@"userId":@([array[1] integerValue])}];
                [[OpenCenter sharedOpenCenter] openWithController:self User:user];
            }
            if([array[0] isEqualToString:@"entity"])
            {
                GKEntity * entity = [GKEntity modelFromDictionary:@{@"entityId":@([array[1] integerValue])}];
//                [[OpenCenter sharedOpenCenter] openWithController:self Entity:entity];
                [[OpenCenter sharedOpenCenter] openEntity:entity];
            }
    };
    
    __weak __typeof(&*cell)weakCell = cell;
    cell.tapImageBlock  = ^(MessageType type) {
            switch (type) {
                case MessageArticlePoke:
                {
                    GKArticle                   *article        = weakCell.message[@"content"][@"article"];
                    ArticleWebViewController    *articleVC      = [[ArticleWebViewController alloc] initWithArticle:article];
                    [self.navigationController pushViewController:articleVC animated:YES];
                    
                }
                    break;
        
                default:
                {
                    GKNote *note = weakCell.message[@"content"][@"note"];
                    DDLogInfo(@"entity note %@", note.entityId);
                    GKEntity *entity;
                    
                    if (!note) {
                        entity    = weakCell.message[@"content"][@"entity"];
//                        [[OpenCenter sharedOpenCenter] openWithController:self Entity:entity];
                        [[OpenCenter sharedOpenCenter] openEntity:entity];
                    } else {
                    
                        entity    = [GKEntity modelFromDictionary:@{@"entity_id":note.entityId}];
//                        [[OpenCenter sharedOpenCenter] openWithController:self Entity:entity];
                        [[OpenCenter sharedOpenCenter] openEntity:entity];
                        
                    }
//                    GKEntity    *entity    = weakCell.message[@"content"][@"entity"];
//
                    [MobClick event:@"message_forward_entity"];
                }
                    break;
            }
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell height:self.dataArrayForMessage[indexPath.row]];
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

#pragma mark - <DZNEmptyDataSetSource>
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    //    NSString *text = NSLocalizedStringFromTable(@"no-order", kLocalizedFile, nil);
    NSString * text = @"没有任何消息";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:kFontAwesomeFamilyName size:14.],
                                 NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#9d9e9f"],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当有人关注你、点评你添加的商品或发生任何与你相关的事件时，会在这里通知你";;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#9d9e9f"],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_notifaction.png"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -30.;
}

#pragma mark - <DZNEmptyDataSetDelegate>
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    DDLogInfo(@"%s",__FUNCTION__);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}

@end
