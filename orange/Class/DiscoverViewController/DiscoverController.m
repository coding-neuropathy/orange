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


@interface DiscoverHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@end

@interface DiscoverController () <EntityCellDelegate, DiscoverBannerViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * bannerArray;
@property (strong, nonatomic) NSArray * categoryArray;
@property (strong, nonatomic) NSArray * entityArray;
@property (strong, nonatomic) UISearchController * searchVC;
@end

@implementation DiscoverController

static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * BannerIdentifier = @"BannerView";
static NSString * CategoryIdentifier = @"CategoryView";
static NSString * HeaderSectionIdentifier = @"HeaderSection";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_discover"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_discover"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        self.tabBarItem = item;
        
        self.title = NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil);
    }
    return self;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight- kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
        
//        _collectionView.contentInset = UIEdgeInsetsMake([self headerHeight], 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

- (UISearchController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchVC.searchResultsUpdater = self;
        _searchVC.delegate = self;
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        
        _searchVC.searchBar.tintColor = UIColorFromRGB(0x666666);
        _searchVC.searchBar.placeholder = NSLocalizedStringFromTable(@"search", kLocalizedFile, nil);
        [_searchVC.searchBar setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(10, 48)] stretchableImageWithLeftCapWidth:5 topCapHeight:5]  forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_searchVC.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(10, 28)]  forState:UIControlStateNormal];
        _searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(2.f, 0.f);
        _searchVC.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchVC.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchVC.searchBar.keyboardType = UIKeyboardTypeDefault;
    }
    return _searchVC;
}

#pragma mark - data
- (void)refresh
{
    [API getDiscoverWithsuccess:^(NSArray *banners, NSArray * entities, NSArray * categories) {
        self.bannerArray = banners;
        self.categoryArray = categories;
        self.entityArray = entities;
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    [self.collectionView registerClass:[DiscoverBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier];
    [self.collectionView registerClass:[DiscoverCategoryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier];
    
    [self.collectionView registerClass:[DiscoverHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier];
    
    self.navigationItem.titleView = self.searchVC.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.scrollNavigationBar.scrollView = self.collectionView;
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
    
    [self.collectionView addSloganView];
    
    if (self.entityArray == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 2:
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
            case 0:
            {
                DiscoverBannerView * bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier forIndexPath:indexPath];
                bannerView.bannerArray = self.bannerArray;
                bannerView.delegate = self;
                return bannerView;
            }
                break;
            case 1:
            {
                DiscoverCategoryView * categoryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryIdentifier forIndexPath:indexPath];
                categoryView.categories = self.categoryArray;
                categoryView.tapBlock = ^(GKCategory * category){
//                    DDLogInfo(@"category %@", category);
                    GroupViewController * groupVC = [[GroupViewController alloc] initWithGid:category.groupId];
                    [self.navigationController pushViewController:groupVC animated:YES];
                };
                return categoryView;
            }
                break;
            default:
            {
                DiscoverHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
                header.text = @"热门商品";
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
        case 2:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                cellsize = CGSizeMake(100., 100.);
            } else if (IS_IPHONE_6) {
                cellsize = CGSizeMake(110., 110.);
            } else {
                cellsize = CGSizeMake(120., 120.);
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
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0, 0.);
    switch (section) {
        case 2:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                edge =  UIEdgeInsetsMake(5., 5., 5, 5.);
            } else if (IS_IPHONE_6) {
                edge = UIEdgeInsetsMake(10., 10., 10., 10.);
            } else {
                edge = UIEdgeInsetsMake(15., 15., 15., 15.);
            }
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

        case 2:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                itemSpacing = 5.;
            } else if (IS_IPHONE_6) {
                itemSpacing = 10.;
            } else {
                itemSpacing = 10.;
            }
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
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                spacing = 5.;
            } else if (IS_IPHONE_6) {
                spacing = 10.;
            } else {
                spacing = 10.;
            }
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
        case 0:
            headerSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 150.f*kScreenWidth/320);
            break;
        case 1:
            headerSize = CGSizeMake(kScreenWidth, 155.);
            
            break;
        default:
            headerSize = CGSizeMake(kScreenWidth, 44.);
            break;
    }
    return headerSize;
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