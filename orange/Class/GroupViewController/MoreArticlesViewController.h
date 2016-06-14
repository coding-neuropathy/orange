//
//  MoreArticlesViewController.h
//  orange
//
//  Created by D_Collin on 16/2/3.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface MoreArticlesViewController : ListViewController

@property (assign, nonatomic) NSInteger gid;

/* 图文数据源数组 */
@property (nonatomic , strong)NSMutableArray * dataSource;

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource;

@end
