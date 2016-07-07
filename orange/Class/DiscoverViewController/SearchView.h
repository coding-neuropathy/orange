//
//  SearchView.h
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView
/** 最近搜索记录 */
@property (nonatomic , strong) NSArray * recentArray;
/** 热门搜索推荐 */
@property (nonatomic , strong) NSArray * hotArray;

@property (nonatomic, copy) void (^taphotCategoryBtnBlock)(GKEntityCategory * category);

@end
