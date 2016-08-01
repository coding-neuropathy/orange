//
//  MenuController.m
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MenuController.h"
#import "MenuHeaderView.h"
#import "MenuCell.h"
#import "LoginView.h"
static NSString * const CellReuseIdentifier = @"MenuCell";

@interface MenuController () <UITableViewDelegate, UITableViewDataSource, MenuHeaderViewDelegate>

@property (strong, nonatomic) MenuHeaderView * headerView;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray * titleArray;

@end

@implementation MenuController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray = @[
                            @"selected",
                            @"articles",
                            @"discover",
                            @"activity",
                            @"message",
                            @"settings",
                            ];
        
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - init header view
- (MenuHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[MenuHeaderView alloc] initWithFrame:CGRectMake(0., 0., kTabBarWidth, kTabBarWidth + 20)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - init table view
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., 84., kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = UIColorFromRGB(0x0a0a0a);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = 84.;
    }
    return _tableView;
}

- (void)loadView
{
    self.view = self.tableView;
    
    [self.tableView registerClass:[MenuCell class] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"Logout" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Logout" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.text = [self.titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(MenuController:didSelectRowAtIndexPath:)]) {
        [_delegate MenuController:self didSelectRowAtIndexPath:indexPath];
    }
    
    
}

#pragma mark - <MasterHeaderViewDelegate>
- (void)TapAvatarBtn
{
    //    DDLogError(@"OKOKOKOKOKOO");
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    if (k_isLogin) {
//        DDLogError(@"login login");
        if (_delegate && [_delegate respondsToSelector:@selector(MenuController:didSelectRowAtIndexPath:)]) {
            [self.delegate MenuController:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.titleArray.count inSection:0]];
        }
    } else {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
}

#pragma mark notification

- (void)login
{
    [self.headerView layoutSubviews];
}

- (void)logout
{
    [self.headerView layoutSubviews];
}

#pragma mark - Passport KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    DDLogInfo(@"key key %@", keyPath);
    if ([keyPath isEqualToString:@"avatarURL"]) {
        [self.headerView layoutSubviews];
    }
}


@end
