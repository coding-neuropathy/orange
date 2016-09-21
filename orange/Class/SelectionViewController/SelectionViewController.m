//
//  SelectionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelectionCell.h"
//#import "GTScrollNavigationBar.h"
#import "EntityViewController.h"

#import "GKHandler.h"
/**
 *  3d-touch
 */
#import "EntityPreViewController.h"



static NSString *CellIdentifier = @"SelectionCell";

static int lastContentOffset;

@interface SelectionViewController ()<UIViewControllerPreviewingDelegate>


@property(nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel * SelectionCountLabel;
@property (nonatomic, strong) UIView * SelectionCountLabelBgView;

@property (nonatomic, assign) NSInteger cateId;


@property (nonatomic ,strong)UIView * updateView;
@property (nonatomic ,strong)UILabel * updateLabel;
//更新数
@property (nonatomic , assign)NSInteger updateNum;
@property (nonatomic , strong)UIButton * closeBtn;


@property(nonatomic, strong) id<ALBBItemService> itemService;
//@property (nonatomic , assign)id<SelectionViewControllerDelegate>delegate;

@end

@implementation SelectionViewController
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:@"Save" object:nil];
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"featured.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"featured_on.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        self.tabBarItem = item;
    
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
        
        self.itemService    = [[ALBBSDK sharedInstance] getService:@protocol(ALBBItemService)];
        
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
    
    [self.collectionView registerClass:[SelectionCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    if (iOS9)
        [self registerPreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    //    [UIView setAnimationsEnabled:NO];
    
    self.collectionView.scrollsToTop = YES;
    //self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    [MobClick beginLogPageView:@"SelectionView"];
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.collectionView.scrollsToTop = NO;
    [MobClick endLogPageView:@"SelectionView"];
}

//- (void)refreshSelection
//{
////    [self.collectionView scr]
//    [self.collectionView triggerPullToRefresh];
//    
//}


/**
 *  3D-Touch
 */
- (void)registerPreview{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
    else {
        DDLogInfo(@"该设备不支持3D-Touch");
    }
}


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
    cell.delegate = [GKHandler sharedGKHandler];
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



- (void)save
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

//- (void)tapStatusBar:(id)sender
//{
//    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
//}

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
                [self.collectionView.pullToRefreshView stopAnimating];
                [UIView setAnimationsEnabled:NO];
                [self.collectionView reloadData];
                [UIView setAnimationsEnabled:YES];
                [self save];
            } else {
                [self.collectionView.pullToRefreshView stopAnimating];
            }
        }
    }
    if ([keyPath isEqualToString:@"isLoading"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.entityList.error) {
                [self.collectionView reloadData];
                [self.collectionView.infiniteScrollingView stopAnimating];
            } else {
                [self.collectionView.infiniteScrollingView stopAnimating];
            }
        }
    }

}

//#pragma mark <SelectionViewCellDelegate>
//- (void)TapEntityImage:(GKEntity *)entity
//{
//    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
//}


#pragma mark - <UIViewControllerPreviewingDelegate>
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath             = [self.collectionView indexPathForItemAtPoint:location];
    SelectionCell * cell                = (SelectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [MobClick event:@"3d-touch" attributes:@{
                                             @"entity"  : cell.entity.title,
                                             @"from"    : @"selection-page-recommend",
                                             }];
    if (iOS10) {
        EntityViewController * vc = [[EntityViewController alloc] initWithEntity:cell.entity];
        vc.preferredContentSize = CGSizeMake(0., 0.);
        previewingContext.sourceRect = cell.frame;
        vc.hidesBottomBarWhenPushed = YES;
        return vc;
    } else {
    EntityPreViewController * vc    = [[EntityPreViewController alloc] initWithEntity:cell.entity PreImage:cell.image.image];
    vc.preferredContentSize = CGSizeMake(0., 0.);
    previewingContext.sourceRect = cell.frame;
            
    vc.baichuanblock = ^(GKPurchase * purchase) {
        NSNumber * _itemId = [[[NSNumberFormatter alloc] init] numberFromString:purchase.origin_id];
        ALBBTradeTaokeParams * taoKeParams = [[ALBBTradeTaokeParams alloc]init];
        taoKeParams.pid = kGK_TaobaoKe_PID;
        [self.itemService showTaoKeItemDetailByItemId:self
                                                   isNeedPush:YES
                                            webViewUISettings:nil
                                                       itemId:_itemId
                                                     itemType:1
                                                       params:nil
                                                  taoKeParams:taoKeParams
                                  tradeProcessSuccessCallback:_tradeProcessSuccessCallback
                                   tradeProcessFailedCallback:_tradeProcessFailedCallback];
    };
            
    [vc setBackblock:^(UIViewController * vc1) {
        [self.navigationController pushViewController:vc1 animated:YES];
    }];
            

    return vc;
    }
    
    
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

@end
