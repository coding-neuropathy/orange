//
//  AllOrderController.h
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) NSMutableArray    *orderArray;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger size;


- (void)refresh;
- (void)load;

@end
