//
//  EntityTwoGridCell.h
//  Blueberry
//
//  Created by 魏哲 on 13-9-26.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityTwoGridCell.h"

@interface EntityTwoGridCell : UITableViewCell

@property (nonatomic, strong) NSArray *entityArray;

+ (CGFloat)height;

@end
