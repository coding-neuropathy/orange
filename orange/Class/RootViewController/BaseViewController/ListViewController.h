//
//  ListViewController.h
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "BaseViewController.h"

@interface ListViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView * collectionView;

@end
