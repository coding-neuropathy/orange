//
//  SubCategoryGroupController.m
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "SubCategoryGroupController.h"
#import "SubCategoryEntityController.h"

@interface SubCategoryCell : UICollectionViewCell

@property (strong, nonatomic) GKEntityCategory * entityCategory;
@property (strong, nonatomic) UILabel * categoryLabel;


@end

@interface SubCategoryGroupController ()

@property (strong, nonatomic) NSArray * subCateories;
@property (strong, nonatomic) UICollectionView * collectionView;

@end

@implementation SubCategoryGroupController

static NSString * SubCategoryIdentifiter = @"SubCategoryCell";

- (instancetype)initWithSubCategories:(NSArray *)subcategories
{
    self = [super init];
    if (self) {
        self.subCateories = subcategories;
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

- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[SubCategoryCell class] forCellWithReuseIdentifier:SubCategoryIdentifiter];
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.subCateories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubCategoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SubCategoryIdentifiter forIndexPath:indexPath];
    cell.entityCategory = [self.subCateories objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake((kScreenWidth - 32)/4, 30.);
    
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(16., 16., 16., 16.);
    
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 16.;
    return spacing;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKEntityCategory * subCategory = [self.subCateories objectAtIndex:indexPath.row];
    
    SubCategoryEntityController * VC = [[SubCategoryEntityController alloc] initWithSubCategory:subCategory];
    VC.title = subCategory.categoryName;
    [self.navigationController pushViewController:VC animated:YES];
}

@end

@implementation SubCategoryCell

- (UILabel *)categoryLabel
{
    if (!_categoryLabel)
    {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categoryLabel.font = [UIFont systemFontOfSize:18];
        _categoryLabel.textColor = UIColorFromRGB(0x427EC0);
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_categoryLabel];
    }
    return _categoryLabel;
}

- (void)setEntityCategory:(GKEntityCategory *)entityCategory
{
    _entityCategory = entityCategory;
    self.categoryLabel.text = _entityCategory.categoryName;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryLabel.frame = CGRectMake(0., 0., 80., 30);
    
}

@end
