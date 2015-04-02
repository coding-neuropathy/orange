//
//  TodayViewController.m
//  today
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HttpRequest.h"


@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) NSMutableArray * objects;

@end

@implementation TodayViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.objects = [NSMutableArray arrayWithCapacity:2];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"timestamp"];
    [paraDict setObject:@(2) forKey:@"count"];
    NSLog(@"http request with params %@", paraDict);
    [HttpRequest getDataWithParamters:paraDict URL:@"selection/" Block:^(id res, NSError *error) {
        if (!error) {
            NSLog(@"%@", res);
            self.objects = res;
            [self.tableView reloadData];
        }
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TodayCell"];
    self.preferredContentSize = CGSizeMake(self.preferredContentSize.width,  120.0);
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

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayCell" forIndexPath:indexPath];
//    cell.textLabel.text = @"test";
//    NSLog(@"%@", [self.objects objectAtIndex:indexPath.row]);
    NSDictionary * row = [self.objects objectAtIndex:indexPath.row];
    NSLog(@"note %@", row[@"content"][@"note"][@"content"]);
    cell.textLabel.text = row[@"content"][@"note"][@"content"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12.];
    cell.textLabel.numberOfLines = 0;
//    [cell.imageView ]
    return cell;
}


#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * row = [self.objects objectAtIndex:indexPath.row];
    NSString * entity_id = row[@"content"][@"entity"][@"entity_id"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"guoku://entity/%@", entity_id]];
    
    [self.extensionContext openURL:url completionHandler:nil];
}

@end
