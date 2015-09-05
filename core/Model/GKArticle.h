//
//  GKArticle.h
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKArticle : GKBaseModel

/**
 *  文章 ID
 */
@property (assign, nonatomic) NSInteger * articleId;

/**
 *  文章标题
 */
@property (strong, nonatomic) NSString * title;


/**
 *  文章内容
 */
@property (strong, nonatomic) NSString * content;

@end
