//
//  NewSearchController.m
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SearchController.h"
#import "EntityResultCell.h"
#import "ArticleResultCell.h"
#import "UserResultView.h"
#import "PinyinTools.h"
#import "CategoryResultView.h"
#import "SubCategoryEntityController.h"
#import "AlluserResultController.h"
#import "AllEntityResultController.h"
#import "AllArticleResultViewController.h"

@interface SearchHeaderSection : UICollectionReusableView
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) UIImageView * imgView;
@property (strong, nonatomic) NSString * imgName;
@property (strong, nonatomic) UIView *grayView;
@end

@interface SearchFooterSection : UICollectionReusableView

@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) UILabel * indicatorLabel;
//@property (strong, nonatomic)UIButton * moreBtn;
//@property (strong, nonatomic)UIView * separateView;
@property (nonatomic, copy) void (^tapAllResultsBlock)();

@end

@interface SearchController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UICollectionView * collectionView;

@property (nonatomic , strong)NSMutableArray * categoryArray;
@property (nonatomic , strong)NSMutableArray * userArray;
@property (nonatomic , strong)NSMutableArray * entityArray;
@property (nonatomic , strong)NSMutableArray * articleArray;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, weak) UISearchBar * searchBar;

@end

@implementation SearchController

static NSString * EntityResultCellIdentifier = @"EntityResultCell";
static NSString * ArticleResultCellIdentifier = @"ArticleResultCell";
static NSString * UserResultCellIdentifier = @"UserResultView";
static NSString * HeaderIdentifier = @"SearchHeaderSection";
static NSString * CategoryResultCellIdentifier = @"CategoryResultView";
static NSString * FooterIdentifier = @"SearchFooterSection";

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = IS_IPAD ? CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight)
        : CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight - kStatusBarHeight - kNavigationBarHeight);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[EntityResultCell class] forCellWithReuseIdentifier:EntityResultCellIdentifier];
    [self.collectionView registerClass:[ArticleResultCell class] forCellWithReuseIdentifier:ArticleResultCellIdentifier];
    
    [self.collectionView registerClass:[SearchHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [self.collectionView registerClass:[UserResultView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserResultCellIdentifier];
    [self.collectionView registerClass:[CategoryResultView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryResultCellIdentifier];
    [self.collectionView registerClass:[SearchFooterSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    
    [self.view addSubview:self.collectionView];
//    __weak __typeof(&*self)weakSelf = self;
//    [self.collectionView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf refresh];
//    }];
}

#pragma mark - get search results;
- (void)refresh
{
    [API searchWithKeyword:self.keyword Success:^(NSArray *entities, NSArray *articles, NSArray *users) {
        self.entityArray = [NSMutableArray arrayWithArray:entities];
        self.userArray = [NSMutableArray arrayWithArray:users];
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
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
        [weakSelf refresh];
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
//            count = self.userArray.count;
            break;
        case 2:
        {
            if (self.entityArray.count > 3) {
                count = 3;
            }
            else
            {
                count = self.entityArray.count;
            }
        }
            break;
        case 3:
        {
            if (self.articleArray.count > 3) {
                count = 3;
            }
            else
            {
                count = self.articleArray.count;
            }
        }
            break;
        default:
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
        case 3:
        {
            ArticleResultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleResultCellIdentifier forIndexPath:indexPath];
            cell.article = self.articleArray[indexPath.row];
            return cell;
        }
        default:
        {
            EntityResultCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityResultCellIdentifier forIndexPath:indexPath];
            cell.entity = self.entityArray[indexPath.row];
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
//                if (self.categoryArray.count == 0) {
//                    categoryView.hidden = YES;
//                }
//                else
//                {
//                    categoryView.hidden = NO;
//                }
                
                return categoryView;
            }
                break;
            case 1:
            {
                UserResultView * userview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserResultCellIdentifier forIndexPath:indexPath];
                userview.users = self.userArray;
                [userview setTapMoreUsersBlock:^{
                    AlluserResultController * vc = [[AlluserResultController alloc]init];
                    vc.keyword = self.keyword;
                    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
                }];
                [userview setTapUsersBlock:^(GKUser * user) {
                    [[OpenCenter sharedOpenCenter]openUser:user];
                }];
                if (self.userArray.count == 0) {
                    userview.hidden = YES;
                }
                else
                {
                    userview.hidden = NO;
                }
                return userview;
            }
                break;
            case 2:
            {
                SearchHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"entity", kLocalizedFile, nil);
                header.imgName = [NSString stringWithFormat:@"blue"];
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
            default:
            {
                SearchHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"article", kLocalizedFile, nil);
                header.imgName = [NSString stringWithFormat:@"red"];
                if (self.articleArray.count == 0) {
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
                
                if (self.entityArray.count == 0) {
                    footer.hidden = YES;
                }
                else
                {
                    footer.hidden = NO;
                }
                
                
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
                if (self.articleArray.count == 0) {
                    footer.hidden = YES;
                }
                else
                {
                    footer.hidden = NO;
                }
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
        case 2:
        {
            cellsize = IS_IPHONE ? CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32) :
                         CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 684 + 32);
        }
            break;
            
        default:
        {
            cellsize = CGSizeMake(self.collectionView.deFrameWidth, 84 * self.collectionView.deFrameWidth / 375 + 32);
        }
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
//    switch (section) {
//        case 2:
            
//            spacing = 1.;
//            break;
//        default:
//            break;
//    }
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
            if (self.userArray.count == 0) {
                headerSize = CGSizeMake(0, 0);
            }
            else
                headerSize = CGSizeMake(kScreenWidth, 126.);
        }
            break;
        default:
            headerSize = CGSizeMake(kScreenWidth, 54.);
            break;
    }
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerSize = CGSizeMake(0., 0.);
    switch (section) {
            
        case 2:
//            footerSize = CGSizeMake(kScreenWidth, 44.);
//            break;
        case 3:
            footerSize = CGSizeMake(kScreenWidth, 44.);
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
        case 2:
        {
            GKEntity * entity = self.entityArray[indexPath.row];
            [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
        }
            break;
            
        default:
        {
            GKArticle * article = self.articleArray[indexPath.row];
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
//    __weak __typeof(&*self)weakSelf = self;
//    [API searchWithKeyword:searchText Success:^(NSArray *entities, NSArray *articles, NSArray *users) {
//        
//        self.entityArray = [NSMutableArray arrayWithArray:entities];
//        self.userArray = [NSMutableArray arrayWithArray:users];
//        self.articleArray = [NSMutableArray arrayWithArray:articles];
//        
//        weakSelf.categoryArray = [NSMutableArray array];
//        for (GKEntityCategory * word in kAppDelegate.allCategoryArray) {
//            NSString * screenName = word.categoryName;
//            if ([PinyinTools ifNameString:screenName SearchString:searchText]) {
//                [_categoryArray addObject:word];
//            }
//        }
//        
//        [weakSelf.categoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
//        
//        [self.collectionView.pullToRefreshView stopAnimating];
//        [self.collectionView reloadData];
//        
//    } failure:^(NSInteger stateCode) {
//        [self.collectionView.pullToRefreshView stopAnimating];
//    }];
}

#pragma mark - <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

    if ([self.keyword isEqualToString:[searchController.searchBar.text trimedWithLowercase]]) {
        return;
    }
    self.searchBar = searchController.searchBar;
    
    self.keyword = [searchController.searchBar.text trimedWithLowercase];
    
    if (self.keyword.length == 0)
    {
        [UIView animateWithDuration:0 animations:^{
            
            [self.discoverVC.searchVC.view viewWithTag:999].alpha = 1;
            
        }];
        return;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [self.discoverVC.searchVC.view viewWithTag:999].alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self handleSearchText:self.keyword];
        
    }];
}

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.collectionView.scrollsToTop = NO;
    if (self.searchBar.text) {
        [self addSearchLog:self.searchBar.text];
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
         
         self.collectionView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end

#pragma mark - Search Header Section
@implementation SearchHeaderSection

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
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _textLabel.textColor = UIColorFromRGB(0x414243);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = _text;
    [self setNeedsLayout];
}

- (void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:_imgName];
    [self setNeedsLayout];
}

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
    CGFloat textWidth = [self.textLabel.text widthWithLineWidth:0. Font:self.textLabel.font];
    
    self.textLabel.frame = CGRectMake(0., 0., textWidth, 25.);
    self.textLabel.deFrameTop = 20.;
    self.textLabel.deFrameLeft = 12.;
    
    self.grayView.frame = CGRectMake(0, 0, kScreenWidth, 10.);
    
}

@end

#pragma mark - Search Footer Section
@implementation SearchFooterSection

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
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
    
    if (IS_IPAD) {
        self.indicatorLabel.frame = CGRectMake(0., 0., 20., 40.);
        self.indicatorLabel.deFrameRight = self.deFrameRight;
        self.indicatorLabel.deFrameTop = self.textLabel.deFrameTop;
    } else {
        self.indicatorLabel.frame = CGRectMake(0., 0., 20., 20.);
        self.indicatorLabel.deFrameTop = 12.;
        self.indicatorLabel.deFrameRight = self.deFrameWidth - 12.;
    }
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
