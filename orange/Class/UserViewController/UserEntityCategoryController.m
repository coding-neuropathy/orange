//
//  UserEntityCategoryController.m
//  orange
//
//  Created by 谢家欣 on 15/10/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserEntityCategoryController.h"

@interface UserEntityCategoryController ()

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * categoryArray;

@end

@implementation UserEntityCategoryController

static NSString * CellReuseIdentifiter = @"CellIdentifiter";

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, 220.) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - get data
- (void)refresh
{
    
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.7 alpha:0.8];
    self.view.deFrameTop = 108.;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifiter];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"OKOKOKKO");
    if (self.tapBlock) {
        self.tapBlock(nil);
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifiter forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKCategory * category = [self.categoryArray objectAtIndex:indexPath.row];
    
    if (self.tapBlock){
        self.tapBlock(category);
    }
}

@end
