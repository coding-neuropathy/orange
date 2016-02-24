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

#import "DiscoverUsersView.h"
#import "RecUserController.h"

#import "GTScrollNavigationBar.h"
//#import "GroupViewController.h"
#import "CategroyGroupController.h"
#import "UserViewController.h"
#import "SearchController.h"

#import "EntityPreViewController.h"


@interface DiscoverHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@end

@interface DiscoverController () <EntityCellDelegate, DiscoverBannerViewDelegate, UISearchControllerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * bannerArray;
@property (strong, nonatomic) NSArray * categoryArray;
@property (strong, nonatomic) NSArray * entityArray;
@property (strong, nonatomic) NSArray * articleArray;
@property (strong, nonatomic) NSArray * userArray;
@property (strong, nonatomic) UITableView * searchLogTableView;

@property (strong, nonatomic) SearchController * searchResultsVC;

@property(nonatomic, strong) id<ALBBItemService> itemService;

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
    [self.searchLogTableView reloadData];
}

#pragma mark - init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_icon_discover"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_discover"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.tabBarItem = item;
        
        self.itemService = [[TaeSDK sharedInstance] getService:@protocol(ALBBItemService)];

        
        //self.title = NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil);
    }
    return self;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight-kTabBarHeight - kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
        
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
        
        _searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(2.f, 0.f);
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


- (void)registerPreview{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
    else {
        DDLogInfo(@"该设备不支持3D-Touch");
    }
}

#pragma mark - data
- (void)refresh
{
    [API getDiscoverWithsuccess:^(NSArray *banners, NSArray * entities, NSArray * categories, NSArray * articles, NSArray * users) {
        self.bannerArray = banners;
        self.categoryArray = categories;
        self.entityArray = entities;
        self.articleArray = articles;
        self.userArray = users;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
//        [self.collectionView addSloganView];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    [self.collectionView registerClass:[HomeArticleCell class] forCellWithReuseIdentifier:ArticleCellIdentifier];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.scrollNavigationBar.scrollView = self.collectionView;
    [self.navigationController.navigationBar setAlpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.collectionView.scrollsToTop = YES;
    
    [AVAnalytics beginLogPageView:@"DiscoverView"];
    [MobClick beginLogPageView:@"DiscoverView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.collectionView.scrollsToTop = NO;
    
    if (_searchVC.searchBar.text) {
        [self addSearchLog:_searchVC.searchBar.text];
    }
    
    [AVAnalytics endLogPageView:@"DiscoverView"];
    [MobClick endLogPageView:@"DiscoverView"];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];

    if (self.entityArray == 0) {
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
    [self.searchLogTableView deselectRowAtIndexPath:indexPath animated:YES];
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
         [self.searchLogTableView reloadData];
        [self.searchLogTableView.superview bringSubviewToFront:self.searchLogTableView];
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
            count = self.articleArray.count;
            break;
        case 4:
            count = self.entityArray.count;
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
            cell.article = [self.articleArray objectAtIndex:indexPath.row];
            return cell;
        }
            break;
            
        default:
        {
            EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityCellIdentifier forIndexPath:indexPath];
            cell.entity = [self.entityArray objectAtIndex:indexPath.row];
            cell.delegate = self;
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
                bannerView.bannerArray = self.bannerArray;
                bannerView.delegate = self;
                if (self.bannerArray.count == 0) {
                    bannerView.hidden = YES;
                }
                else
                {
                    bannerView.hidden = NO;
                }
                return bannerView;
            }
                break;
            case 1:
            {
                DiscoverUsersView * userView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserIdentifier forIndexPath:indexPath];
                userView.users = self.userArray;
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
            case 2:
            {
                DiscoverCategoryView * categoryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier forIndexPath:indexPath];
                categoryView.categories = self.categoryArray;
                categoryView.tapBlock = ^(GKCategory * category){
                    CategroyGroupController * groupVC = [[CategroyGroupController alloc] initWithGid:category.groupId];
                    groupVC.title = category.title;
                    groupVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:groupVC animated:YES];
                };
                return categoryView;
            }
                break;
            case 3:
            {
                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"popular articles", kLocalizedFile, nil);
                return header;
            }
                break;
            default:
            {
                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"popular", kLocalizedFile, nil);
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
            cellsize = CGSizeMake(kScreenWidth, 84 *kScreenWidth/375 + 32);;
            break;
        case 4:
        {
            cellsize = CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
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
    switch (section) {
        case 1:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 2:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 3:
            edge = UIEdgeInsetsMake(0., 0., 10., 0);
            break;
        case 4:
        {
            edge = UIEdgeInsetsMake(0., 3., 3., 3.);
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
            itemSpacing = 3.;
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
            spacing = 3.;
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
            headerSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 150.f*kScreenWidth/320);
            break;
        case 1:
            if (self.userArray.count) {
                headerSize = CGSizeMake(kScreenWidth, 100.);
            }
            break;
        case 2:
            if (self.categoryArray.count) {
                headerSize = CGSizeMake(kScreenWidth, 155.);
            }
            break;
        case 3:
        {
            if(self.articleArray.count) {
                headerSize = CGSizeMake(kScreenWidth, 44.);
            }
        }
            break;
        case 4:
        {
            if (self.entityArray.count) {
                headerSize = CGSizeMake(kScreenWidth, 44.);
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
            GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
            //    NSLog(@"%@", article.articleURL);
            WebViewController * vc = [[WebViewController alloc]initWithURL:article.articleURL];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <UISearchControllerDelegate>
- (void)willPresentSearchController:(UISearchController *)searchController
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.32];
    view.tag = 999;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(cancelSearch:)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
    
    if (!self.searchLogTableView) {
        UITableView * searchLogTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        searchLogTableView.delegate = self;
        searchLogTableView.dataSource = self;
        searchLogTableView.backgroundColor = [UIColor clearColor];
        searchLogTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        searchLogTableView.scrollEnabled = NO;

        self.searchLogTableView = searchLogTableView;
    }
    [self.searchLogTableView reloadData];
    [view addSubview:self.searchLogTableView];
    
    [self.searchVC.view addSubview:view];
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
    
    if (indexPath.section != 3) {
        return nil;
    }

    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    if (!cell) {
        return nil;
    }

//    PreviewArticleController * vc = [[PreviewArticleController alloc] initWIthArticle:[self.articleArray objectAtIndex:indexPath.row]];
//    vc.preferredContentSize = CGSizeMake(0, 0);
//    previewingContext.sourceRect = cell.frame;
//    return vc;
    EntityPreViewController * vc = [[EntityPreViewController alloc] initWithEntity:[self.entityArray objectAtIndex:indexPath.row]];
    vc.preferredContentSize = CGSizeMake(0., 0.);
    previewingContext.sourceRect = cell.frame;
    
    vc.baichuanblock = ^(GKPurchase * purchase) {
        NSNumber * _itemId = [[[NSNumberFormatter alloc] init] numberFromString:purchase.origin_id];
        TaeTaokeParams * taoKeParams = [[TaeTaokeParams alloc]init];
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
    [AVAnalytics event:@"banner" attributes:@{@"url": url}];
    [MobClick event:@"banner" attributes:@{@"url": url}];
    if ([url hasPrefix:@"http://"]) {
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
            //            GKWebVC * VC = [GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:url]];
            WebViewController * VC = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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