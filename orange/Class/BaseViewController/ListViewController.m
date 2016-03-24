//
//  ListViewController.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "ListViewController.h"

static NSString * CellIdentifer = @"Cell";

@interface ListViewController ()

@end

@implementation ListViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
//        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
//        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.tableView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifer];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    return cell;
}



@end

