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
#import "EntityListCell.h"

#import "SubCategoryGroupController.h"
#import "SubCategoryEntityController.h"

@interface CategroyGroupHeader : UICollectionReusableView

@property (strong, nonatomic) NSArray * categoryArray;
@property (strong, nonatomic) UIButton * Morebtn;
@property (nonatomic, copy) void (^tapMoreBtnBlock)();
@property (nonatomic, copy) void (^tapCategoryBtnBlock)(GKEntityCategory * category);
@end

@interface CategroyGroupController () <EntityCellDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;

@property (strong, nonatomic) NSMutableArray * entityArray;
@property (strong, nonatomic) NSMutableArray * categoryArray;
@property (strong, nonatomic) NSMutableArray * firstCategoryArray;
@property (strong, nonatomic) NSMutableArray * secondCategoryArray;

@property (assign, nonatomic) EntityDisplayStyle style;

@property (assign, nonatomic) NSInteger gid;
@property (assign, nonatomic) NSInteger page;

@end

@implementation CategroyGroupController

static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * EntityListCellIdentifier = @"EntityListCell";
static NSString * CategoryHeaderIdentifier = @"CategoryHeader";

- (instancetype)initWithGid:(NSInteger)gid
{
    self = [super init];
    if (self)
    {
        self.gid = gid;
        self.page = 1;
        self.style = ListStyle;
        
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
    [API getGroupEntityWithGroupId:self.gid Page:self.page success:^(NSArray *entities) {
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
    [API getGroupEntityWithGroupId:self.gid Page:self.page success:^(NSArray *entities) {
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
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    [self.collectionView registerClass:[EntityListCell class] forCellWithReuseIdentifier:EntityListCellIdentifier];
    [self.collectionView registerClass:[CategroyGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CategoryHeaderIdentifier];
    
    
    UIButton * styleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * grid_image = [UIImage imageNamed:@"grid"];
    [styleBtn setImage:grid_image forState:UIControlStateNormal];
    styleBtn.frame = CGRectMake(0., 0., grid_image.size.width, grid_image.size.height);
//    styleBtn.tag = self.style;
    [styleBtn addTarget:self action:@selector(styleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * styleBarBtn = [[UIBarButtonItem alloc] initWithCustomView:styleBtn];
    self.navigationItem.rightBarButtonItems = @[styleBarBtn];
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.entityArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableview = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
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
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    switch (self.style) {
        case GridStyle:
        {
            EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityCellIdentifier forIndexPath:indexPath];
            cell.entity = [self.entityArray objectAtIndex:indexPath.row];
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
        {
            EntityListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityListCellIdentifier forIndexPath:indexPath];
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
    switch (self.style) {
        case GridStyle:
            cellsize = CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
            break;
            
        default:
            cellsize = CGSizeMake(kScreenWidth, 110.);
            break;
    }
    
    
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    
    switch (self.style) {
        case GridStyle:
            edge = UIEdgeInsetsMake(3., 3., 3., 3.);
            break;
            
        default:
            edge = UIEdgeInsetsMake(3., 0., 0., 0.);
            break;
    }

    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
    switch (self.style) {
        case GridStyle:
            itemSpacing = 3.;
            break;
            
        default:
            break;
    }

    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0;
    switch (self.style) {
        case GridStyle:
            spacing = 3.;
            break;
            
        default:
            break;
    }
    
    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(kScreenWidth, 55.);
    return headerSize;
}


#pragma mark - <EntityCellDelegate>

- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

#pragma mark - NavBar Button action

- (void)styleBtnAction:(id)sender
{
    UIButton * styleBtn = (UIButton *)sender;
//    NSLog(@"OKOKOKOKO");
    
//    if (styleBtn.tag)
    
    switch (self.style) {
        case ListStyle:
        {
            self.style = GridStyle;
            [styleBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
            [self.collectionView reloadData];

        }
            break;
            
        default:
            self.style = ListStyle;
            [styleBtn setImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];
            [self.collectionView reloadData];
            break;
    }
}

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
        [_Morebtn addTarget:self action:@selector(MorebtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    for (NSInteger i = 0; i < self.categoryArray.count; i++){
        UIButton * categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        GKEntityCategory * sc = [self.categoryArray objectAtIndex:i];
        [categoryBtn setTitle:sc.categoryName forState:UIControlStateNormal];
        [categoryBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        categoryBtn.layer.cornerRadius = 4.;
        categoryBtn.layer.masksToBounds = YES;
        categoryBtn.layer.borderWidth = 0.5;
        categoryBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        categoryBtn.tag = i;
        categoryBtn.frame = CGRectMake(10. + (70 + 5) * i, 15., 70., 25);
        [categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:categoryBtn];
    }
    
    self.Morebtn.frame = CGRectMake(0., 0., 50., 40.);
    self.Morebtn.deFrameTop = 7;
    self.Morebtn.deFrameRight = self.deFrameRight - 16;
}

#pragma mark - Button Action
- (void)MorebtnAction:(id)sender
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
