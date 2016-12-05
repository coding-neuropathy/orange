//
//  RecUserController.m
//  orange
//
//  Created by D_Collin on 16/2/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "RecUserController.h"
#import "UserSingleListCell.h"


@interface RecUserController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic ,strong)   UITableView     *tableView;
@property (nonatomic ,strong)   NSMutableArray  *dataArrayForUser;
@property (nonatomic ,assign)   NSInteger       page;

@end

@implementation RecUserController

static NSString * CellIdentifier = @"UserSingleListCell";

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.deFrameSize  = IS_IPAD ? CGSizeMake(kPadScreenWitdh, kScreenHeight)
                                        : CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
        
        if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight
            || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft)
            _tableView.center = CGPointMake((kScreenWidth - kTabBarWidth) / 2, kScreenHeight / 2);
        
        _tableView.dataSource                   = self;
        _tableView.delegate                     = self;
        _tableView.backgroundColor              = kBackgroundColor;
        _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        
        _tableView.emptyDataSetDelegate         = self;
        _tableView.emptyDataSetSource           = self;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"recommendation user", kLocalizedFile, nil);
    
    [self.view addSubview:self.tableView];
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
    
//    [self refresh];
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
//        if (self.dataArrayForUser.count == 0) {
////            self.tableView.tableFooterView = self.noDataView;
////            self.noDataView.text = @"暂无认证用户";
//        }
//        else
//        {
//            self.tableView.tableFooterView = nil;
//        }
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
    cell.TapAvatarAction    =  ^(GKUser *user) {
        [[OpenCenter sharedOpenCenter] openUser:user];
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


#pragma mark - <DZNEmptyDataSetSource>
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{

//    NSString * text = NSLocalizedStringFromTable(@"no-data", kLocalizedFile, nil);
    NSString    *text = @"暂无认证用户";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:kFontAwesomeFamilyName size:14.],
                                 NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#9d9e9f"],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
