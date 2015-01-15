//
//  CategoryGridCell.h
//  Blueberry
//
//  Created by 魏哲 on 13-9-24.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryGridItem.h"
typedef NS_ENUM(NSInteger, CategoryCridCellType) {
    CategoryCridCellTypeForFourWithIcon,
    CategoryCridCellTypeForFourWithOutIcon,
};

@interface CategoryGridCell : UITableViewCell

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, assign) NSInteger type;
+ (CGFloat)height;

@end
