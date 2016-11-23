//
//  ListViewController.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "ListViewController.h"
#import "IconInfoView.h"

static NSString * CellIdentifer = @"Cell";

@interface ListViewController ()

@property (nonatomic, strong) IconInfoView * iconInfoView;

@end
@implementation ListViewController

#pragma mark - init collction view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout     = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
        _collectionView                         = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.deFrameSize = IS_IPAD   ? CGSizeMake(kScreenWidth - kTabBarWidth, kScreenHeight)
                                                : CGSizeMake(kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
        _collectionView.alwaysBounceVertical    = YES;
        _collectionView.delegate                = self;
        _collectionView.dataSource              = self;
        _collectionView.backgroundColor         = kBackgroundColor;
//        _collectionView.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
    }
    return _collectionView;
}

#pragma mark - init icon info view
- (IconInfoView *)iconInfoView
{
    if (!_iconInfoView) {
        
        _iconInfoView = [[IconInfoView alloc] initWithFrame:CGRectMake(0., 7., 100., 25.)];
        _iconInfoView.categroyText = nil;
        
//        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleView:)];
//        [_iconInfoView addGestureRecognizer:Tap];
        
    }
    return _iconInfoView;
}

- (void)loadView
{
//    [self.view addSubview:self.collectionView];
    self.view = self.collectionView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPAD && self.navigationController.viewControllers.count < 2)
        self.navigationItem.titleView = self.iconInfoView;
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifer];
//    self.collectionView.alwaysBounceVertical = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    kAppDelegate.activeVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.collectionView performBatchUpdates:nil completion:nil];
//         [self.collectionView.collectionViewLayout invalidateLayout];
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

@end

