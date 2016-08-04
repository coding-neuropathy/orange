//
//  DiscoverController.m
//  orange
//
//  Created by 谢家欣 on 15/7/27.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverController.h"
#import "WebViewController.h"
#import "UIScrollView+Slogan.h"

#import "pinyin.h"
#import "PinyinTools.h"

#import "DiscoverBannerView.h"
#import "DiscoverCategoryView.h"
#import "EntityCell.h"
#import "HomeArticleCell.h"
#import "EntityDetailCell.h"

#import "DiscoverUsersView.h"
#import "RecUserController.h"

#import "GTScrollNavigationBar.h"
//#import "GroupViewController.h"
#import "CategroyGroupController.h"
#import "UserViewController.h"
#import "authorizedUserViewController.h"
#import "EntityPreViewController.h"
#import "ArticlePreViewController.h"

#import "SearchView.h"
#import "SearchController.h"
#import "SubCategoryEntityController.h"


@interface DiscoverHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@end

#pragma mark - discover controller
@interface DiscoverController () <EntityCellDelegate, DiscoverBannerViewDelegate,
                                    UISearchControllerDelegate, UISearchBarDelegate,
                                    UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) GKDiscover * discoverData;

//@property (strong, nonatomic) UITableView * searchLogTableView;



@property(nonatomic, strong) id<ALBBItemService> itemService;

@property (nonatomic, strong) SearchView * searchView;
@property (strong, nonatomic) SearchController * searchResultsVC;
//@property (nonatomic, strong) SearchController * newsearchResultsVC;
@end

@implementation DiscoverController
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * ArticleCellIdentifier = @"ArticleCell";
static NSString * BannerIdentifier = @"BannerView";
static NSString * CategoryIdentifier = @"CategoryView";
static NSString * HeaderSectionIdentifier = @"HeaderSection";
static NSString * UserIdentifier = @"UserView";
static NSString * EntityDetailCellIdentifier = @"EntityDetailCell";

#pragma mark - search log
- (void)addSearchLog:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    NSMutableArray * array= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchLogs"]];
    if (!array) {
        array = [NSMutableArray array];
    }
    if (![array containsObject:text]) {
        [array insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SearchLogs"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)removeSearchLog:(NSString *)text
{
    NSMutableArray * array= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchLogs"]];
    if (!array) {
        return;
    }
    if ([array containsObject:text]) {
        [array removeObject:text];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SearchLogs"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSMutableArray *)getSearchLog
{
    NSMutableArray * array= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchLogs"]];
    if (!array) {
        array = [NSMutableArray array];
    }
    return array;
}

- (void)clearSearchLogButtonAciton
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SearchLogs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self.searchLogTableView reloadData];
}

#pragma mark - init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"discover-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"discover_on-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.tabBarItem = item;
        
        self.itemService = [[ALBBSDK sharedInstance] getService:@protocol(ALBBItemService)];

        
        //self.title = NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil);
    }
    return self;
}

- (void)dealloc
{
    [self.discoverData removeTheObserverWithObject:self];
}


#pragma mark - init data
- (GKDiscover *)discoverData
{
    if (!_discoverData) {
        _discoverData = [[GKDiscover alloc] init];
        [_discoverData addTheObserverWithObject:self];
    }
    return _discoverData;
}

#pragma mark - init view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        if (IS_IPHONE) {
            _collectionView = [[UICollectionView alloc]
                               initWithFrame:CGRectMake(0., 0., kScreenWidth,
                                kScreenHeight - kTabBarHeight - kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
        } else {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) collectionViewLayout:layout];
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

- (UISearchController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsVC];
        _searchVC.searchResultsUpdater = self.searchResultsVC;
        self.searchResultsVC.discoverVC = self;
        _searchVC.delegate = self;
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        
        _searchVC.searchBar.tintColor = UIColorFromRGB(0x666666);
        [_searchVC.searchBar sizeToFit];
        _searchVC.searchBar.placeholder = NSLocalizedStringFromTable(@"search", kLocalizedFile, nil);
        [_searchVC.searchBar setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(10, 48)] stretchableImageWithLeftCapWidth:5 topCapHeight:5]  forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_searchVC.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(10, 28)]  forState:UIControlStateNormal];
        
        _searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(6.f, 0.f);
        _searchVC.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchVC.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchVC.searchBar.keyboardType = UIKeyboardTypeDefault;
        _searchVC.searchBar.delegate = self;

    }
    return _searchVC;
}

- (SearchController *)searchResultsVC
{
    if (!_searchResultsVC) {
        _searchResultsVC = [[SearchController alloc] init];
    }
    return _searchResultsVC;
}

//- (SearchController *)newsearchResultsVC
//{
//    if (!_newsearchResultsVC)
//    {
//        _newsearchResultsVC = [[SearchController alloc]init];
//    }
//    return _newsearchResultsVC;
//}

- (void)registerPreview{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
    else {
        DDLogInfo(@"该设备不支持3D-Touch");
    }
}


- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    [self.collectionView registerClass:[HomeArticleCell class] forCellWithReuseIdentifier:ArticleCellIdentifier];
    
    [self.collectionView registerClass:[EntityDetailCell class] forCellWithReuseIdentifier:EntityDetailCellIdentifier];
    
    [self.collectionView registerClass:[DiscoverBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier];
    [self.collectionView registerClass:[DiscoverCategoryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier];
    
    [self.collectionView registerClass:[DiscoverHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier];
    
    [self.collectionView registerClass:[DiscoverUsersView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserIdentifier];
    
    self.navigationItem.titleView = self.searchVC.searchBar;
    self.definesPresentationContext = YES;
    
    [self.collectionView addSloganView];
    
    if (iOS9)
        [self registerPreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    kAppDelegate.activeVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self.navigationController.scrollNavigationBar respondsToSelector:@selector(setScrollView:)])
    {
        self.navigationController.scrollNavigationBar.scrollView = nil;
    }
    
    //self.navigationController.scrollNavigationBar.scrollView = self.collectionView;
    [self.navigationController.navigationBar setAlpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.collectionView.scrollsToTop = YES;
    
    [self.collectionView reloadData];
    
//    [AVAnalytics beginLogPageView:@"DiscoverView"];
    [MobClick beginLogPageView:@"DiscoverView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.collectionView.scrollsToTop = NO;
    
    if (_searchVC.searchBar.text) {
        [self addSearchLog:_searchVC.searchBar.text];
    }
    
    [MobClick endLogPageView:@"DiscoverView"];
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    _searchView.frame = CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight);
    
    [self.collectionView performBatchUpdates:nil completion:nil];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf.discoverData refresh];
    }];

    if (self.discoverData.count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getSearchLog].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchLogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        UIView * H = [[UIView alloc] initWithFrame:CGRectMake(10,43.5, kScreenWidth, 0.5)];
        H.backgroundColor = UIColorFromRGB(0xebebeb);
        [cell addSubview:H];
        
    }
    cell.textLabel.text = [[self getSearchLog] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(kScreenWidth, 44)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf8f8f8) andSize:CGSizeMake(kScreenWidth, 44)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clearSearchLogButtonAciton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"清空历史搜索记录" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self getSearchLog].count) {
        return 44;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * text = [[self getSearchLog] objectAtIndex:indexPath.row];
//    [self.searchLogTableView deselectRowAtIndexPath:indexPath animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_searchVC.searchBar setText:text];
    });

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * text = [[self getSearchLog] objectAtIndex:indexPath.row];
        [self removeSearchLog:text];
//         [self.searchLogTableView reloadData];
//        [self.searchLogTableView.superview bringSubviewToFront:self.searchLogTableView];
    }
    return;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 3:
//            count = self.articleArray.count;
            count = self.discoverData.articleCount;
            break;
        case 4:
//            count = self.entityArray.count;
            count = self.discoverData.entityCount;
            break;
            
        default:
//            return 0;
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 3:
        {
            HomeArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCellIdentifier forIndexPath:indexPath];
            cell.article = [self.discoverData.articles objectAtIndex:indexPath.row];
            return cell;
        }
            break;
            
        default:
        {
            EntityDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityDetailCellIdentifier forIndexPath:indexPath];
            cell.entity = [self.discoverData.entities objectAtIndex:indexPath.row];
//            cell.delegate = self;
            return cell;
            
        }
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reuseableview = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        switch (indexPath.section) {
            case 0:
            {
                DiscoverBannerView * bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier forIndexPath:indexPath];
                bannerView.bannerArray = self.discoverData.banners;
                bannerView.delegate = self;
                bannerView.hidden = self.discoverData.bannerCount == 0 ? YES : NO;
//                if (self.bannerArray.count == 0) {
//                    bannerView.hidden = YES;
//                }
//                else
//                {
//                    bannerView.hidden = NO;
//                }
                return bannerView;
            }
                break;
            case 1:
            {
                DiscoverUsersView * userView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserIdentifier forIndexPath:indexPath];
                userView.users = self.discoverData.users;
                [userView setTapMoreUserBlock:^{
                    RecUserController * vc = [[RecUserController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [userView setTapUserBlock:^(GKUser *user) {
            
                   [[OpenCenter sharedOpenCenter]openUser:user];
                    
                }];
                return userView;
            }
                break;
            case 2:
            {
                DiscoverCategoryView * categoryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier forIndexPath:indexPath];
                categoryView.categories = self.discoverData.categories;
                categoryView.tapBlock = ^(GKCategory * category){
                    CategroyGroupController * groupVC = [[CategroyGroupController alloc] initWithGid:category.groupId];
                    groupVC.title = category.title;
                    if (IS_IPHONE) groupVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:groupVC animated:YES];
                };
                return categoryView;
            }
                break;
            case 3:
            {
                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"popular articles", kLocalizedFile, nil);
                if (IS_IPAD) {
                    header.backgroundColor= UIColorFromRGB(0xf8f8f8);
                }
                return header;
            }
                break;
            default:
            {
                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"popular", kLocalizedFile, nil);
                if (IS_IPAD) {
                    header.backgroundColor= UIColorFromRGB(0xf8f8f8);
                }
                return header;
            }
                break;
        }
    }
    
    return reuseableview;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0., 0.);
    switch (indexPath.section) {
        case 3:
            if (IS_IPHONE) {
                cellsize = CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32);
            }
            else
            {
                if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
                    cellsize = CGSizeMake((kScreenWidth - kTabBarWidth - 16 * 5) / 3, 300.);
                } else {
                    cellsize = CGSizeMake(204, 232.);
                }
            }
            break;
        case 4:
        {
//            cellsize = CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
            if (IS_IPAD ) {
            
                if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft ||
                    [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
                    cellsize = CGSizeMake(312., 312. + 85);
                } else {
                    cellsize = CGSizeMake(340, 340 + 85);
                }
            } else {
                cellsize = CGSizeMake((self.collectionView.deFrameWidth  ) / 2 - 2 , self.collectionView.deFrameWidth / 2 + 85);
            }
        }
            break;
            
        default:
            break;
    }
    
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
//    if (IS_IPAD)
//        return  UIEdgeInsetsMake(0., 20., 0., 20.);
    
    switch (section) {
        case 1:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 2:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 3:
            if (IS_IPHONE) {
                edge = UIEdgeInsetsMake(0., 0., 10., 0);
            }
            else
            {
                edge = UIEdgeInsetsMake(0., 20., 0., 20.);
            }
            break;
        case 4:
        {
//            edge = UIEdgeInsetsMake(0., 3., 3., 3.);
            edge = UIEdgeInsetsMake(1, 1, 1, 1);
        }
            break;
        default:
            break;
    }
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
    switch (section) {

        case 4:
        {
//            itemSpacing = 3.;
            itemSpacing = 1.;
        }
            break;
        default:
//            itemSpacing = 0;
            break;
    }
    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0;
    switch (section) {
        case 2:
//            spacing =5;
            break;
        case 4:
        {
//            spacing = 3.;
            spacing = 1.;
        }
            break;
            
        default:
//            spacing = 0;
            break;
    }
    return spacing;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(0, 0);
    switch (section) {
        case 0:
        {
            headerSize = IS_IPAD ? headerSize = CGSizeMake(kScreenWidth - kTabBarWidth, 228) : CGSizeMake(CGRectGetWidth(self.collectionView.frame), 150.f*kScreenWidth/320);
        }
            break;
        case 1:
            if (self.discoverData.userCount) {
                headerSize = IS_IPAD ? CGSizeMake(CGRectGetWidth(self.collectionView.frame) - kTabBarWidth, 126.)  :CGSizeMake(CGRectGetWidth(self.collectionView.frame), 126.);
            }
            break;
        case 2:
            if (self.discoverData.categoryCount) {
                headerSize = IS_IPAD ? CGSizeMake(CGRectGetWidth(self.collectionView.frame) - kTabBarWidth, 155.) : CGSizeMake(CGRectGetWidth(self.collectionView.frame), 155.);
            }
            break;
        case 3:
        {
            if(self.discoverData.articleCount) {
                headerSize = IS_IPAD ? CGSizeMake(CGRectGetWidth(self.collectionView.frame) - kTabBarWidth, 44.) : CGSizeMake(CGRectGetWidth(self.collectionView.frame), 44.);
            }
        }
            break;
        case 4:
        {
            if (self.discoverData.entityCount) {
                headerSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 44.);
            }
        }
        default:
            
            break;
    }
    return headerSize;
}



#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 3:
        {
            GKArticle * article = [self.discoverData.articles objectAtIndex:indexPath.row];
            [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
            [MobClick event:@"rec_article" attributes:@{@"articleid" : @(article.articleId),@"articletitle" : article.title}];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <UISearchControllerDelegate>
- (void)willPresentSearchController:(UISearchController *)searchController
{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.32];
//    view.tag = 999;
//    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self action:@selector(cancelSearch:)];
//    tap.delegate = self;
//    [view addGestureRecognizer:tap];
//    
//    if (!_searchLogTableView) {
//        _searchLogTableView = [[UITableView alloc]initWithFrame:IS_IPHONE ? CGRectMake(0, 0, kScreenWidth, kScreenHeight) : CGRectMake(0, 0, kScreenWidth - kTabBarWidth, kScreenHeight)];
//        _searchLogTableView.delegate = self;
//        _searchLogTableView.dataSource = self;
//        _searchLogTableView.backgroundColor = [UIColor clearColor];
//        _searchLogTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _searchLogTableView.scrollEnabled = NO;
//
//        self.searchLogTableView = _searchLogTableView;
//    }
//    [self.searchLogTableView reloadData];
//    [view addSubview:self.searchLogTableView];
//    
//    [self.searchVC.view addSubview:view];
//    _searchView.alpha = 1;
    
    
    
    SearchView * searchView = [[SearchView alloc] initWithFrame:CGRectZero];
    self.searchView = searchView;
    searchView.frame = IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight)
                                    : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight);
    searchView.tag = 999;
    searchView.recentArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchLogs"]];
        __weak __typeof(&*self)weakSelf = self;
    [searchView setTaphotCategoryBtnBlock:^(NSString *hotString) {
            
           [weakSelf.searchVC.searchBar setText:hotString];
            
    }];
    [searchView setTapRecordBtnBlock:^(NSString *keyword) {
         
        [weakSelf.searchVC.searchBar setText:keyword];

    }];
    
    
    searchView.alpha = 1;
    
    self.searchView.recentArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchLogs"]];


    
    [self.searchVC.view addSubview:self.searchView];
    

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)didPresentSearchController:(UISearchController *)searchController
{

}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    [[self.searchVC.view viewWithTag:999] removeFromSuperview];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    
}

- (void)cancelSearch:(UIView *)view
{
    self.searchVC.active = NO;
}

#pragma mark - <UIViewControllerPreviewingDelegate>
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath =[self.collectionView indexPathForItemAtPoint:location];
    
//    if (indexPath.section != 3) {
//        return nil;
//    }

    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    if (!cell) {
        return nil;
    }

    switch (indexPath.section) {
        case 3:
        {
                ArticlePreViewController * vc = [[ArticlePreViewController alloc]
                                                 initWithArticle:[self.discoverData.articles objectAtIndex:indexPath.row]];
                vc.preferredContentSize = CGSizeMake(0, 0);
                previewingContext.sourceRect = cell.frame;
                return vc;
        }
            break;
        case 4:
        {
            EntityPreViewController * vc = [[EntityPreViewController alloc]
                                            initWithEntity:[self.discoverData.entities objectAtIndex:indexPath.row]];
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
            
            [vc setBackblock:^(UIViewController * vc1){
                [self.navigationController pushViewController:vc1 animated:YES];
            }];
            
            return vc;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    

}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
}

#pragma mark - <DiscoverBannerViewDelegate>
- (void)TapBannerImageAction:(NSDictionary *)dict
{
    NSString * url = dict[@"url"];
    
    if ([dict objectForKey:@"article"]) {
        GKArticle * article = [GKArticle modelFromDictionary:dict[@"article"]];
        [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
        return;
    }
    
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        if (k_isLogin) {
            NSRange range = [url rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&session=%@",[Passport sharedInstance].session]];
            }
            else
            {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"?session=%@",[Passport sharedInstance].session]];
            }
        }
        NSRange range = [url rangeOfString:@"out_link"];
        if (range.location == NSNotFound) {
            WebViewController * VC = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    [MobClick event:@"banner" attributes:@{@"url": url}];
    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isRefreshing"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.discoverData.error) {
                [UIView setAnimationsEnabled:NO];
                [self.collectionView reloadData];
                [self.collectionView.pullToRefreshView stopAnimating];
                [UIView setAnimationsEnabled:YES];
                [self.collectionView addSloganView];
            } else {
//                self.noResultView.hidden = NO;
                [self.collectionView.pullToRefreshView stopAnimating];
                //                [self.view insertSubview:self.no atIndex:<#(NSInteger)#>]
            }
        }
    }
}

@end


#pragma mark - DiscoverView Header
@implementation DiscoverHeaderSection

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:14.];
        _textLabel.textColor = UIColorFromRGB(0x414243);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = _text;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    self.textLabel.frame = CGRectMake(10., 0., kScreenWidth - 20., 44.);
}

@end