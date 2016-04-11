//
//  CategroyGroupController.m
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "CategroyGroupController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "EntityCell.h"
#import "EntityDetailCell.h"
#import "CategoryArticleCell.h"

#import "SubCategoryGroupController.h"
#import "SubCategoryEntityController.h"

#import "MoreArticlesViewController.h"

//类别头
@interface CategroyGroupHeader : UICollectionReusableView

@property (strong, nonatomic) NSArray * categoryArray;
@property (strong, nonatomic) UIButton * Morebtn;
@property (nonatomic, copy) void (^tapMoreBtnBlock)();
@property (nonatomic, copy) void (^tapCategoryBtnBlock)(GKEntityCategory * category);
@end

//图文头
@interface CategoryHeaderSection : UICollectionReusableView

@property (nonatomic , strong) UILabel * textLabel;
@property (nonatomic , copy) NSString * text;
@property (nonatomic , strong) UIButton * moreBtn;
@property (nonatomic , strong) void (^moreBtnBlock)();
@end
//商品头
@interface CategoryHeaderSection2 : UICollectionReusableView

@property (nonatomic , strong) UILabel * textLabel2;
@property (nonatomic , copy) NSString * text2;

@end

@interface CategroyGroupController () <EntityCellDelegate>
{
    MoreArticlesViewController * _maVC;
}
@property (strong, nonatomic) UICollectionView * collectionView;

@property (strong, nonatomic) NSMutableArray * entityArray;
@property (strong, nonatomic) NSMutableArray * ArticleArray;

@property (strong, nonatomic) NSMutableArray * categoryArray;
@property (strong, nonatomic) NSMutableArray * firstCategoryArray;
@property (strong, nonatomic) NSMutableArray * secondCategoryArray;



@property (assign, nonatomic) NSInteger gid;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSString * sort;
@property (assign, nonatomic) NSInteger count;

@end

@implementation CategroyGroupController

static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * CategoryHeaderIdentifier = @"CategoryHeader";
static NSString * EntityDetailCellIdentifier = @"EntityDetailCell";
static NSString * CategoryArticleCellIdentifier = @"CategoryArticleCell";
static NSString * CategoryHeaderSectionIdentifier = @"CategoryHeaderCell";
static NSString * CategoryHeaderSectionIdentifier2 = @"CategoryHeaderCell2";

- (instancetype)initWithGid:(NSInteger)gid
{
    self = [super init];
    if (self)
    {
        self.gid = gid;
        self.page = 1;
        
        self.sort = @"time";
        for (NSDictionary * dic in [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey]) {
            NSUInteger gid = [dic[@"GroupId"] integerValue];
            if (gid == self.gid) {
                self.categoryArray = [NSMutableArray arrayWithArray:dic[@"CategoryArray"]];
                [self.categoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
                [self splitArray];
                break;
            }
        }
    }
    return self;
}

- (void)splitArray
{
    self.firstCategoryArray = [NSMutableArray array];
    self.secondCategoryArray = [NSMutableArray array];
    for (GKEntityCategory *category in self.categoryArray) {
        if (category.status > 0) {
            [self.firstCategoryArray addObject:category];
        } else {
            [self.secondCategoryArray addObject:category];
        }
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
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
    
    [API getGroupArticleWithGroupId:self.gid Page:self.page success:^(NSArray *articles, NSInteger count) {
        self.ArticleArray = [NSMutableArray arrayWithArray:articles];
        self.count = count;
    
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
    
    [API getGroupEntityWithGroupId:self.gid Page:self.page Sort:self.sort success:^(NSArray *entities) {
        self.entityArray = [NSMutableArray arrayWithArray:entities];
        self.page += 1;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getGroupEntityWithGroupId:self.gid Page:self.page Sort:self.sort success:^(NSArray *entities) {
        [self.entityArray addObjectsFromArray:entities];
        self.page += 1;
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];

    [self.collectionView registerClass:[EntityDetailCell class] forCellWithReuseIdentifier:EntityDetailCellIdentifier];
    [self.collectionView registerClass:[CategoryArticleCell class] forCellWithReuseIdentifier:CategoryArticleCellIdentifier];
    
    [self.collectionView registerClass:[CategroyGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderIdentifier];
    
    [self.collectionView registerClass:[CategoryHeaderSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderSectionIdentifier];
    
    [self.collectionView registerClass:[CategoryHeaderSection2 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderSectionIdentifier2];
    
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
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (self.entityArray == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}
#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        GKArticle * article = [self.ArticleArray objectAtIndex:indexPath.row];
        [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];

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
        case 0:
        {
            return 0;
        }
            break;
        case 1:
        {
            if (self.count <=3) {
                return self.count;
            }
            else
            {
                return 3;
            }
        }
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
            case 1:
            {
                CategoryHeaderSection * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderSectionIdentifier forIndexPath:indexPath];
                header.text = NSLocalizedStringFromTable(@"selection-nav-article", kLocalizedFile, nil);
                if (self.count < 3) {
                    header.moreBtn.hidden = YES;
                }
                else{
                    header.moreBtn.hidden = NO;
                }
                header.moreBtnBlock = ^(){
                    
                    _maVC = [[MoreArticlesViewController alloc]initWithDataSource:self.ArticleArray];
                    _maVC.title = NSLocalizedStringFromTable(@"selection-nav-article", kLocalizedFile, nil);
                    _maVC.gid = self.gid;
                    [self.navigationController pushViewController:_maVC animated:YES];
                    
                };
                return header;
            }
                break;
            case 2:
            {
                CategoryHeaderSection2 * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderSectionIdentifier2 forIndexPath:indexPath];
                header.text2 = NSLocalizedStringFromTable(@"selection-nav-entity", kLocalizedFile, nil);
                header.backgroundColor = UIColorFromRGB(0xf8f8f8);

                return header;
            }
            default:
            {
                CategroyGroupHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderIdentifier forIndexPath:indexPath];
                header.categoryArray = self.firstCategoryArray;
                header.tapMoreBtnBlock = ^(){
                    SubCategoryGroupController * vc = [[SubCategoryGroupController alloc] initWithSubCategories:self.secondCategoryArray];
                    vc.title = NSLocalizedStringFromTable(@"more", kLocalizedFile, nil);
                    [self.navigationController pushViewController:vc animated:YES];
                };
                header.tapCategoryBtnBlock = ^(GKEntityCategory * category){
                    SubCategoryEntityController * vc = [[SubCategoryEntityController alloc] initWithSubCategory:category];
                    vc.title = category.categoryName;
                    [self.navigationController pushViewController:vc animated:YES];
                };
                return header;
                
            }
                break;
        }
        
        
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            CategoryArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryArticleCellIdentifier forIndexPath:indexPath];
            cell.article = [self.ArticleArray objectAtIndex:indexPath.row];
            return cell;
        }
        default:
        {
            EntityDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityDetailCellIdentifier forIndexPath:indexPath];
            cell.entity = [self.entityArray objectAtIndex:indexPath.row];
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
        case 1:
        {
            cellsize = CGSizeMake(kScreenWidth, 110.);
            return cellsize;
        }
        default:
        {
            cellsize = CGSizeMake((kScreenWidth  )/2 - 1, (kScreenWidth  )/2 + 85);
            return cellsize;
        }
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    
    switch (section) {
        case 1:
        {
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            return edge;
        }
        case 0:
        {
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            return edge;
        }
        default:
        {
            edge = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
            return edge;
        }
            break;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;

    switch (section) {
        case 1:
        {
            itemSpacing = 0.;
            return itemSpacing;
        }
        default:
        {
            itemSpacing = 1.;
            return itemSpacing;
        }
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0;

    switch (section) {
        case 1:
        {
            spacing = 0;
            return spacing;
        }
        default:
        {
            spacing = 1;
            return spacing;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
        {
            CGSize headerSize = CGSizeMake(kScreenWidth, 55.);
            return headerSize;
        }
            break;
        
        default:
        {
            CGSize headerSize = CGSizeMake(kScreenWidth, 40.);
            return headerSize;
        }
            break;
    }
    
}


#pragma mark - <EntityCellDelegate>

- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

#pragma mark - NavBar Button action

@end

@implementation CategroyGroupHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIButton *)Morebtn
{
    if (!_Morebtn) {
        _Morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_Morebtn setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"more", kLocalizedFile, nil), [NSString fontAwesomeIconStringForEnum:FAAngleRight]] forState:UIControlStateNormal];
        [_Morebtn setTitleColor:UIColorFromRGB(0x427EC0) forState:UIControlStateNormal];
        _Morebtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        [_Morebtn addTarget:self action:@selector(tapMorebtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_Morebtn];
    }
    return _Morebtn;
}

- (void)setCategoryArray:(NSArray *)categoryArray
{
    _categoryArray = categoryArray;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for(UIView * view in [self subviews])
    {
        if (view == self.Morebtn)
            continue;
        [view removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < self.categoryArray.count; i++){
        UIButton * categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        GKEntityCategory * sc = [self.categoryArray objectAtIndex:i];
        [categoryBtn setTitle:sc.categoryName forState:UIControlStateNormal];
        [categoryBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        categoryBtn.layer.cornerRadius = 12.;
        categoryBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
        categoryBtn.layer.masksToBounds = YES;
        categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        categoryBtn.tag = i;
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:12.];
            categoryBtn.frame = CGRectMake(10. + (55 + 5) * i, 15., 55., 25);
            categoryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        } else
            categoryBtn.frame = CGRectMake(10. + (70 + 5) * i, 15., 70., 25);
        [categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:categoryBtn];
    }
    
    self.Morebtn.frame = CGRectMake(0., 0., 50., 40.);
    self.Morebtn.deFrameTop = 7;
    self.Morebtn.deFrameRight = self.deFrameRight - 16;
}

#pragma mark - Button Action
- (void)tapMorebtnAction:(id)sender
{
    if (self.tapMoreBtnBlock)
    {
        self.tapMoreBtnBlock();
    }
}



- (void)categoryBtnAction:(id)sender
{
    UIButton * categoryBtn = (UIButton *)sender;
    GKEntityCategory * sc = [self.categoryArray objectAtIndex:categoryBtn.tag];
    if (self.tapCategoryBtnBlock) {
        self.tapCategoryBtnBlock(sc);
    }
}


@end

#pragma mark - Category ArticleHeader
@implementation CategoryHeaderSection

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
        [_moreBtn setTitle:[NSString stringWithFormat:@"%@", NSLocalizedStringFromTable(@"more", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColorFromRGB(0x9D9E9F) forState:UIControlStateNormal];
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
    self.moreBtn.deFrameRight = self.deFrameRight - 6;
    
}

@end


#pragma mark - Category EntityHeader
@implementation CategoryHeaderSection2

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
