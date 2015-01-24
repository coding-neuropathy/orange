//
//  SelectionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "SelectionViewController.h"
#import "HMSegmentedControl.h"
#import "GKAPI.h"
#import "SelectionCell.h"
#import "EntitySingleListCell.h"


@interface SelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, strong) NSMutableArray * dataArrayForArticle;
@property(nonatomic, assign) NSUInteger index;
@end

@implementation SelectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"selection"] selectedImage:[UIImage imageNamed:@"selection"]];
        
        self.tabBarItem = item;
        
        self.title = @"精选";
        
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
        [segmentedControl setSectionTitles:@[@"商品", @"图文"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationNone];
        [segmentedControl setTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setSelectedTextColor:UIColorFromRGB(0x427ec0)];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xe4f0fc)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xcde3fb)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl setTag:2];
        //self.navigationItem.titleView =  segmentedControl;
        self.index = 0;

        
        [self logo];
        
        NSMutableArray * array = [NSMutableArray array];
        
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColorFromRGB(0xcacaca) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FARefresh] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
            [array addObject:item];
        }
        
        self.navigationItem.rightBarButtonItems = array;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight -kTabBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    

    
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

#pragma mark - Data
- (void)refresh
{
    if (self.index == 0) {
        [GKAPI getSelectionListWithTimestamp:[[NSDate date] timeIntervalSince1970] cateId:0 count:30 success:^(NSArray *dataArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:dataArray];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        [SVProgressHUD showImage:nil status:@"失败"];
        [self.tableView.pullToRefreshView stopAnimating];
    }
    return;
}
- (void)loadMore
{
    if (self.index == 0) {
        NSTimeInterval timestamp = (NSTimeInterval)[self.dataArrayForEntity.lastObject[@"time"] doubleValue];
        [GKAPI getSelectionListWithTimestamp:timestamp cateId:0 count:30 success:^(NSArray *dataArray) {
            [self.dataArrayForEntity addObjectsFromArray:[NSMutableArray arrayWithArray:dataArray]];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        [SVProgressHUD showImage:nil status:@"失败"];
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    return;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return ceil(self.dataArrayForEntity.count / (CGFloat)1);
    }
    else if (self.index == 1)
    {
         return ceil(self.dataArrayForArticle.count / (CGFloat)1);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        
        if (1) {
            static NSString *CellIdentifier = @"SelectionCell";
            SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[SelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.note = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"note"];
            cell.entity = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"entity"];
            NSTimeInterval timestamp = [self.dataArrayForEntity[indexPath.row][@"time"] doubleValue];
            cell.date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"EntitySingleListCell";
            EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.entity = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"entity"];
            NSTimeInterval timestamp = [self.dataArrayForEntity[indexPath.row][@"time"] doubleValue];

            
            return cell;
        }

    }
    else if (self.index == 1)
    {
        return [[UITableViewCell alloc] init];
    }
    return [[UITableViewCell alloc] init];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        if (1) {
            GKNote * note = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"note"];
            return [SelectionCell heightForEmojiText:note.text]+370;
        }
        else
        {
            return [EntitySingleListCell height];
        }

    }
    else if (self.index == 1)
    {
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}





#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    self.index = index;
    [self.tableView reloadData];
    switch (index) {
        case 0:
        {

        }
            break;
        case 1:
        {

        }
            break;
            
        default:
            break;
    }
}

- (void)logo
{
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 60, 30)];
    icon.image = [[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    icon.tintColor = UIColorFromRGB(0x696969);
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.userInteractionEnabled = YES;
    self.navigationItem.titleView = icon;
}

@end
