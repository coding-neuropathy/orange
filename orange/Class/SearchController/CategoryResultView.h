//
//  CategoryResultView.h
//  orange
//
//  Created by D_Collin on 16/7/14.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryResultView : UICollectionReusableView

@property (nonatomic , strong)NSMutableArray * categorys;

@property (nonatomic , copy) void (^tapCategoryBlock)(GKEntityCategory * category);

@end
