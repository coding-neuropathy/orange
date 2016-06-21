//
//  EntityViewController.h
//  orange
//
//  Created by huiter on 15/1/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "ListViewController.h"
#import "BaseViewController.h"


@interface EntityViewController :  BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GKEntity *entity;

- (instancetype)initWithEntity:(GKEntity *)entity;

@end
