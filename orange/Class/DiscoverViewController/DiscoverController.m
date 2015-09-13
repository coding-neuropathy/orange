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
#import "GTScrollNavigationBar.h"
#import "GroupViewController.h"
#import "SearchResultsViewController.h"


@interface DiscoverHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@end

@interface DiscoverController () <EntityCellDelegate, DiscoverBannerViewDelegate, UISearchControllerDelegate,UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * bannerArray;
@property (strong, nonatomic) NSArray * categoryArray;
@property (strong, nonatomic) NSArray * entityArray;
@property (strong, nonatomic) UISearchController * searchVC;
@property (strong, nonatomic) SearchResultsViewController * searchResultsVC;
@end

@implementation DiscoverController

static NSString * EntityCellIdentifier = @"EntityCell";
//static NSString * BannerIdentifier = @"BannerView";
static NSString * CategoryIdentifier = @"CategoryView";
static NSString * HeaderSectionIdentifier = @"HeaderSection";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_icon_discover"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_discover"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.tabBarItem = item;
        
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
        _searchVC.delegate = self;

    }
    return _searchVC;
}

- (SearchResultsViewController *)searchResultsVC
{
    if (!_searchResultsVC) {
        _searchResultsVC = [[SearchResultsViewController alloc] init];
    }
    return _searchResultsVC;
}

#pragma mark - data
- (void)refresh
{
    [API getDiscoverWithsuccess:^(NSArray *banners, NSArray * entities, NSArray * categories) {
        self.bannerArray = banners;
        self.categoryArray = categories;
        self.entityArray = entities;
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
//    [self.collectionView registerClass:[DiscoverBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier];
    [self.collectionView registerClass:[DiscoverCategoryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier];
    
    [self.collectionView registerClass:[DiscoverHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier];
    
    self.navigationItem.titleView = self.searchVC.searchBar;
    self.definesPresentationContext = YES;
    
    [self.collectionView addSloganView];
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
    
    [AVAnalytics beginLogPageView:@"DiscoverView"];
    [MobClick beginLogPageView:@"DiscoverView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AVAnalytics endLogPageView:@"DiscovreView"];
    [MobClick endLogPageView:@"DiscovreView"];
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return self.entityArray.count;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
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
//            case 0:
//            {
//                DiscoverBannerView * bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier forIndexPath:indexPath];
//                bannerView.bannerArray = self.bannerArray;
//                bannerView.delegate = self;
//                if (self.bannerArray.count == 0) {
//                    bannerView.hidden = YES;
//                }
//                else
//                {
//                    bannerView.hidden = NO;
//                }
//                return bannerView;
//            }
//                break;
            case 0:
            {
                DiscoverCategoryView * categoryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier forIndexPath:indexPath];
                categoryView.categories = self.categoryArray;
                categoryView.tapBlock = ^(GKCategory * category){
//                    DDLogInfo(@"category %@", category);
                    GroupViewController * groupVC = [[GroupViewController alloc] initWithGid:category.groupId];
                    groupVC.title = category.title;
                    groupVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:groupVC animated:YES];
                };
                if (self.categoryArray.count == 0) {
                    categoryView.hidden = YES;
                }
                else
                {
                    categoryView.hidden = NO;
                }
                return categoryView;
            }
                break;
            default:
            {

                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"popular", kLocalizedFile, nil);
                if (self.entityArray.count == 0) {
                    header.hidden = YES;
                }
                else
                {
                    header.hidden = NO;
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
        case 1:
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
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0, 0.);
    switch (section) {
        case 1:
        {
            edge = UIEdgeInsetsMake(3., 3., 3., 3.);
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

        case 1:
        {
            /*
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                itemSpacing = 3.;
            } else if (IS_IPHONE_6) {
                itemSpacing = 3.;
            } else {
                itemSpacing = 3.;
            }
             */
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
        case 1:
        {
            spacing = 3.;
        }
            break;
            
        default:
            spacing = 0;
            break;
    }
    return spacing;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(0, 0);
    switch (section) {
//        case 0:
//            headerSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 150.f*kScreenWidth/320);
//            break;
        case 0:
            headerSize = CGSizeMake(kScreenWidth, 155.);            
            break;
        default:
            headerSize = CGSizeMake(kScreenWidth, 44.);
            break;
    }
    return headerSize;
}

#pragma mark - <UISearchControllerDelegate>
- (void)willPresentSearchController:(UISearchController *)searchController
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.97];
    view.tag = 999;
    
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_search"]];
    image.center = CGPointMake(kScreenWidth/2, 0);
    image.deFrameTop = 50+kStatusBarHeight+kNavigationBarHeight;
    [view addSubview:image];
    
    [self.searchVC.view addSubview:view];
    [self.searchVC.view sendSubviewToBack:view];
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    [[self.searchVC.view viewWithTag:999]removeFromSuperview];
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


#pragma mark - DiscoverView Header
@implementation DiscoverHeaderSection

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
    
    self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    self.textLabel.frame = CGRectMake(10., 0., kScreenWidth - 20., 44.);
}


@end