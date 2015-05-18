//
//  TodayViewController.m
//  today
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
//#import "HttpRequest.h"
#import "core.h"
#import "TodayViewCell.h"
//#import "UIImageView+AFNetworking.h"


@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation TodayViewController

- (void)loadView
{
    [super loadView];
    self.dataArray = [self getCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.objects = [NSMutableArray arrayWithCapacity:2];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"timestamp"];
    [paraDict setObject:@(3) forKey:@"count"];

    [self.tableView registerClass:[TodayViewCell class] forCellReuseIdentifier:@"TodayCell"];
//    NSLog(@"width %f", self.preferredContentSize.width);
//    self.preferredContentSize = CGSizeMake(self.preferredContentSize.width,  160.);
    self.tableView.rowHeight = 60.;
    self.preferredContentSize = CGSizeMake(self.preferredContentSize.width, self.tableView.rowHeight * 3);
    ;
    self.tableView.separatorColor = UIColorFromRGB(0xebebeb);
}


/**
 * 取消 widget 默认 inset
 */
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    [API getTopTenEntityCount:3 success:^(NSArray *array) {
//        NSLog(@"%@", array);
        self.dataArray = (NSMutableArray *)array;
        [self save];
        [self.tableView reloadData];
        completionHandler(NCUpdateResultNewData);
    } failure:^(NSInteger stateCode) {
//        NSLog(@"error %lu", (long)stateCode);
        self.dataArray = [self getCache];
        [self.tableView reloadData];
        completionHandler(NCUpdateResultNoData);
    }];
    
    
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
    NSString * entity_id = row[@"content"][@"entity"][@"entity_id"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"guoku://entity/%@", entity_id]];
    
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

- (NSMutableArray *)getCache
{
    NSData * archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TodayArray"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}

- (void)save
{
//    [self.dataArray]
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dataArray] forKey:@"TodayArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
