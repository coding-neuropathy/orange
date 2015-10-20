//
//  UserLikeViewController.m
//  orange
//
//  Created by 谢家欣 on 15/10/20.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserLikeViewController.h"
#import "EntityCell.h"

@interface UserLikeViewController () <EntityCellDelegate>

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) NSMutableArray * likeEntities;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (nonatomic, assign) NSTimeInterval likeTimestamp;

@end

@implementation UserLikeViewController

static NSString * EntityIdentifier = @"EntityCell";


- (instancetype)initWithUser:(GKUser *)user
{
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

#pragma mark - init view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        
        //        _collectionView.contentInset = UIEdgeInsetsMake(617, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
    [API getUserLikeEntityListWithUserId:self.user.userId timestamp:[[NSDate date] timeIntervalSince1970] count:30 success:^(NSTimeInterval timestamp, NSArray *entityArray) {
        self.likeEntities = [NSMutableArray arrayWithArray:entityArray];
        self.likeTimestamp = timestamp;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView reloadData];
    }];
}

- (void)loadMore
{
    [API getUserLikeEntityListWithUserId:self.user.userId timestamp:self.likeTimestamp count:30 success:^(NSTimeInterval timestamp, NSArray *entityArray) {
        [self.likeEntities addObjectsFromArray:entityArray];
        self.likeTimestamp = timestamp;
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
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityIdentifier];
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
    
    if (self.likeEntities == 0) {
        [self.collectionView triggerPullToRefresh];
    }
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.likeEntities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityIdentifier forIndexPath:indexPath];
    cell.entity = [self.likeEntities objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0, 0);
    cellsize = CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    edge = UIEdgeInsetsMake(3., 3., 3., 3.);
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 3.;

    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 3.;
    
    return spacing;
}

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

@end
