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
#import "CategoryLikeViewController.h"

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, strong) NSMutableArray * dataArrayForLike;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) UIView *segmentedControl;
@property(nonatomic, strong) NSMutableArray * dataArrayForOffset;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    
    NSMutableArray * array = [NSMutableArray array];
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
        button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [button setTitle:[NSString fontAwesomeIconStringForEnum:FAInbox] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(archive) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
        [array addObject:item];
    }
    self.navigationItem.rightBarButtonItems = array;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    
    UISwipeGestureRecognizer * leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer * rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
    
    [GKAPI getCategoryStatByCategoryId:self.category.categoryId success:^(NSInteger likeCount, NSInteger noteCount, NSInteger entityCount) {
        UIButton * button = (UIButton *)[self.segmentedControl viewWithTag:1002];
        [button setTitle:[NSString stringWithFormat:@"%ld 件商品",entityCount] forState:UIControlStateNormal];
    } failure:^(NSInteger stateCode) {
        
    }];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"CategoryView"];
    [MobClick beginLogPageView:@"CategoryView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"CategoryView"];
    [MobClick endLogPageView:@"CategoryView"];
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
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textColor = UIColorFromRGB(0x414243);
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
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
            button.tag = 1000;
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
            button.tag = 1001;
            button.backgroundColor = [UIColor clearColor];
            [view addSubview:button];
        }

        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(180, 0, kScreenWidth-180, 44)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xFF1F77) forState:UIControlStateSelected];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            //[button addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1002;
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
    NSUInteger index = segmentedControl.tag-1000;
    self.index = index;
    
    
    CGFloat y = [[self.dataArrayForOffset objectAtIndexedSubscript:self.index] floatValue];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, y) animated:NO];
    
    
    for (UIButton * button in self.segmentedControl.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    
    segmentedControl.selected = YES;
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

-(void)archive
{
    CategoryLikeViewController * vc = [[CategoryLikeViewController alloc]init];
    vc.category = self.category;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        if (!self.dataArrayForOffset) {
            self.dataArrayForOffset = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),nil];
        }
        [self.dataArrayForOffset setObject:@(scrollView.contentOffset.y) atIndexedSubscript:self.index];
    }
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self segmentedControlChangedValue:(UIButton *)[self.segmentedControl viewWithTag:1001]];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self segmentedControlChangedValue:(UIButton *)[self.segmentedControl viewWithTag:1000]];

    }
    
}

@end
