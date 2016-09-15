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

#import "DiscoverBannerView.h"
#import "DiscoverCategoryView.h"

#import "DiscoverCategoryCell.h"
#import "HomeArticleCell.h"
#import "EntityDetailCell.h"

#import "DiscoverUsersView.h"
#import "RecUserController.h"

//#import "GTScrollNavigationBar.h"
//#import "GroupViewController.h"
#import "CategroyGroupController.h"
#import "UserViewController.h"
#import "EntityPreViewController.h"
#import "ArticlePreViewController.h"

//#import "SearchView.h"
#import "SearchController.h"
#import "SubCategoryEntityController.h"
#import "SearchTipsController.h"

//#import <GTScrollNavigationBar/GTScrollNavigationBar.h>


@interface DiscoverHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@end

#pragma mark - discover controller
@interface DiscoverController () <DiscoverBannerViewDelegate,
                                    UISearchControllerDelegate, UISearchBarDelegate,
                                    UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) GKDiscover * discoverData;

//@property (strong, nonatomic) UITableView * searchLogTableView;

@property (weak, nonatomic) id<ALBBItemService> itemService;

//@property (strong, nonatomic) SearchView * searchView;
@property (strong, nonatomic) SearchTipsController *searchTipsVC;
@property (strong, nonatomic) SearchController * searchResultsVC;


@property (weak, nonatomic) UIApplication * app;
//@property (nonatomic, strong) SearchController * newsearchResultsVC;
@end

@implementation DiscoverController
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

//static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * ArticleCellIdentifier = @"ArticleCell";
static NSString * BannerIdentifier = @"BannerView";
static NSString * CategoryIdentifier = @"CategoryView";
static NSString * DiscoverCategoryIdentifier = @"DiscoverCategoryCell";
static NSString * HeaderSectionIdentifier = @"HeaderSection";
static NSString * UserIdentifier = @"UserView";
static NSString * EntityDetailCellIdentifier = @"EntityDetailCell";

/**
 *  collection section num
 */
typedef NS_ENUM(NSInteger, DiscoverSectionType) {
    BannerSection,
    CategorySection,
    ArticleSection,
    UserSection,
    EntitySection,
};

- (void)clearSearchLogButtonAciton
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SearchLogs"];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SearchLogs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self.searchLogTableView reloadData];
}

- (SearchTipsController *)searchTipsVC
{
    if (!_searchTipsVC) {
        _searchTipsVC           = [[SearchTipsController alloc] init];
        __weak __typeof(&*self)weakSelf = self;
        
        [_searchTipsVC setTapRecordBtnBlock:^(NSString *keyword) {
        
            [weakSelf.searchVC.searchBar setText:keyword];
        
        }];

    }
    return _searchTipsVC;
}

- (SearchController *)searchResultsVC
{
    if (!_searchResultsVC) {
        _searchResultsVC = [[SearchController alloc] init];
    }
    return _searchResultsVC;
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

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
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
        _collectionView.alwaysBounceVertical    = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

- (UISearchController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsVC];
        _searchVC.searchResultsUpdater = self.searchResultsVC;
//        self.searchResultsVC.discoverVC = self;
        _searchVC.delegate = self;
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        if (IS_IPHONE)
            _searchVC.hidesBottomBarWhenPushed = YES;
        
        _searchVC.searchBar.tintColor                       = [UIColor colorFromHexString:@"#666666"];
        _searchVC.searchBar.placeholder                     = NSLocalizedStringFromTable(@"search", kLocalizedFile, nil);
        [_searchVC.searchBar setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(10, 48)] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_searchVC.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f6f6f6"] andSize:CGSizeMake(10, 28)] forState:UIControlStateNormal];
//
        _searchVC.searchBar.searchTextPositionAdjustment    = UIOffsetMake(6.f, 0.f);
        _searchVC.searchBar.autocorrectionType              = UITextAutocorrectionTypeNo;
        _searchVC.searchBar.autocapitalizationType          = UITextAutocapitalizationTypeNone;
        _searchVC.searchBar.keyboardType                    = UIKeyboardTypeDefault;
        _searchVC.searchBar.delegate                        = self;
    
        _searchVC.searchBar.autoresizingMask                = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [_searchVC.searchBar sizeToFit];
    
    }
    return _searchVC;
}

/**
 *  searchbar cancel can not show in ipad fixed
 *
 *  info http://stackoverflow.com/questions/30474494/cancel-button-is-not-shown-in-uisearchbar
 *
 *  @return uiview
 */
- (UIView *)viewForSearchBar
{
//    NSLog(@"frame %@", self.searchVC.searchBar);
    if (IS_IPAD)
        self.searchVC.searchBar.deFrameSize = CGSizeMake(kScreenWidth - kTabBarWidth, self.searchVC.searchBar.deFrameHeight);
    UIView *viewForSearchBar                        = [[UIView alloc] initWithFrame:self.searchVC.searchBar.bounds];

    viewForSearchBar.autoresizesSubviews            = YES;
    viewForSearchBar.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin
                                                                                    | UIViewAutoresizingFlexibleLeftMargin;
    [viewForSearchBar addSubview:self.searchVC.searchBar];
    return viewForSearchBar;
}

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

//    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    /**
     *  register cell
     */
    [self.collectionView registerClass:[DiscoverCategoryCell class] forCellWithReuseIdentifier:DiscoverCategoryIdentifier];
    [self.collectionView registerClass:[HomeArticleCell class] forCellWithReuseIdentifier:ArticleCellIdentifier];
    [self.collectionView registerClass:[EntityDetailCell class] forCellWithReuseIdentifier:EntityDetailCellIdentifier];
    
    /**
     *  register header section
     */
    [self.collectionView registerClass:[DiscoverBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier];
    [self.collectionView registerClass:[DiscoverCategoryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier];
    
    [self.collectionView registerClass:[DiscoverHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier];
    
    [self.collectionView registerClass:[DiscoverUsersView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserIdentifier];
    
    
    self.navigationItem.titleView = [self viewForSearchBar];
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
    kAppDelegate.activeVC = self;
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.collectionView.scrollsToTop = YES;
    
    [MobClick beginLogPageView:@"DiscoverView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.collectionView.scrollsToTop = NO;
    self.navigationController.navigationBar.translucent = YES;
    [MobClick endLogPageView:@"DiscoverView"];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
//    _searchView.frame = CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight);
    
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


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case CategorySection:
            if ( !(kScreenHeight <= 568. && !IS_ZOOMED_IPHONE_6 && !IS_ZOOMED_IPHONE_6_PLUS))
                count = self.discoverData.categoryCount;
            break;
        case ArticleSection:
            count = self.discoverData.articleCount;
            break;
        case EntitySection:
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
        case CategorySection:
        {
            DiscoverCategoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DiscoverCategoryIdentifier forIndexPath:indexPath];
            cell.category = [self.discoverData.categories objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case ArticleSection:
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
            case BannerSection:
            {
                DiscoverBannerView * bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier forIndexPath:indexPath];
                bannerView.bannerArray = self.discoverData.banners;
                bannerView.delegate = self;
                bannerView.hidden = self.discoverData.bannerCount == 0 ? YES : NO;
                return bannerView;
            }
                break;
            case CategorySection:
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
            case ArticleSection:
            {
                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"popular articles", kLocalizedFile, nil);
//                if (IS_IPAD) {
//                    header.backgroundColor= UIColorFromRGB(0xf8f8f8);
//                }
                return header;
            }
                break;
            case UserSection:
            {
                DiscoverUsersView * userView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserIdentifier forIndexPath:indexPath];
                userView.users = self.discoverData.users;
                [userView setTapMoreUserBlock:^{
                    RecUserController * vc = [[RecUserController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [userView setTapUserBlock:^(GKUser *user) {
                    
                    [[OpenCenter sharedOpenCenter] openUser:user];
                    
                }];
                return userView;
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
        case CategorySection:
            if ( !(kScreenHeight <= 568. && !IS_ZOOMED_IPHONE_6 && !IS_ZOOMED_IPHONE_6_PLUS)) {
                cellsize = IS_IPAD ? CGSizeMake(80., 100.) : CGSizeMake(50. * kScreeenScale, 80. * kScreeenScale);
            }
            break;
        case ArticleSection:
            if (IS_IPHONE) {
                cellsize = CGSizeMake(self.collectionView.deFrameWidth, 84 * kScreeenScale + 32);
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
        case EntitySection:
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
                cellsize = CGSizeMake((self.collectionView.deFrameWidth  ) / 2, self.collectionView.deFrameWidth / 2 + 85);
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
        case UserSection:
//            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case CategorySection:
            if ( !(kScreenHeight <= 568. && !IS_ZOOMED_IPHONE_6 && !IS_ZOOMED_IPHONE_6_PLUS))
                edge = IS_IPAD  ? UIEdgeInsetsMake( 0., 32., 5., 32.)
                                : UIEdgeInsetsMake(0., 16., 5., 16.);
            break;
        case ArticleSection:
            if (IS_IPAD) edge = UIEdgeInsetsMake(0., 20., 0., 20.);
            break;
        case EntitySection:
        {
//            edge = UIEdgeInsetsMake(0., 3., 3., 3.);
//            edge = UIEdgeInsetsMake(1, 0, 1, 0);
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
        case CategorySection:
        {
            if (IS_IPAD) {
                itemSpacing = 28.;
                if (self.app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
                    self.app.statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                    itemSpacing = 76.;
            
            }
        }
//            itemSpacing = IS_IPAD ? 28. : 0;
            break;
        case EntitySection:
        {
//            itemSpacing = 3.;
//            itemSpacing = 1.;
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
//        case 2:
//            spacing =5;
//            break;
        case CategorySection:
            spacing = IS_IPAD ? 24. : 0;
            break;
//        case EntitySection:
//        {
//            spacing = 3.;
//            spacing = 1.;
//        }
//            break;
            
        default:
//            spacing = 0;
            break;
    }
    return spacing;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = CGSizeMake(0, 0);
    switch (section) {
        case BannerSection:
        {
            headerSize = IS_IPAD ? headerSize = CGSizeMake(kScreenWidth - kTabBarWidth, 228) : CGSizeMake(CGRectGetWidth(self.collectionView.frame), 150.f*kScreenWidth/320);
        }
            break;
        case CategorySection:
            if (kScreenHeight <= 568. && !IS_ZOOMED_IPHONE_6 && !IS_ZOOMED_IPHONE_6_PLUS) {
                headerSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 127.);
            }
            break;
        case ArticleSection:
        {
            if(self.discoverData.articleCount) {
                headerSize = IS_IPAD ? CGSizeMake(CGRectGetWidth(self.collectionView.frame) - kTabBarWidth, 44.) : CGSizeMake(CGRectGetWidth(self.collectionView.frame), 44.);
            }
        }
            break;
        case UserSection:
            if (self.discoverData.userCount) {
                headerSize = IS_IPAD ? CGSizeMake(CGRectGetWidth(self.collectionView.frame) - kTabBarWidth, 126.)  :CGSizeMake(CGRectGetWidth(self.collectionView.frame), 126.);
            }
            break;
        case EntitySection:
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
        case CategorySection:
        {
            GKCategory * category = [self.discoverData.categories objectAtIndex:indexPath.row];
//            [[OpenCenter sharedOpenCenter] ope]
            CategroyGroupController * groupVC = [[CategroyGroupController alloc] initWithGid:category.groupId];
            groupVC.title = category.title;
            if (IS_IPHONE) groupVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupVC animated:YES];
            [MobClick event:@"discover to category" attributes:@{
                                                                 @"categoryId": @(category.groupId),
                                                                 @"categoryTitle": category.title_cn,
                                                                 }];
        }
            break;
        case ArticleSection:
        {
            GKArticle * article = [self.discoverData.articles objectAtIndex:indexPath.row];
            [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
            [MobClick event:@"rec_article" attributes:@{
                                                        @"articleid" : @(article.articleId),
                                                        @"articletitle" : article.title}];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <UISearchControllerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{

//    self.searchTipsVC.view.hidden   = NO;
    [searchController.view addSubview:self.searchTipsVC.view];
    [searchController addChildViewController:self.searchTipsVC];
    
    [API getSearchKeywordsWithSuccess:^(NSArray *keywords) {
        [self.searchTipsVC setSearchHistoryWords:[[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs]
                                        HotWords:keywords];
//        DDLogInfo(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs]);
    } Failure:^(NSInteger stateCode, NSError *error) {
//        self.historyArray   = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs];
        [self.searchTipsVC setSearchHistoryWords:[[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs]
                                        HotWords:nil];

        DDLogInfo(@"error %@", error.localizedDescription);
    }];
    if (IS_IPHONE) self.tabBarController.tabBar.hidden = YES;

}


- (void)didPresentSearchController:(UISearchController *)searchController
{
//    searchController.searchBar.showsCancelButton = YES;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
//    [[self.searchVC.view viewWithTag:999] removeFromSuperview];
//    [self.searchTipsVC.view removeFromSuperview];
//    [self.searchTipsVC removeFromParentViewController];
    if (IS_IPHONE) self.tabBarController.tabBar.hidden = NO;
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.searchTipsVC.view removeFromSuperview];
    [self.searchTipsVC removeFromParentViewController];
    
}

- (void)cancelSearch:(UIView *)view
{
    self.searchVC.active = NO;
}


#pragma mark - <UISearchBarDelegate>
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    searchBar.showsCancelButton = YES;
//    return YES;
//}

#pragma mark - <UIViewControllerPreviewingDelegate>
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath =[self.collectionView indexPathForItemAtPoint:location];
    
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    switch (indexPath.section) {
        case 2:
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
        self.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _textLabel.textColor = [UIColor colorFromHexString:@"#414243"];
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
    
    self.textLabel.frame = CGRectMake(10., 12., self.deFrameWidth - 20., 20.);
}

@end
