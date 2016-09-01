//
//  AllOrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "AllOrderController.h"
#import "OrderCell.h"

@interface AllOrderController ()

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSMutableArray    *orderArray;

@end

@implementation AllOrderController

static NSString *CellIdentifer = @"OrderCell";

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[OrderCell class] forCellReuseIdentifier:CellIdentifer];
    
}



#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    
    return cell;
}

@end
