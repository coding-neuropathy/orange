//
//  MoreArticlesViewController.h
//  orange
//
//  Created by D_Collin on 16/2/3.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreArticlesViewController : UIViewController

/* 图文数据源数组 */
@property (nonatomic , strong)NSArray * dataSource;

- (instancetype)initWithDataSource:(NSArray *)dataSource;

@end
