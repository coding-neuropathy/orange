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
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //        layout.itemSize = CGSizeMake(342., 465);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
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
    
    self.navigationItem.titleView = self.iconInfoView;
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifer];
//    self.collectionView.alwaysBounceVertical = YES;

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
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

@end

