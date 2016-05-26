//
//  DiscoverController.h
//  orange
//
//  Created by 谢家欣 on 15/7/27.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UISearchController * searchVC;
@end
