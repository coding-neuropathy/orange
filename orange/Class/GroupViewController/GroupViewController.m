//
//  GroupViewController.m
//  Blueberry
//
//  Created by huiter on 13-11-9.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "GroupViewController.h"
#import "CategoryGridCell.h"
#import "CategoryViewController.h"
#import "API.h"
#import "Config.h"
@interface GroupViewController ()
@property (nonatomic, strong) NSArray *categoryGroupArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *firstCategoryArray;
@property (nonatomic, strong) NSMutableArray *secondCategoryArray;
@end

@implementation GroupViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithGid:(NSUInteger)gid
{
    self = [super init];
    if (self) {
        _gid = gid;
    }
    return self;
}

#pragma mark - Private Method

- (void)refresh
{
    self.categoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey];
    for (NSDictionary * dic in self.categoryGroupArray) {
        NSUInteger gid = [dic[@"GroupId"] integerValue];
        if (gid == self.gid) {
            self.categoryArray = [NSMutableArray arrayWithArray:dic[@"CategoryArray"]];
            [self.categoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
            [self splitArray];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)splitArray
{
    //if (!self.firstCategoryArray) {
        _firstCategoryArray = [NSMutableArray array];
    //}
    //if (!self.secondCategoryArray) {
        _secondCategoryArray = [NSMutableArray array];
    //}
    
    for (GKEntityCategory *category in self.categoryArray) {
        if (category.status > 0) {
            [self.firstCategoryArray addObject:category];
        } else {
            [self.secondCategoryArray addObject:category];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return ceil(self.firstCategoryArray.count/(CGFloat)4);
    } else {
        return ceil(self.secondCategoryArray.count/(CGFloat)4);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CategoryGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setType:CategoryCridItemTypeForFourWithIcon];
    }
    
    NSArray *categoryDictArray;
    if (indexPath.section == 0) {
        categoryDictArray = self.firstCategoryArray;
    } else {
        categoryDictArray = self.secondCategoryArray;
    }
    
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        NSUInteger offset = indexPath.row * 4;
        int i = 0;
        for (; offset < categoryDictArray.count ; offset++) {
            [categoryArray addObject:categoryDictArray[offset]];
            i++;
            if (i>=4) {
                break;
            }
        }
        
        cell.categoryArray = categoryArray;
        return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CategoryGridCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

        if (section == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 8.f, CGRectGetWidth(tableView.frame)-20, 20.f)];
            label.text = @"优选品类";
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont boldSystemFontOfSize:14];
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 36)];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:label];
            
            return view;
        }
        else
        {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 8.f, CGRectGetWidth(tableView.frame)-20, 20.f)];
            label.text = @"普通品类";
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont boldSystemFontOfSize:14];
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 36)];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:label];
            
            return view;
        }
}

#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    if(iOS7)
    {
        //_tableView.frame = CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
    [AVAnalytics beginLogPageView:@"GroupView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"GroupView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
