//
//  MoreArticlesSubCategoryViewController.h
//  orange
//
//  Created by D_Collin on 16/2/16.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

//#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface MoreArticlesSubCategoryViewController : BaseViewController

@property (assign, nonatomic) NSInteger cid;

/* 图文数据源数组 */
@property (nonatomic , strong)NSMutableArray * dataSource;

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource;

@end
