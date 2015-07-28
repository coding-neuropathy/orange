//
//  DiscoverController.m
//  orange
//
//  Created by 谢家欣 on 15/7/27.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverController.h"
#import "UIScrollView+Slogan.h"
#import "DiscoverHeaderView.h"
#import "EntityCell.h"

@interface DiscoverController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EntityCellDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * bannerArray;
@property (strong, nonatomic) NSArray * categoryArray;
@property (strong, nonatomic) NSArray * entityArray;

@end

@implementation DiscoverController

static NSString * EntityCellIdentifier = @"EntityCell";

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
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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


#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
    
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
