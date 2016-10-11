//
//  NewSearchController.m
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SearchController.h"
#import "SearchTipsController.h"
//#import "NoResultView.h"

#import "UserResultCell.h"
#import "EntityResultCell.h"
#import "ArticleResultCell.h"
//#import "UserResultView.h"
#import "PinyinTools.h"

#import "CategoryResultView.h"
#import "SubCategoryEntityController.h"
#import "AlluserResultController.h"
#import "AllEntityResultController.h"
#import "AllArticleResultViewController.h"

#import "GKSearchData.h"


#pragma mark - Search Header Section
@interface SearchHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) UIView *grayView;
@end

#pragma mark - Search Footer Section
@interface SearchFooterSection : UICollectionReusableView

@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) UILabel * indicatorLabel;
@property (nonatomic, copy) void (^tapAllResultsBlock)();

@end


#pragma mark - Search View Controller
@interface SearchController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UICollectionView  *collectionView;
//@property (strong, nonatomic) NoResultView      *noResultView;

@property (strong, nonatomic) NSMutableArray    *categoryArray;
@property (strong, nonatomic) GKSearchData      *searchData;

@property (strong, nonatomic) NSString          *keyword;
@property (weak,   nonatomic) UISearchBar       *searchBar;

@property (strong, nonatomic) UIApplication     *app;

@end

@implementation SearchController

static NSString * EntityResultCellIdentifier = @"EntityResultCell";
static NSString * ArticleResultCellIdentifier = @"ArticleResultCell";
static NSString * UserResultCellIdentifier = @"UserResultCell";
static NSString * HeaderIdentifier = @"SearchHeaderSection";
static NSString * CategoryResultCellIdentifier = @"CategoryResultView";
static NSString * FooterIdentifier = @"SearchFooterSection";

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

- (void)dealloc
{
    [self.searchData removeTheObserverWithObject:self];
}

#pragma mark - init search data
- (GKSearchData *)searchData
{
    if (!_searchData) {
        _searchData = [[GKSearchData alloc] init];
        [_searchData addTheObserverWithObject:self];
    }
    return _searchData;
}

#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedStringFromTable(@"no-results", kLocalizedFile, nil);;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0. green:0. blue:0. alpha:0.27],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
////    UISearchBar *searchBar = self.searchDisplayController.searchBar;
//    
////    NSString *text = [NSString stringWithFormat:@"There are no empty dataset examples for \"%@\".", searchBar.text];
////    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
//    
////    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:[attributedString.string rangeOfString:searchBar.text]];
//    
////    return attributedString;
//}

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSString *text = @"Search on the App Store";
//    UIFont *font = [UIFont systemFontOfSize:16.0];
////    UIColor *textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"007aff" : @"c6def9"];
//    UIColor * textColor = [UIColor colorFromHexString:@"#007aff"];
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorFromHexString:@"#f8f8f8"];
}

//- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
//    CGFloat top = scrollView.contentInset.top / 2;
//    CGFloat bottom = scrollView.contentInset.bottom / 2;
//    return CGPointMake(0, top-bottom);
//}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -64.0;
//}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    DDLogInfo(@"%s",__FUNCTION__);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
//    UISearchBar *searchBar = self.searchDisplayController.searchBar;
//    
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.com/apps/%@", searchBar.text]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
//        [[UIApplication sharedApplication] openURL:URL];
//    }
}

#pragma mark - init collection view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = IS_IPAD ? CGRectMake(0., 0., kPadScreenWitdh, kScreenHeight)
                                        : CGRectMake(0., 0., kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight);
        
        if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight ||
            self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
            self.collectionView.deFrameLeft = 128.;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.emptyDataSetSource      = self;
//        _collectionView.emptyDataSetDelegate    = self;

        _collectionView.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
    }
    return _collectionView;
}


- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UserResultCell class] forCellWithReuseIdentifier:UserResultCellIdentifier];
    [self.collectionView registerClass:[EntityResultCell class] forCellWithReuseIdentifier:EntityResultCellIdentifier];
    [self.collectionView registerClass:[ArticleResultCell class] forCellWithReuseIdentifier:ArticleResultCellIdentifier];
    
    [self.collectionView registerClass:[SearchHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [self.collectionView registerClass:[CategoryResultView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryResultCellIdentifier];
    [self.collectionView registerClass:[SearchFooterSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    [self.view addSubview:self.collectionView];
    
//    if (self.collectionView.contentOffset.y < 0 && self.collectionView.emptyDataSetVisible) {
//        self.collectionView.contentOffset = CGPointZero;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.collectionView.scrollsToTop = YES;
    [MobClick beginLogPageView:@"SearchView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.collectionView.scrollsToTop = NO;
    
    [MobClick endLogPageView:@"SearchView"];
    [super viewWillDisappear:animated];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf.searchData refreshWithKeyWord:weakSelf.keyword];
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            
            break;
        case 1:
            count = self.searchData.userCount;
            break;
        case 2:
            count = self.searchData.entityCount;
            break;
        case 3:
            count = self.searchData.articleCount;
            break;
        default:
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
        case 1:
        {
            UserResultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserResultCellIdentifier forIndexPath:indexPath];
            cell.user = [self.searchData userAtIndex:indexPath.row];
            cell.tapRelationAction = ^(UIAlertController * ac){
                [self presentViewController:ac animated:YES completion:nil];
            };
            return cell;
        }
            break;
        case 3:
        {
            ArticleResultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleResultCellIdentifier forIndexPath:indexPath];
            cell.article = [self.searchData articleAtIndex:indexPath.row];
            return cell;
        }
        default:
        {
            EntityResultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityResultCellIdentifier forIndexPath:indexPath];
            cell.entity = [self.searchData entityAtIndex:indexPath.row];
            return cell;
        }
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionReusableView * reusebleview = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        switch (indexPath.section) {
            case 0:
            {
                CategoryResultView * categoryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryResultCellIdentifier forIndexPath:indexPath];
                categoryView.categorys = self.categoryArray;
                [categoryView setTapCategoryBlock:^(GKEntityCategory * category) {
                    SubCategoryEntityController * vc = [[SubCategoryEntityController alloc]initWithSubCategory:category];
                    vc.title = category.categoryName;
                    //                    NSLog(@"即将跳转");
                    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
                }];
                
                return categoryView;
            }
                break;
            case 1:
            {
                SearchHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"users", kLocalizedFile, nil);
                return header;

            }
                break;
            case 2:
            {
                SearchHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"entities", kLocalizedFile, nil);
                return header;
            }
                break;
            default:
            {
                SearchHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"articles", kLocalizedFile, nil);

                return header;
            }
                break;
        }
    }
    else
    {
        switch (indexPath.section) {
            case 0:
            {
                SearchFooterSection * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
                return footer;
            }
                break;
            case 1:
            {
                SearchFooterSection * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
                footer.tapAllResultsBlock = ^(){
                    AlluserResultController * vc = [[AlluserResultController alloc] init];
                    vc.keyword = self.keyword;
                    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
                };
                
                return footer;
            }
                break;
            case 2:
            {
                SearchFooterSection * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
                [footer setTapAllResultsBlock:^{
                    AllEntityResultController * vc = [[AllEntityResultController alloc] init];
                    vc.keyword = self.keyword;
                    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
                }];
                
                return footer;
            }
                break;
                
            default:
            {
                SearchFooterSection * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
                [footer setTapAllResultsBlock:^{
                    AllArticleResultViewController * vc = [[AllArticleResultViewController alloc]init];
                    vc.keyword = self.keyword;
                    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
                }];

                return footer;
            }
                break;
        }
    }
    
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0., 0.);
    switch (indexPath.section) {
        case 1:
            cellsize = IS_IPAD ? CGSizeMake(self.collectionView.deFrameWidth, 72.)
                                : CGSizeMake(kScreenWidth, 72.);
            break;
        case 2:
//        {
//            cellsize = IS_IPHONE ? CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32)
//                                : CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 684 + 32);
//        }
//            break;
        case 3:
            cellsize = CGSizeMake(self.collectionView.deFrameWidth, 114.);
            break;
        default:
//        {
//            cellsize = CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32);
//        }
            break;
    }
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    switch (section) {
        case 0:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
        case 1:
            edge = UIEdgeInsetsMake(0., 0., 0., 0.);
            break;
        case 2:
            edge = UIEdgeInsetsMake(0., 0., 0., 0.);
            break;
        case 3:
            edge = UIEdgeInsetsMake(0., 0., 0., 0);
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
    return spacing;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(0., 0.);
    switch (section) {
        case 0:
        {
            if (self.categoryArray.count == 0) {
                headerSize = CGSizeMake(0, 0);
            }
            else
                headerSize = CGSizeMake(kScreenWidth, 88.);
        }
            break;
        case 1:
        {
            if (self.searchData.userCount > 0)
                headerSize = CGSizeMake(kScreenWidth, 50.);

        }
            break;
        case 2:
        {
            if (self.searchData.entityCount > 0)
                headerSize = CGSizeMake(kScreenWidth, 50.);
        }
            break;
        case 3:
        {
            if (self.searchData.articleCount > 0)
                headerSize = CGSizeMake(kScreenWidth, 50.);
        }
            break;
        default:
            break;
    }
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerSize = CGSizeMake(0., 0.);
    switch (section) {
            
        case 1:
            if (self.searchData.userCount >= 3) footerSize = CGSizeMake(kScreenWidth, 44.);
            break;
        case 2:
            if (self.searchData.entityCount >= 3) footerSize = CGSizeMake(kScreenWidth, 44.);
            break;
        case 3:
            if (self.searchData.articleCount >= 3) footerSize = CGSizeMake(kScreenWidth, 44.);
            break;
        default:
            footerSize = CGSizeMake(0., 0.);
            break;
    }
    return footerSize;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            GKUser * user = [self.searchData userAtIndex:indexPath.row];
            [[OpenCenter sharedOpenCenter] openUser:user];
        }
            break;
        case 2:
        {
            GKEntity * entity = [self.searchData entityAtIndex:indexPath.row];
            [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
        }
            break;
            
        default:
        {
            GKArticle * article = [self.searchData articleAtIndex:indexPath.row];
            [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
        }
            break;
    }
}

#pragma mark - handle Search keyword
- (void)searchText:(NSString *)string
{
    [self handleSearchText:string];
}

- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    self.keyword = searchText;
    [self.collectionView triggerPullToRefresh];
}

#pragma mark - <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    DDLogInfo(@"okokokoko %@", searchController.searchBar.text);
    if ([self.keyword isEqualToString:[searchController.searchBar.text trimedWithLowercase]]) {
        return;
    }
    self.searchBar = searchController.searchBar;
    
    self.keyword = [searchController.searchBar.text trimedWithLowercase];
    
    if (self.keyword.length == 0) return;

    for (UIViewController * vc in searchController.childViewControllers) {
        if ([vc isKindOfClass:[SearchTipsController class]]) {
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
        
    [self handleSearchText:self.keyword];
        
//    }];
}

#pragma mark - search log
- (void)addSearchLog:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    NSMutableArray * array= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kSearchLogs]];
    if (!array) {
        array = [NSMutableArray array];
    }
    if (![array containsObject:text]) {
        [array insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kSearchLogs];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [array removeObject:text];
        [array insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kSearchLogs];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark ----- About View Rotation -------
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         self.collectionView.frame = CGRectMake(0., 0., 684., size.height);
         if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight ||
             self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
             self.collectionView.deFrameLeft = 128.;
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isRefreshing"]) {
        if(![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.searchData.error && self.searchData.count > 0) {
//                self.noResultView.hidden = YES;
                [UIView setAnimationsEnabled:NO];
                [self.collectionView reloadData];
                [self.collectionView.pullToRefreshView stopAnimating];
                [UIView setAnimationsEnabled:YES];
                
                if ([self.searchBar.text length] > 0) {
                    [self addSearchLog:[self.searchBar.text lowercaseString]];
                }
                
            } else {
//                DDLogError(@"error %@", self.searchData.error.localizedDescription);
                
//                self.noResultView.hidden = NO;
                [self.collectionView reloadData];
                [self.collectionView.pullToRefreshView stopAnimating];
//                [self.view insertSubview:self.no atIndex:<#(NSInteger)#>]
            }
        }
    }
}

@end

#pragma mark - Search Header Section
@implementation SearchHeaderSection

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
        _textLabel.textColor = [UIColor colorFromHexString:@"#212121"];
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

//- (void)setImgName:(NSString *)imgName
//{
//    _imgName = imgName;
//    self.imgView.image = [UIImage imageNamed:_imgName];
//    [self setNeedsLayout];
//}

- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _grayView.backgroundColor = [UIColor colorWithWhite:0.965 alpha:1.000];
        [self addSubview:_grayView];
    }
    return _grayView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.imgView.frame = CGRectMake(10., 23., 10., 10.);
    self.grayView.frame = CGRectMake(0, 0, kScreenWidth, 10.);

    CGFloat textWidth = [self.textLabel.text widthWithLineWidth:0. Font:self.textLabel.font];
    self.textLabel.frame = CGRectMake(0., 0., textWidth, 20.);
    self.textLabel.deFrameTop = self.grayView.deFrameBottom + 10.;
    self.textLabel.deFrameLeft = 12.;
    
    
}

@end

#pragma mark - Search Footer Section
@implementation SearchFooterSection

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        //        self.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkAllResults)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _textLabel.textColor = UIColorFromRGB(0x000000);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSLocalizedStringFromTable(@"click to view all results", kLocalizedFile, nil);
        _textLabel.alpha = 0.54;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UILabel *)indicatorLabel
{
    if (!_indicatorLabel) {
        _indicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _indicatorLabel.text = [NSString stringWithFormat:@"%@", [NSString fontAwesomeIconStringForEnum:FAAngleRight]];
        _indicatorLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _indicatorLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        [self addSubview:_indicatorLabel];
    }
    
    return _indicatorLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat textWidth = [self.textLabel.text widthWithLineWidth:0. Font:self.textLabel.font];
    
    self.textLabel.frame = CGRectMake(12., 14., textWidth, 20.);
    
    self.indicatorLabel.frame = CGRectMake(0., 0., 20., 20.);
    self.indicatorLabel.deFrameTop = 12.;
    
    self.indicatorLabel.deFrameRight = IS_IPAD ? self.deFrameWidth - 10 : self.deFrameWidth - 12.;
//    }
}

- (void)drawRect:(CGRect)rect
{

    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 0., 0.);
    CGContextAddLineToPoint(context, self.deFrameWidth, 0.);
    
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, self.deFrameWidth, self.deFrameHeight);
    CGContextStrokePath(context);
}


#pragma mark - block
- (void)checkAllResults
{
    if (self.tapAllResultsBlock) {
        self.tapAllResultsBlock();
    }
}

@end
