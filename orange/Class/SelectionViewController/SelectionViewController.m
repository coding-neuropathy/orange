//
//  SelectionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "SelectionViewController.h"
#import "HMSegmentedControl.h"
//#import "API.h"
#import "SelectionCell.h"
#import "EntitySingleListCell.h"
//#import "CategoryViewController.h"
//#import "SDWebImagePrefetcher.h"
#import "GTScrollNavigationBar.h"
//#import "SelectionCategoryView.h"
#import "IconInfoView.h"

//@import CoreSpotlight;

static NSString *CellIdentifier = @"SelectionCell";

static int lastContentOffset;

@interface SelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
// 商品数据源数组
//@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property (nonatomic, strong) GKSelectionEntity * entityList;

@property(nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel * SelectionCountLabel;
@property (nonatomic, strong) UIView * SelectionCountLabelBgView;
@property (nonatomic, strong) IconInfoView * iconInfoView;
//@property (nonatomic, strong) PopoverView * selection_pv;
@property (nonatomic, assign) NSInteger cateId;


@property (nonatomic ,strong)UIView * updateView;
@property (nonatomic ,strong)UILabel * updateLabel;
//更新数
@property (nonatomic , assign)NSInteger updateNum;
@property (nonatomic , strong)UIButton * closeBtn;

@end

@implementation SelectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:@"Save" object:nil];
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"selected", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_selection"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_selection"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        self.tabBarItem = item;
        
        //self.title = NSLocalizedStringFromTable(@"selected", kLocalizedFile, nil);
        self.cateId = 0;
        
        self.tableView.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight-kStatusBarHeight-kNavigationBarHeight - kTabBarHeight);
        
        self.entityList = [[GKSelectionEntity alloc] init];
        [self.entityList addTheObserverWithObject:self];
        
    }
    return self;
}

- (void)dealloc
{
    [self.entityList removeTheObserverWithObject:self];
}

#pragma mark - init view
- (UIView *)updateView
{
    if (!_updateView) {
        _updateView = [[UIView alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, 49.)];
        _updateView.backgroundColor = UIColorFromRGB(0x6eaaf0);
//        _updateView.userInteractionEnabled = YES;
        
    }
    return _updateView;
}


- (UILabel *)updateLabel
{
    if (!_updateLabel) {
        _updateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, 49.)];
        _updateLabel.backgroundColor = UIColorFromRGB(0x6eaaf0);
        _updateLabel.textColor = [UIColor whiteColor];
        _updateLabel.font = [UIFont boldSystemFontOfSize:16.5];
        _updateLabel.textAlignment = NSTextAlignmentCenter;
        [self getUpdateNumber];
        _updateLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUpdateLabel)];
        [_updateLabel addGestureRecognizer:tap];
    }
    return _updateLabel;
}

- (void)tapUpdateLabel
{
    [self.tableView triggerPullToRefresh];
    [self.updateView removeFromSuperview];
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(kScreenWidth - 42, 8., 32., 32.);
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)closeAction:(UIButton *)button
{
    [self.updateView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self.tableView registerClass:[SelectionCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.iconInfoView;
    
    [self.view addSubview:self.updateView];
    [self.updateView addSubview:self.updateLabel];
    [self.updateView addSubview:self.closeBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.scrollsToTop = YES;
    //self.navigationController.scrollNavigationBar.scrollView = self.tableView;
//    [AVAnalytics beginLogPageView:@"SelectionView"];
    [MobClick beginLogPageView:@"SelectionView"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
//    [AVAnalytics endLogPageView:@"SelectionView"];
    [MobClick endLogPageView:@"SelectionView"];
}

- (void)getUpdateNumber
{
    [API getUnreadCountWithSuccess:^(NSDictionary *dictionary) {
        self.updateNum = [[dictionary objectForKey:@"unread_selection_count"] integerValue];
        self.updateLabel.text = [NSString stringWithFormat:@"查看 %ld 个更新",self.updateNum];
    } failure:^(NSInteger stateCode) {
        
    }];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf.entityList refreshWithCategoryId:weakSelf.cateId];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.entityList loadWithCategoryId:weakSelf.cateId];
    }];
    
//    if (self.entityList.count == 0)
//    {
//        [self.tableView triggerPullToRefresh];
//    }
    BOOL isCache = [weakSelf.entityList loadFromCache];
    if (!isCache) {
        [self.tableView triggerPullToRefresh];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return ceil(self.entityList.count / (CGFloat)1);
    }
//    else if (self.index == 1)
//    {
//         return ceil(self.dataArrayForArticle.count / (CGFloat)1);
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        
//        if (1) {
            SelectionCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.dict = [self.entityList objectAtIndex:indexPath.row];
            return cell;
//        }
//        else
//        {
//            return [[UITableViewCell alloc] init];
//        }

    }
//    else if (self.index == 1)
//    {
//        return [[UITableViewCell alloc] init];
//    }
    return [[UITableViewCell alloc] init];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        if (1) {
            GKNote * note = [[self.entityList.dataArray [indexPath.row] objectForKey:@"content"] objectForKey:@"note"];
            return [SelectionCell height:note];
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
    if (self.index == 0) {
        return 0.f;
    }
    else
    {
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.index == 0) {
        
        _SelectionCountLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 36.f)];
        self.SelectionCountLabel.text = [NSString stringWithFormat:@"%d 条未读精选",10];
        self.SelectionCountLabel.textAlignment = NSTextAlignmentCenter;
        self.SelectionCountLabel.textColor = UIColorFromRGB(0xFF1F77);
        self.SelectionCountLabel.backgroundColor = [UIColor clearColor];
        self.SelectionCountLabel.font = [UIFont systemFontOfSize:14];
        
        _SelectionCountLabelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 36)];
        self.SelectionCountLabelBgView.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.SelectionCountLabelBgView addSubview:self.SelectionCountLabel];
        self.SelectionCountLabelBgView.alpha = 0.97;
        
        //return self.SelectionCountLabelBgView;
    }
    return [UIView new];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    
    lastContentOffset = scrollView.contentOffset.y;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSUserDefaults standardUserDefaults] setObject:@(scrollView.contentOffset.y) forKey:@"selection-offset-y"];
    
    if (scrollView.contentOffset.y < lastContentOffset)
    {
        [UIView animateWithDuration:1 animations:^{
            self.updateView.frame = CGRectMake(0.,0., kScreenWidth, 49);
        }];
    }
    else if (scrollView.contentOffset.y > lastContentOffset)
    {
        [UIView animateWithDuration:1 animations:^{
            self.updateView.frame = CGRectMake(0.,-49., kScreenWidth, 49);
        }];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        if (scrollView.contentOffset.y>20000) {
            [self tipForTapStatusBar];
        }
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


-(void)save
{
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary * dic in self.entityList.dataArray) {
        GKNote * note = [[dic objectForKey:@"content"]objectForKey:@"note"];
        GKEntity * entity = [[dic objectForKey:@"content"]objectForKey:@"entity"];
        NSString * time = [dic objectForKey:@"time"];
        NSDictionary * content = [NSMutableDictionary dictionaryWithObjectsAndKeys:[GKEntity dictionaryFromModel:entity],@"entity",[GKNote dictionaryFromModel:note],@"note", nil];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:time,@"time",content,@"content",nil]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:@"selection"];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.tableView.contentOffset.y) forKey:@"selection-offset-y"];
}

- (void)tapStatusBar:(id)sender
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
}

- (void)tipForTapStatusBar
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"everShowTipStatusBar"])
    {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everShowTipStatusBar"];
    
    if ([kAppDelegate.window viewWithTag:30001] ) {
        return;
    }
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight)];
    button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    button.tag = 30001;
    [button addTarget:self action:@selector(dismissTip) forControlEvents:UIControlEventTouchUpInside];
    [kAppDelegate.window addSubview:button];
    
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, kScreenWidth, 34)];
    tip.backgroundColor = UIColorFromRGB(0x343434);
    tip.textColor = UIColorFromRGB(0xffffff);
    tip.textAlignment = NSTextAlignmentCenter;
    tip.text = @"点击状态栏，瞬间回到顶部";
    tip.font = [UIFont systemFontOfSize:14];
    tip.layer.masksToBounds = YES;
    tip.layer.cornerRadius = 17;
    [tip sizeToFit];
    tip.frame = CGRectMake(0, 0, tip.deFrameWidth + 48, 34);
    tip.center = CGPointMake(kScreenWidth/2, 0);
    tip.deFrameTop = 19;
    [button addSubview:tip];
    
    UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_ triangle"]];
    icon.center =CGPointMake(kScreenWidth/2, 0);
    icon.deFrameTop = 11.5;
    [button addSubview:icon];
}

- (void)dismissTip
{
    UIView * view =[kAppDelegate.window viewWithTag:30001];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [[kAppDelegate.window viewWithTag:30001] removeFromSuperview];
        }];
    }

}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    DDLogError(@"obj obj %@", object);
    
    if ([keyPath isEqualToString:@"isRefreshing"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.entityList.error) {
                [self.tableView reloadData];
                [self.tableView.pullToRefreshView stopAnimating];
//                [self saveEntityToIndexWithData:(NSArray *)self.entityList];
//                [self.tableView.infiniteScrollingView stopAnimating];
//                if (_dataList.total == 0) {
//                    [SVProgressHUD showSuccessWithStatus:@"没有了！！！"];
//                }
//                _loadMoreflag = NO;
            }
        }
    }
    if ([keyPath isEqualToString:@"isLoading"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.entityList.error) {
                [self.tableView reloadData];
                [self.tableView.infiniteScrollingView stopAnimating];
//                [self saveEntityToIndexWithData:(NSArray *)self.entityList];
//                if (_dataList.total == 0) {
                    //[SVProgressHUD showSuccessWithStatus:@"没有了！！！"];
//                }
//                _loadMoreflag = NO;
            }
        }
    }

}
@end
