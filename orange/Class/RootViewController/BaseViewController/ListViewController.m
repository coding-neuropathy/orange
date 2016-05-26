//
//  ListViewController.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "ListViewController.h"

static NSString * CellIdentifer = @"Cell";

@interface ListViewController ()

@end

@implementation ListViewController


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

- (void)loadView
{
//    [super loadView];
    
//    [self.view addSubview:self.collectionView];
    self.view = self.collectionView;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifer];
//    self.collectionView.alwaysBounceVertical = YES;

}

#pragma mark - UITableViewDataSource

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

@end

