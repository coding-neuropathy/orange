//
//  CategoryGridViewItem.h
//  Blueberry
//
//  Created by 魏哲 on 13-9-24.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKEntityCategory.h"
typedef NS_ENUM(NSInteger, CategoryCridItemType) {
    CategoryCridItemTypeForFourWithIcon,
    CategoryCridItemTypeForFourWithOutIcon,
    CategoryCridItemTypeForThree,
};
@interface CategoryGridItem : UIView

@property (nonatomic, strong) GKEntityCategory *category;
@property (nonatomic, assign) NSInteger type;

@end
