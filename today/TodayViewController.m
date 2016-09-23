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

@property (strong, nonatomic) NSMutableArray    *dataArray;
@property (strong, nonatomic) MMWormhole        *wormhole;

@end

@implementation TodayViewController


- (MMWormhole *)wormhole
{
    if (!_wormhole) {
        _wormhole   = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.guoku.iphone"
                                                           optionalDirectory:@"wormhole"];
    }
    return _wormhole;
}

- (void)loadView
{
    [super loadView];
//    NSLog(@"%@", self.dataArray);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor   = [UIColor clearColor];
    
    [self.tableView registerClass:[TodayViewCell class] forCellReuseIdentifier:@"TodayCell"];
//    NSLog(@"width %f", self.preferredContentSize.width);
//    self.preferredContentSize = CGSizeMake(self.preferredContentSize.width,  160.);
    
    
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
        [API getTopTenEntityCount:3 success:^(NSArray *array) {
            self.dataArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
//            [self save];
            completionHandler(NCUpdateResultNewData);
        } failure:^(NSInteger stateCode) {
            completionHandler(NCUpdateResultFailed);
        }];
    } else {
        completionHandler(NCUpdateResultNoData);
    }
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
    return self.dataArray.count;
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
    
    NSDictionary * row = [self.dataArray objectAtIndex:indexPath.row];
    GKEntity * entity = row[@"entity"];
//    NSString * entity_id = row[@"content"][@"entity"][@"entity_id"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"guoku://entity/%@", entity.entityId]];
    
    [self.extensionContext openURL:url completionHandler:nil];
}

#pragma mark - cache 
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _dataArray;
}


@end
