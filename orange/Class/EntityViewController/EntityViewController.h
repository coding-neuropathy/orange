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


@interface EntityViewController :  BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource,
                                                        UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate,
                                                        UITextViewDelegate, UIActionSheetDelegate>
//@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) GKEntity  *entity;
@property (assign, nonatomic) BOOL      navBarEffect;


- (instancetype)initWithEntity:(GKEntity *)entity;

@end
