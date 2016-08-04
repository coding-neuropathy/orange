//
//  SelectionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "SelectionViewController.h"
//#import "HMSegmentedControl.h"
#import "SelectionCell.h"
//#import "EntitySingleListCell.h"
//#import "CategoryViewController.h"
//#import "SDWebImagePrefetcher.h"
#import "GTScrollNavigationBar.h"
//#import "SelectionCategoryView.h"
//#import "IconInfoView.h"
#import "EntityViewController.h"
//@import CoreSpotlight;

static NSString *CellIdentifier = @"SelectionCell";

static int lastContentOffset;

@interface SelectionViewController ()<SelectionCellDelegate>
// 商品数据源数组
//@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property (nonatomic, strong) GKSelectionEntity * entityList;

@property(nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel * SelectionCountLabel;
@property (nonatomic, strong) UIView * SelectionCountLabelBgView;
//@property (nonatomic, strong) IconInfoView * iconInfoView;
//@property (nonatomic, strong) PopoverView * selection_pv;
@property (nonatomic, assign) NSInteger cateId;


@property (nonatomic ,strong)UIView * updateView;
@property (nonatomic ,strong)UILabel * updateLabel;
//更新数
@property (nonatomic , assign)NSInteger updateNum;
@property (nonatomic , strong)UIButton * closeBtn;

//@property (nonatomic , assign)id<SelectionViewControllerDelegate>delegate;

@end

@implementation SelectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:@"Save" object:nil];
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"featured.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"featured_on.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        self.tabBarItem = item;
        
        //self.title = NSLocalizedStringFromTable(@"selected", kLocalizedFile, nil);
        self.cateId = 0;
        
        if (IS_IPHONE) {
            self.collectionView.frame = CGRectMake(0, 0, kScreenWidth ,
                                                   kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
        }
        else
        {
            self.collectionView.frame = CGRectMake(0, 0, kScreenWidth - kTabBarWidth , kScreenHeight);
        }
        
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.hidesBarsOnSwipe = YES;
//    self.navigationController.hidesBarsOnTap = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self.collectionView registerClass:[SelectionCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    
//    self.navigationItem.titleView = self.iconInfoView;
    
//    [self.view addSubview:self.updateView];
//    [self.updateView addSubview:self.updateLabel];
//    [self.updateView addSubview:self.closeBtn];
//    [self getUpdateNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [UIView setAnimationsEnabled:NO];
    
    self.collectionView.scrollsToTop = YES;
    //self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    [MobClick beginLogPageView:@"SelectionView"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.collectionView.scrollsToTop = NO;
    [MobClick endLogPageView:@"SelectionView"];
}


////获取更新数
//- (void)getUpdateNumber
//{
//    [API getUnreadCountWithSuccess:^(NSDictionary *dictionary) {
//        self.updateNum = [[dictionary objectForKey:@"unread_selection_count"] integerValue];
//        if (self.updateNum == 0) {
//            [self.updateView removeFromSuperview];
//        }
//        else
//        {
//           self.updateLabel.text = [NSString stringWithFormat:@"查看 %ld 个更新",self.updateNum];
//        }
//    } failure:^(NSInteger stateCode) {
//        
//    }];
//}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    
    
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        [weakSelf.entityList refreshWithCategoryId:weakSelf.cateId];
        
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.entityList loadWithCategoryId:weakSelf.cateId];
    }];
    
    if (self.entityList.count == 0)
    {
        [self.collectionView triggerPullToRefresh];
    }
//    BOOL isCache = [weakSelf.entityList loadFromCache];
//    if (!isCache) {
//        [self.tableView triggerPullToRefresh];
//    }
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.entityList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.dict = [self.entityList objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(0., 0.);
    if (IS_IPAD) {
        cellSize = CGSizeMake(342., 465.);
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
            cellSize = CGSizeMake(313., 436.);
        }
    }
    else
    {
        GKNote * note = [[self.entityList.dataArray[indexPath.row] objectForKey:@"content"]objectForKey:@"note"];
        cellSize =  CGSizeMake(kScreenWidth, [SelectionCell height:note]);
    }
    
    return cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)
    //    {
    //        return UIEdgeInsetsMake(0., 128., 0., 128.);
    //    }
    return UIEdgeInsetsMake(0., 0., 0., 0.);
}


//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}


//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//        [self.collectionView performBatchUpdates:nil completion:nil];
//     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//     }];
//    
//}


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
        
//        [self.delegate hideSegmentControl];
        
    }
    else if (scrollView.contentOffset.y > lastContentOffset)
    {
        [UIView animateWithDuration:1 animations:^{
            self.updateView.frame = CGRectMake(0., -49., kScreenWidth, 49);
        }];
        
//        [self.delegate showSegmentControl];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        if (scrollView.contentOffset.y>20000) {
            [self tipForTapStatusBar];
        }
}



#pragma mark - HMSegmentedControl
//- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    NSUInteger index = segmentedControl.selectedSegmentIndex;
//    self.index = index;
//    [self.collectionView reloadData];
//    switch (index) {
//        case 0:
//        {
//
//        }
//            break;
//        case 1:
//        {
//
//        }
//            break;
//        default:
//            break;
//    }
//}


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
    [[NSUserDefaults standardUserDefaults] setObject:@(self.collectionView.contentOffset.y) forKey:@"selection-offset-y"];
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
                [UIView setAnimationsEnabled:NO];
                [self.collectionView reloadData];
                [self.collectionView.pullToRefreshView stopAnimating];
                [UIView setAnimationsEnabled:YES];
                [self save];
            }
        }
    }
    if ([keyPath isEqualToString:@"isLoading"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.entityList.error) {
                [self.collectionView reloadData];
                [self.collectionView.infiniteScrollingView stopAnimating];
            }
        }
    }

}

#pragma mark <SelectionViewCellDelegate>
- (void)TapEntityImage:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
}

@end
