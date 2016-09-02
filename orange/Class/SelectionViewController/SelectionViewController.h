//
//  SelectionViewController.h
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface SelectionViewController : ListViewController

// 商品数据源数组
@property (nonatomic, strong) GKSelectionEntity * entityList;

@end
