//
//  UserEntityCategoryController.m
//  orange
//
//  Created by 谢家欣 on 15/10/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserEntityCategoryController.h"

@interface UserEntityCategoryController ()


@property (strong, nonatomic) NSMutableArray * categoryArray;
@property (strong, nonatomic) NSString * language;

@end

@implementation UserEntityCategoryController

static NSString * CellReuseIdentifiter = @"CellIdentifiter";

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *languages = [NSLocale preferredLanguages];
//        NSLog(@"%@", languages);
        self.language = [languages objectAtIndex:0];
    }
    return self;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
//    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, 242.) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.98];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - get data
- (void)refresh
{
    [API getGroupCategoryWithSuccess:^(NSArray *categories) {
        
        self.categoryArray = [NSMutableArray arrayWithArray:categories];
        
        GKCategory * category = [GKCategory modelFromDictionary:@{@"id":@(0), @"title":NSLocalizedStringFromTable(@"all", kLocalizedFile, nil)}];
        
        [self.categoryArray insertObject:category atIndex:0];
//        NSLog(@"OKOKOKOKOKO %@", self.categoryArray);
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        
    }];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.32];
    self.view.deFrameTop = 108.;
    [self.view addSubview:self.tableView];
    
    [self refresh];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifiter forIndexPath:indexPath];
//    cell.textLabel.text =
    cell.backgroundColor = [UIColor clearColor];
    GKCategory * category = [self.categoryArray objectAtIndex:indexPath.row];
    if ([self.language hasPrefix:@"en"]) {
        cell.textLabel.text = category.title_en;
    } else {
        cell.textLabel.text = category.title_cn;
    }
    cell.textLabel.textColor = UIColorFromRGB(0x9d9e9f);
    cell.textLabel.font = [UIFont systemFontOfSize:14.];
    cell.textLabel.highlightedTextColor = UIColorFromRGB(0x6eaaf0);
    cell.
    
    if (![cell.contentView viewWithTag:10000]) {
        UIView * H = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        H.backgroundColor = UIColorFromRGB(0xe6e6e6);
        H.tag = 10000;
        [cell.contentView addSubview:H];
        [cell.contentView bringSubviewToFront:H];
    }

    
    if (self.currentIndex == category.groupId) {
        cell.textLabel.textColor = UIColorFromRGB(0x6eaaf0);
    }

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
