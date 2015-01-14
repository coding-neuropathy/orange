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
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"tabbar_icon_star"] selectedImage:[UIImage imageNamed:@"tabbar_icon_star"]];
        
        self.tabBarItem = item;
        
        self.title = @"精选";
        
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
        [segmentedControl setSectionTitles:@[@"商品", @"图文"]];
        [segmentedControl setSelectedIndex:0];
        [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        [segmentedControl setTextColor:UIColorFromRGB(0x343434)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0x999999)];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl setTag:2];
        //self.navigationItem.titleView = segmentedControl;
        self.index = 0;
        
        [self logo];
        
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
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    /*
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
     */
    
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
       
    }
    return;
}
- (void)loadMore
{

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
        GKNote * note = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"note"];
        return [SelectionCell heightForEmojiText:note.text]+350;
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
    NSUInteger index = segmentedControl.selectedIndex;
    self.index = index;
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
    icon.image = [UIImage imageNamed:@"logo"];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.userInteractionEnabled = YES;
    self.navigationItem.titleView = icon;
}

@end
