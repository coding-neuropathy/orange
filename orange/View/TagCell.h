//
//  TagCell.h
//  Blueberry
//
//  Created by 魏哲 on 13-12-5.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCell : UITableViewCell

@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) NSInteger entityCount;

+ (CGFloat)height;

@end
