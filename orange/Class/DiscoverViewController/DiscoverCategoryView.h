//
//  DiscoverCategoryView.h
//  orange
//
//  Created by 谢家欣 on 15/7/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverCategoryView : UICollectionReusableView

@property (strong, nonatomic) NSArray * categories;
@property (nonatomic, copy) void (^tapBlock)(GKCategory * category);

@end
