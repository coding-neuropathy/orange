//
//  SearchTipsController.m
//  orange
//
//  Created by 谢家欣 on 16/8/31.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SearchTipsController.h"

@interface SearchTipsController ()

@property (strong, nonatomic) NSArray       *historyArray;
@property (strong, nonatomic) NSArray       *hotArray;
@property (strong, nonatomic) UITableView   *tableView;
@property (weak,   nonatomic) UIApplication *app;

@end

@implementation SearchTipsController

static NSString * CellIndetifier = @"Cell";

- (UIApplication *)app
{
    if (!_app) {
        _app    = [UIApplication sharedApplication];
    }
    return _app;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView                  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.deFrameSize      = IS_IPAD   ? CGSizeMake(kPadScreenWitdh, kScreenHeight)
                                                : CGSizeMake(kScreenWidth, kScreenHeight);
        
//        if (self.app.statusBarOrientation == uir)
//        if (IS_IPAD) _tableView.deFrameLeft = (kScreenWidth - kTabBarWidth - kPadScreenWitdh) / 2.;
        if (self.app.statusBarOrientation == UIInterfaceOrientationLandscapeRight
            || self.app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
            _tableView.center = CGPointMake((kScreenWidth - kTabBarWidth) / 2, kScreenHeight / 2);
        
        _tableView.dataSource       = self;
        _tableView.delegate         = self;
    }
    return _tableView;
}

- (void)loadView
{
//    self.view       = self.tableView;
    [super loadView];
    self.view.backgroundColor       = [UIColor colorFromHexString:@"#ffffff"];
}

- (void)viewDidLoad
{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIndetifier];
    
    [API getSearchKeywordsWithSuccess:^(NSArray *keywords) {
//            DDLogInfo(@"keywords %@", keywords);
        self.hotArray       = keywords;
        self.historyArray   = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs];
        [self.tableView reloadData];
//            [self.searchView setHotArray:keywords withRecentArray:nil];
    } Failure:^(NSInteger stateCode, NSError *error) {
    
    }];
    DDLogInfo(@"log log %@", [[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs]);
    [super viewDidLoad];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count   = [self.historyArray count] > 2 ? 2 : self.historyArray.count;
            break;
        default:
            count   = self.hotArray.count;
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell      = [tableView dequeueReusableCellWithIdentifier:CellIndetifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            
            cell.textLabel.text         = [self.historyArray objectAtIndex:indexPath.row];
            break;
            
        default:
            cell.textLabel.text         = [self.hotArray objectAtIndex:indexPath.row];
            break;
    }
    
    cell.textLabel.font         = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
    cell.textLabel.textColor    = [UIColor colorFromHexString:@"#212121"];
    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height  = 44.;
    switch (section) {
        case 0:
            height  = self.historyArray.count > 0 ? 44. : 0.;
            break;
            
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * tipsView           = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel * tipsLabel         = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsLabel.frame             = CGRectMake(10., 12., 200., 20.);
    switch (section) {
        case 0:
            tipsLabel.text              = NSLocalizedStringFromTable(@"history-search", kLocalizedFile, nil);
            break;
        default:
            tipsLabel.text              = NSLocalizedStringFromTable(@"popular-search", kLocalizedFile, nil);
            break;
    }
    tipsLabel.textColor         = [UIColor colorFromHexString:@"#212121"];
    tipsLabel.font              = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
    tipsView.backgroundColor    = [UIColor colorFromHexString:@"#f1f1f1"];
    
    [tipsView addSubview:tipsLabel];
    return tipsView;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.tapRecordBtnBlock) {
        self.tapRecordBtnBlock(cell.textLabel.text);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
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
