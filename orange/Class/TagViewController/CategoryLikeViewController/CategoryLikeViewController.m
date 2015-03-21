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
@property(nonatomic, strong) UIView *segmentedControl;
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
    [self.view addSubview:self.tableView];
    
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
    [titleView setBackgroundColor:[UIColor clearColor]];
    
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
    if (self.index == 1) {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"like" reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 0)
    {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"like" reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
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
    if (self.index == 1) {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:NO offset:self.dataArrayForEntity.count count:30 success:^(NSArray *entityArray) {
            [self.dataArrayForEntity addObjectsFromArray:entityArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 0)
    {
        [GKAPI getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:NO offset:self.dataArrayForEntity.count count:30 success:^(NSArray *entityArray) {
            [self.dataArrayForEntity addObjectsFromArray:entityArray];
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
            [self.dataArrayForLike addObjectsFromArray:entityArray];
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
        if (self.index == 0) {
            return ceil(self.dataArrayForEntity.count / (CGFloat)3);
        }
        else if (self.index == 1)
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
    if (self.index == 1)
    {
        static NSString *CellIdentifier = @"EntitySingleListCell";
        EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.entity = [self.dataArrayForEntity objectAtIndex:indexPath.row];
        return cell;
    }
    else if (self.index == 0)
    {
        static NSString *CellIdentifier = @"EntityCell";
        EntityThreeGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[EntityThreeGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = UIColorFromRGB(0xf8f8f8);
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
        if (self.index == 0) {
            return [EntityThreeGridCell height];
        }
        else if (self.index == 1)
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
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.segmentedControl) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        view.backgroundColor = UIColorFromRGB(0xffffff);
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setImage:[UIImage imageNamed:@"icon_grid"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_grid_press"] forState:UIControlStateSelected];
            [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [button addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 0;
            button.selected = YES;
            button.backgroundColor = [UIColor clearColor];
            [view addSubview:button];
        }
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(90, 0, 90, 44)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_list_press"] forState:UIControlStateSelected];
            [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [button addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1;
            button.backgroundColor = [UIColor clearColor];
            [view addSubview:button];
        }

        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(180, 0, kScreenWidth-180, 44)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xDB1F77) forState:UIControlStateSelected];
            [button setTitle:@"我喜爱的商品" forState:UIControlStateNormal];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [button addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 2;
            button.backgroundColor = [UIColor clearColor];
            [view addSubview:button];
        }
        {
            UIView * V = [[UIView alloc] initWithFrame:CGRectMake(90,44/2-7, 1,14 )];
            V.backgroundColor = UIColorFromRGB(0xebebeb);
            [view addSubview:V];
        }
        {
            UIView * V = [[UIView alloc] initWithFrame:CGRectMake(180,44/2-7, 1,14 )];
            V.backgroundColor = UIColorFromRGB(0xebebeb);
            [view addSubview:V];
        }
        
        
        self.segmentedControl = view;

        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,43.5, kScreenWidth, 0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            [self.segmentedControl addSubview:H];
        }
    }
    return self.segmentedControl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(UIButton *)segmentedControl {
    NSUInteger index = segmentedControl.tag;
    self.index = index;
    for (UIButton * button in self.segmentedControl.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    
    segmentedControl.selected = YES;
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