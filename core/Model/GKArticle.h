//
//  GKArticle.h
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"
#import "GKUser.h"

@interface GKArticle : GKBaseModel

/**
 *  文章ID
 */
@property (assign, nonatomic) NSInteger articleId;

/**
 *  文章标题
 */
@property (strong, nonatomic) NSString * title;

/**
 *  文章内容
 */
@property (strong, nonatomic) NSString * content;

/**
 *  作者
 *
 */
@property (strong, nonatomic) GKUser * creator;

/**
 *  文章标签
 */
@property (strong, nonatomic) NSArray * tags;

/**
 *  文章封面
 */
@property (strong, nonatomic) NSURL * coverURL;

/**
 *  文章封面 300
 */
@property (strong, nonatomic) NSURL * coverURL_300;

/**
 *  文章 URL
 */
@property (strong, nonatomic) NSURL * articleURL;

/**
 *  文章发布时间
 */
@property (assign, nonatomic) NSTimeInterval pub_time;

/**
 *  文章点赞数
 */
@property (assign, nonatomic) NSInteger dig_count;

/**
 *  是否已经赞过的图文
 */
@property (assign, nonatomic) BOOL IsDig;

/**
 *  图文副标题
 */
@property (strong, nonatomic) NSString * digest;

/**
 *  图文评论数
 */
@property (assign, nonatomic) NSInteger commentCount;

@end
