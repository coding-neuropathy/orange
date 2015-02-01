//
//  CategoryViewController.m
//  orange
//
//  Created by huiter on 15/1/29.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "CategoryViewController.h"
#import "HMSegmentedControl.h"
#import "GKAPI.h"
#import "EntityThreeGridCell.h"
#import "EntitySingleListCell.h"

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, strong) NSMutableArray * dataArrayForLike;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.view addSubview:self.tableView];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 32)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    if (!self.segmentedControl) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
        [segmentedControl setSectionTitles:@[@"单列", @"三栏",@"我喜爱的"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationNone];
        [segmentedControl setTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setSelectedTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xe4f0fc)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xcde3fb)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.deFrameBottom = headerView.deFrameHeight;
        self.segmentedControl = segmentedControl;
        [headerView addSubview:self.segmentedControl];
    }
    
    
    self.tableView.tableHeaderView = headerView;
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    

    [self.tableView addInfiniteScrollingWithActionHandler:^{
     [weakSelf loadMore];
     }];
     
    
    [self.tableView.pullToRefreshView startAnimating];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)setCategory:(GKEntityCategory *)category
{
    _category = category;
    UIView *titleView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 26, 26)];
    icon.contentMode =UIViewContentModeScaleAspectFit;
    icon.backgroundColor = [UIColor clearColor];
    [icon sd_setImageWithURL:self.category.iconURL placeholderImage:nil options:SDWebImageRetryFailed];
    [titleView addSubview:icon];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setText:([self.category.categoryName componentsSeparatedByString:@"-"][0])];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.textColor = UIColorFromRGB(0x555555);
    label.adjustsFontSizeToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    label.center = icon.center;
    
    titleView.deFrameWidth = label.deFrameWidth + icon.deFrameWidth * 2 +10;
    [titleView addSubview:label];
    if (self.category.iconURL) {
        label.center = CGPointMake(titleView.frame.size.width/2+8, titleView.frame.size.height/2);
        icon.hidden = NO;
        icon.deFrameRight = label.deFrameLeft - 5;
    }
    else
    {
        icon.hidden = YES;
        label.center = CGPointMake(titleView.frame.size.width/2, titleView.frame.size.height/2);
    }
    
    
    self.navigationItem.titleView = titleView;
}
#pragma mark - Data
- (void)refresh
{
    if (self.index == 0) {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 2)
    {
        [GKAPI getLikeEntityListWithCategoryId:self.category.categoryId userId:[Passport sharedInstance].user.userId sort:@"" reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
            self.dataArrayForLike = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    return;
}
- (void)loadMore
{
    if (self.index == 0) {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:NO offset:self.dataArrayForEntity.count count:30 success:^(NSArray *entityArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:NO offset:self.dataArrayForEntity.count count:30 success:^(NSArray *entityArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 2)
    {
        [GKAPI getLikeEntityListWithCategoryId:self.category.categoryId userId:[Passport sharedInstance].user.userId sort:@"" reverse:NO offset:self.dataArrayForEntity.count count:30 success:^(NSArray *entityArray) {
            self.dataArrayForLike = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    return;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.index == 0) {
        return 1;
    }
    else if (self.index == 1)
    {
        return 1;
    }
    else if (self.index == 2)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (self.index == 1) {
            return ceil(self.dataArrayForEntity.count / (CGFloat)3);
        }
        else if (self.index == 0)
        {
            return ceil(self.dataArrayForEntity.count / (CGFloat)1);
        }
        else if (self.index == 2)
        {
            return ceil(self.dataArrayForLike.count / (CGFloat)3);
        }
        return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        static NSString *CellIdentifier = @"EntitySingleListCell";
        EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.entity = [self.dataArrayForEntity objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.index == 1)
    {
        static NSString *CellIdentifier = @"EntityCell";
        EntityThreeGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EntityThreeGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSArray *entityArray = self.dataArrayForEntity;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSUInteger offset = indexPath.row * 3;
        for (NSUInteger i = 0; i < 3 && offset < entityArray.count; i++) {
            [array addObject:entityArray[offset++]];
        }
        
        cell.entityArray = array;
        
        return cell;
    }
    else if (self.index == 2)
    {
        static NSString *CellIdentifier = @"EntitySingleListCell";
        EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.entity = [self.dataArrayForLike objectAtIndex:indexPath.row];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.index == 1) {
            return [EntityThreeGridCell height];
        }
        else if (self.index == 0)
        {
            return [EntitySingleListCell height];
        }
        else if (self.index == 2)
        {
            return [EntitySingleListCell height];
        }
        return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    self.index = index;
    [self.tableView reloadData];
    switch (index) {
        case 0:
        {
            if (self.dataArrayForEntity.count ==0) {
                [self refresh];
            }
        }
            break;
        case 1:
        {
            if (self.dataArrayForEntity.count ==0) {
                [self refresh];
            }
        }
            break;
        case 2:
        {
            if (self.dataArrayForLike.count ==0) {
                [self refresh];
            }
        }
            break;
            
        default:
            break;
    }
    
}


@end
