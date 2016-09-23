//
//  TodayViewController.m
//  today
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayViewCell.h"
//#import "UIImageView+AFNetworking.h"


@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) GKPopularEntity     *dataArray;

@end

@implementation TodayViewController

- (void)dealloc
{
    [self.dataArray removeTheObserverWithObject:self];
}
//
//- (void)loadView
//{
//    [super loadView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor   = [UIColor clearColor];
    
    [self.tableView registerClass:[TodayViewCell class] forCellReuseIdentifier:@"TodayCell"];

    self.tableView.rowHeight = 94.;
    
//    self.tableView.separatorColor = UIColorFromRGB(0xebebeb);
    
    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.tableView.backgroundView   = blur;
    self.tableView.separatorEffect  = [UIVibrancyEffect effectForBlurEffect:(UIBlurEffect*)blur.effect];
    
    self.preferredContentSize = CGSizeMake(0., self.tableView.rowHeight * 3);
    
    
    if (iOS10) {
//        self.preferredContentSize = CGSizeMake(0., self.tableView.rowHeight * 3);
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
//        self.tableView.backgroundColor = [UIColor clearColor];
        
    }
}

- (void)didReceiveMemoryWarning {
    
    [[SDImageCache sharedImageCache] clearMemory];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <NCWidgetProviding>
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    
    if (self.dataArray.count == 0) {
        [self.dataArray refresh];
    }
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(0., 94.);
    } else {
        self.preferredContentSize = CGSizeMake(0., 94 * 3.);
    }
}


/**
 * 取消 widget 默认 inset
 */
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

//- (void)receivedAdditionalContent
//{
//    self.preferredContentSize = [self sizeNeededToShowAdditionalContent];
//}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count > 3 ? 3 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayCell" forIndexPath:indexPath];
    NSDictionary * row = [self.dataArray objectAtIndex:indexPath.row];
    cell.data = row;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TodayViewCell *cell    = [tableView cellForRowAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"guoku://entity/%@", cell.entity.entityId]];
    
    [self.extensionContext openURL:url completionHandler:nil];
}

#pragma mark - cache 
- (GKPopularEntity *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[GKPopularEntity alloc] init];
        
        [_dataArray getDataFromWomhole];
        [_dataArray addTheObserverWithObject:self];
    }
    return _dataArray;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isRefreshing"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.dataArray.error) {
                [self.tableView reloadData];
            } else {
                
            }
        }
    }
    if ([keyPath isEqualToString:@"isLoading"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.dataArray.error) {
                [self.tableView reloadData];
            } else {
                
            }
        }
    }
    
}


@end
