//
//  OrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderController.h"

@interface OrderController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView * tableView;
//@property (strong, nonatomic) 

@end

@implementation OrderController

#pragma mark - lazy load view
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView                      = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.emptyDataSetSource   = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title          = NSLocalizedStringFromTable(@"order", kLocalizedFile, nil);
}

#pragma mark - <DZNEmptyDataSetSource>


#pragma mark - <DZNEmptyDataSetDelegate>

@end
