//
//  SubCategoryEntityController.m
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "SubCategoryEntityController.h"
#import "EntityCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "DataStructure.h"
#import "EntityDetailCell.h"
#import "CategoryArticleCell.h"
#import "MoreArticlesViewController.h"

@interface ArticleHeader : UICollectionReusableView

@property (nonatomic , strong) UILabel * textLabel;
@property (nonatomic , copy) NSString * text;
@property (nonatomic , strong) UIButton * moreBtn;
@property (nonatomic , strong) void (^moreBtnBlock)();

@end

//商品头
@interface EntityHeader : UICollectionReusableView

@property (nonatomic , strong) UILabel * textLabel2;
@property (nonatomic , copy) NSString * text2;

@end

@interface SubCategoryEntityController () <EntityCellDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) GKEntityCategory * subcategory;
@property (strong, nonatomic) NSMutableArray * entityArray;
@property (strong, nonatomic) NSMutableArray * articleArray;
@property (strong, nonatomic) NSString * sort;
@property (assign, nonatomic) NSInteger  page;
@property (assign, nonatomic) NSInteger count;
//@property (assign, nonatomic) EntityDisplayStyle style;

@end

@implementation SubCategoryEntityController

static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * EntityListCellIdentifier = @"EntityListCell";
static NSString * EntityDetailCellIdentifier = @"EntityDetailCell";
static NSString * CategoryArticleCellIdentifier = @"CategoryArticleCell";

static NSString * ArticleHeaderIdentifier = @"CategoryHeaderCell";
static NSString *  EntityHeaderIdentifier = @"CategoryHeaderCell2";

- (instancetype)initWithSubCategory:(GKEntityCategory *)subcategory
{
    self = [super init];
    if (self) {
        _subcategory = subcategory;
        self.sort = @"time";
        
        self.page = 1;
//        self.style = ListStyle;
        
//        self.title = _subcategory.categoryName;
        [self setTitleView];
    }
    return self;
}

- (void)setTitleView
{
    UIView *titleView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 26, 26)];
    icon.contentMode =UIViewContentModeScaleAspectFit;
    icon.backgroundColor = [UIColor clearColor];
    [icon sd_setImageWithURL:self.subcategory.iconURL placeholderImage:nil options:SDWebImageRetryFailed];
    [titleView addSubview:icon];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//    [label setText:([self.subcategory.categoryName componentsSeparatedByString:@"-"][0])];
    label.text = self.subcategory.categoryName;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textColor = UIColorFromRGB(0x414243);
    label.adjustsFontSizeToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    label.center = icon.center;
    
    titleView.deFrameWidth = label.deFrameWidth + icon.deFrameWidth * 2 +10;
    [titleView addSubview:label];
    if (self.subcategory.iconURL) {
        label.center = CGPointMake(titleView.frame.size.width/2+8, titleView.frame.size.height/2);
        icon.hidden = NO;
        icon.deFrameRight = label.deFrameLeft - 5;
    }
    else
    {
        icon.hidden = YES;
        label.center = CGPointMake(titleView.frame.size.width/2, titleView.frame.size.height/2);
    }
    
    
    self.navigationItem.titleView = titleView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[CSStickyHeaderFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
    self.page = 1;
    
    [API getEntityListWithCategoryId:self.subcategory.categoryId sort:self.sort reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
        self.entityArray = [NSMutableArray arrayWithArray:entityArray];
        
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
    
    [API getSubCategoryArticlesWithCategroyId:self.subcategory.categoryId Page:self.page success:^(NSArray *articles, NSInteger count) {
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        self.page += 1;
        self.count = count;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getEntityListWithCategoryId:self.subcategory.categoryId sort:self.sort reverse:NO offset:self.entityArray.count count:30 success:^(NSArray *entityArray) {
        [self.entityArray addObjectsFromArray:entityArray];

        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
//    [self.collectionView registerClass:[EntityListCell class] forCellWithReuseIdentifier:EntityListCellIdentifier];
    [self.collectionView registerClass:[EntityDetailCell class] forCellWithReuseIdentifier:EntityDetailCellIdentifier];
    [self.collectionView registerClass:[CategoryArticleCell class] forCellWithReuseIdentifier:CategoryArticleCellIdentifier];
    [self.collectionView registerClass:[ArticleHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderIdentifier];
    [self.collectionView registerClass:[EntityHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityHeaderIdentifier];
    /**
     * 切换 entity 样式按钮
     */
//    UIButton * styleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage * grid_image = [UIImage imageNamed:@"grid"];
//    [styleBtn setImage:grid_image forState:UIControlStateNormal];
//    styleBtn.frame = CGRectMake(0., 0., grid_image.size.width, grid_image.size.height);
//    [styleBtn addTarget:self action:@selector(styleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * styleBarBtn = [[UIBarButtonItem alloc] initWithCustomView:styleBtn];
    
    /**
     * 切换排序样式按钮
     */
//    UIButton * ltBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage * time_image = [UIImage imageNamed:@"like top"];
//    [ltBtn setImage:time_image forState:UIControlStateNormal];
//    ltBtn.frame = CGRectMake(0., 0., time_image.size.width, time_image.size.height);
//    [ltBtn addTarget:self action:@selector(ltBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * ltBarBtn = [[UIBarButtonItem alloc] initWithCustomView:ltBtn];
//
//    self.navigationItem.rightBarButtonItems = @[styleBarBtn, ltBarBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (self.entityArray == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return 1;
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.entityArray.count;
    switch (section) {
        case 0:
        {
            if (self.count <= 3) {
                return self.count;
            }
            else
            {
                return 3;
            }
        }
            break;
            
        default:
        {
            return self.entityArray.count;
        }
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableview = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        switch (indexPath.section) {
            case 0:
            {
                ArticleHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"selection-nav-article", kLocalizedFile, nil);
                if (self.count < 3) {
                    header.moreBtn.hidden = YES;
                }
                else{
                    header.moreBtn.hidden = NO;
                }
                header.moreBtnBlock = ^(){
                    
                  MoreArticlesViewController * vc = [[MoreArticlesViewController alloc]initWithDataSource:self.articleArray];
                    vc.title = NSLocalizedStringFromTable(@"selection-nav-article", kLocalizedFile, nil);
                    [self.navigationController pushViewController:vc animated:YES];
                };
                return header;
            }
                break;
                
            default:
            {
                EntityHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityHeaderIdentifier forIndexPath:indexPath];
                header.text2 = NSLocalizedStringFromTable(@"selection-nav-entity", kLocalizedFile, nil);
                
                return header;
            }
                break;
        }
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (self.style) {
//        case GridStyle:
//        {
//            EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityCellIdentifier forIndexPath:indexPath];
//            cell.entity = [self.entityArray objectAtIndex:indexPath.row];
//            cell.delegate = self;
//            return cell;
//        }
//            break;
//            
//        default:
//        {
////            EntityListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityListCellIdentifier forIndexPath:indexPath];
////            cell.entity = [self.entityArray objectAtIndex:indexPath.row];
//            
//            EntityDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityDetailCellIdentifier forIndexPath:indexPath];
//            cell.entity = self.entityArray[indexPath.row];
//            
//            return cell;
//        }
//            break;
//    }
    switch (indexPath.section) {
        case 0:
        {
            CategoryArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryArticleCellIdentifier forIndexPath:indexPath];
            cell.article = [self.articleArray objectAtIndex:indexPath.row];
            return cell;

        }
            break;
            
        default:
        {
            EntityDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityDetailCellIdentifier forIndexPath:indexPath];
            cell.entity = self.entityArray[indexPath.row];
            return cell;
        }
            break;
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0, 0);
    switch (indexPath.section) {
        case 0:
            cellsize = CGSizeMake(kScreenWidth, 110.);
            return cellsize;
            break;
            
        default:
            cellsize = CGSizeMake((kScreenWidth  )/2, (kScreenWidth  )/2 + 100);
            return cellsize;
            break;
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    
//    switch (self.style) {
//        case GridStyle:
//            edge = UIEdgeInsetsMake(3., 3., 3., 3.);
//            break;
//            
//        default:
//            edge = UIEdgeInsetsMake(16.,16.,16.,16.);
//            break;
//    }
//    
//    return edge;
    switch (section) {
        case 0:
        {
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            return edge;
        }
            break;
            
        default:
        {
            edge = UIEdgeInsetsMake(0., 0., 0., 0.);
            return edge;
        }
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
//    switch (self.style) {
//        case GridStyle:
//            itemSpacing = 3.;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return itemSpacing;
    switch (section) {
        case 0:
        {
            itemSpacing = 0;
            return itemSpacing;
        }
            break;
            
        default:
        {
            itemSpacing = 0;
            return itemSpacing;
        }
            break;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0;
//    switch (self.style) {
//        case GridStyle:
//            spacing = 3.;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return spacing;
    switch (section) {
        case 0:
        {
            spacing = 0;
            return spacing;
        }
            break;
            
        default:
        {
            spacing = 0.;
            return spacing;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 40.);
}

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}


#pragma mark - button action
//- (void)styleBtnAction:(id)sender
//{
//    UIButton * styleBtn = (UIButton *)sender;
//    
//    switch (self.style) {
//        case ListStyle:
//        {
//            self.style = GridStyle;
//            [styleBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
//            [self.collectionView reloadData];
//            
//        }
//            break;
//            
//        default:
//            self.style = ListStyle;
//            [styleBtn setImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];
//            [self.collectionView reloadData];
//            break;
//    }
//}
//
//- (void)ltBtnAction:(id)sender
//{
//    UIButton * ltBtn = (UIButton *)sender;
//    
//    if ([self.sort isEqualToString:@"time"]) {
//        self.sort = @"like";
//        [self.collectionView triggerPullToRefresh];
//        [ltBtn setImage:[UIImage imageNamed:@"time_top"] forState:UIControlStateNormal];
//    } else {
//        self.sort = @"time";
//        [self.collectionView triggerPullToRefresh];
//        [ltBtn setImage:[UIImage imageNamed:@"like top"] forState:UIControlStateNormal];
//    }
//}

@end

@implementation ArticleHeader

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

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"more", kLocalizedFile, nil), [NSString fontAwesomeIconStringForEnum:FAAngleRight]] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        [_moreBtn addTarget:self action:@selector(MoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (void)MoreBtnAction:(UIButton *)button
{
    if (self.moreBtnBlock)
    {
        self.moreBtnBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10., 0., kScreenWidth - 20., 44.);
    self.moreBtn.frame = CGRectMake(0., 0., 50., 40.);
    self.moreBtn.deFrameTop = 2;
    self.moreBtn.deFrameRight = self.deFrameRight - 16;
    
}

@end

#pragma mark - Category EntityHeader
@implementation EntityHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)textLabel2
{
    if (!_textLabel2)
    {
        _textLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel2.font = [UIFont systemFontOfSize:14.];
        _textLabel2.textColor = UIColorFromRGB(0x414243);
        _textLabel2.textAlignment = NSTextAlignmentLeft;
        _textLabel2.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel2];
    }
    return _textLabel2;
}

- (void)setText2:(NSString *)text2
{
    _text2 = text2;
    self.textLabel2.text = _text2;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel2.frame = CGRectMake(10., 0., kScreenWidth - 20., 44.);
}
@end

