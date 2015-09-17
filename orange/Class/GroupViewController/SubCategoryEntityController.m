//
//  SubCategoryEntityController.m
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "SubCategoryEntityController.h"
#import "EntityCell.h"
#import "EntityListCell.h"


@interface SubCategoryEntityController () <EntityCellDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) GKEntityCategory * subcategory;
@property (strong, nonatomic) NSMutableArray * entityArray;
@property (strong, nonatomic) NSString * sort;
@property (assign, nonatomic) EntityDisplayStyle style;

@end

@implementation SubCategoryEntityController

static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * EntityListCellIdentifier = @"EntityListCell";

- (instancetype)initWithSubCategory:(GKEntityCategory *)subcategory
{
    self = [super init];
    if (self) {
        _subcategory = subcategory;
        self.sort = @"time";
        self.style = ListStyle;
    }
    return self;
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
    [API getEntityListWithCategoryId:self.subcategory.categoryId sort:self.sort reverse:NO offset:0 count:30 success:^(NSArray *entityArray) {
        self.entityArray = [NSMutableArray arrayWithArray:entityArray];
        
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
    [self.collectionView registerClass:[EntityListCell class] forCellWithReuseIdentifier:EntityListCellIdentifier];
    
    
    /**
     * 切换 entity 样式按钮
     */
    UIButton * styleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * grid_image = [UIImage imageNamed:@"grid"];
    [styleBtn setImage:grid_image forState:UIControlStateNormal];
    styleBtn.frame = CGRectMake(0., 0., grid_image.size.width, grid_image.size.height);
    [styleBtn addTarget:self action:@selector(styleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * styleBarBtn = [[UIBarButtonItem alloc] initWithCustomView:styleBtn];
    
    /**
     * 切换排序样式按钮
     */
    UIButton * ltBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * time_image = [UIImage imageNamed:@"like top"];
    [ltBtn setImage:time_image forState:UIControlStateNormal];
    ltBtn.frame = CGRectMake(0., 0., time_image.size.width, time_image.size.height);
    [ltBtn addTarget:self action:@selector(ltBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * ltBarBtn = [[UIBarButtonItem alloc] initWithCustomView:ltBtn];

    self.navigationItem.rightBarButtonItems = @[styleBarBtn, ltBarBtn];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.entityArray.count;
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

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}


#pragma mark - button action
- (void)styleBtnAction:(id)sender
{
    UIButton * styleBtn = (UIButton *)sender;
    
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

- (void)ltBtnAction:(id)sender
{
    UIButton * ltBtn = (UIButton *)sender;
    
    if ([self.sort isEqualToString:@"time"]) {
        self.sort = @"like";
        [self.collectionView triggerPullToRefresh];
        [ltBtn setImage:[UIImage imageNamed:@"time_top"] forState:UIControlStateNormal];
    } else {
        self.sort = @"time";
        [self.collectionView triggerPullToRefresh];
        [ltBtn setImage:[UIImage imageNamed:@"like top"] forState:UIControlStateNormal];
    }
}

@end
