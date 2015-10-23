//
//  GKCategory.h
//  orange
//
//  Created by 谢家欣 on 15/7/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKCategory : GKBaseModel

/**
 *  分类ID
 */
@property (nonatomic, assign) NSUInteger groupId;

/**
 * 分类名称
 */
@property (nonatomic, strong) NSString * title;

/**
 *  中文名
 */
@property (nonatomic, strong) NSString * title_cn;

/**
 *  英文名
 */
@property (nonatomic, strong) NSString * title_en;

/**
 *  分类封面图片 URL
 */
@property (nonatomic, strong) NSURL *coverURL;

@end
