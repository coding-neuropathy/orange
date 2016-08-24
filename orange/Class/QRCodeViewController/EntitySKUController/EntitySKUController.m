//
//  EntitySKUController.m
//  orange
//
//  Created by 谢家欣 on 16/8/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUController.h"

#import "EntitySKUHeaderView.h"
#import "EntitySKUCell.h"


@interface SKUHeaderSection : UICollectionReusableView

@property (strong, nonatomic) UILabel *titleLabel;

@end

@interface EntitySKUController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

typedef NS_ENUM(NSInteger, SKUSectionType) {
    EntitySKUHeaderSection = 0,
    SKUSection,
};


@property (strong, nonatomic) NSString          *entity_hash;
@property (strong, nonatomic) GKEntity          *entity;

@property (strong, nonatomic) UIButton          *continueAddBtn;
@property (strong, nonatomic) UICollectionView  *collectionView;


@end

@implementation EntitySKUController



static NSString * SKUCellIdentifier                 = @"SKUCell";
static NSString * EntitySKUReuseHeaderIdentifier    = @"EntityHeader";
static NSString * SKUHeaderIdentifier               = @"SKUHeader";

- (instancetype)initWithEntityHash:(NSString *)hash
{
    self = [super init];
    if (self) {
        self.entity_hash = hash;
    }
    return self;
}

#pragma mark - lazy load view
- (UIButton *)continueAddBtn
{
    if (!_continueAddBtn) {
        _continueAddBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueAddBtn.titleLabel.font         = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _continueAddBtn.deFrameSize             = CGSizeMake(70., 22.);
        [_continueAddBtn setTitle:NSLocalizedStringFromTable(@"continue-add", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_continueAddBtn setTitleColor:UIColorFromRGB(0x5976c1) forState:UIControlStateNormal];
        [_continueAddBtn addTarget:self action:@selector(continueAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _continueAddBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout      = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
        
        _collectionView                         = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.deFrameSize             = CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
        _collectionView.delegate                = self;
        _collectionView.dataSource              = self;
        _collectionView.backgroundColor         = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title                   = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    self.navigationItem.rightBarButtonItem      = [[UIBarButtonItem alloc] initWithCustomView:self.continueAddBtn];
    
    [self.collectionView registerClass:[EntitySKUCell class] forCellWithReuseIdentifier:SKUCellIdentifier];
    [self.collectionView registerClass:[EntitySKUHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntitySKUReuseHeaderIdentifier];
    [self.collectionView registerClass:[EntitySKUHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SKUHeaderIdentifier];
    
    [self.view addSubview:self.collectionView];
    
    [API getEntitySKUWithHash:self.entity_hash Success:^(GKEntity *entity) {
        
        self.entity = entity;
        
        [self.collectionView reloadData];
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count         = 0;
    
//    return self.entity.skuArray.count;
    switch (section) {
        case SKUSection:
            count           = self.entity.skuArray.count;
            break;
        default:
            break;
    }
    
    return count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseableview                 = [UICollectionReusableView new];
    
    switch (indexPath.section) {
        case EntitySKUHeaderSection:
        {
            EntitySKUHeaderView * entityHeaderView          = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntitySKUReuseHeaderIdentifier forIndexPath:indexPath];
            entityHeaderView.entity                            = self.entity;
            
            reuseableview                                   = entityHeaderView;
            
        }
            break;
        case SKUSection:
        {
            SKUHeaderSection *skuHeaderView                 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SKUHeaderIdentifier forIndexPath:indexPath];
            
            reuseableview                                   = skuHeaderView;
        }
            break;
        default:
            break;
    }
    return reuseableview;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntitySKUCell *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:SKUCellIdentifier forIndexPath:indexPath];
    
    cell.sku                = [self.entity.skuArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize               = CGSizeMake(0., 0.);
    
    switch (section) {
        case EntitySKUHeaderSection:
        {
            headerSize              = CGSizeMake(kScreenWidth, 342. * kScreeenScale);
        }
            break;
        case SKUSection:
        {
            headerSize              = CGSizeMake(kScreenWidth, 52.);
        }
            break;
        default:
            break;
    }
    
    
    return headerSize;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize                 = CGSizeMake(0., 0.);
    switch (indexPath.section) {
        case SKUSection:
        {
            GKEntitySKU * sku       = [self.entity.skuArray objectAtIndex:indexPath.row];
            CGFloat width           = [EntitySKUCell cellWidthWithSKU:sku];
            if (width > 0)
                cellSize                = CGSizeMake(width, 24);
        }
            break;
            
        default:
            break;
    }
    
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge       = UIEdgeInsetsMake(0., 0., 0., 0.);
    switch (section) {
        case SKUSection:
            edge            = UIEdgeInsetsMake(0., 24., 0., 24.);
            break;
            
        default:
            break;
    }
    
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat lineSpacing     = 0;
    
    switch (section) {
        case SKUSection:
            lineSpacing     = 12.;
            break;
            
        default:
            break;
    }
    
    return lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing     = 0;
    
    switch (section) {
        case SKUSection:
            itemSpacing     = 10.;
            break;
        default:
            break;
    }
    return itemSpacing;
}

#pragma mark - button action
- (void)continueAddBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end



#pragma mark - SKUHeaderSection

@implementation SKUHeaderSection

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel             = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font        = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _titleLabel.textColor   = UIColorFromRGB(0x212121);
        
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
