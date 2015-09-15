//
//  EntityViewController.h
//  orange
//
//  Created by huiter on 15/1/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GKEntity *entity;

- (instancetype)initWithEntity:(GKEntity *)entity;

@end
