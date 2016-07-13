//
//  GKArticleComment.h
//  orange
//
//  Created by 谢家欣 on 16/7/12.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"
#import "GKUser.h"

@interface GKArticleComment : GKBaseModel

/**
 *  文章ID
 */
@property (assign, nonatomic) NSInteger articleId;

/**
 *  文章评论ID
 */
@property (assign, nonatomic) NSInteger commentId;

/**
 *  评论创建者
 */
@property (nonatomic, strong) GKUser *user;

/**
 *  评论内容
 */
@property (strong, nonatomic) NSString * content;


/**
 *  创建时间
 */
@property (strong, nonatomic) NSDate * createDatetime;


/**
 *  更新时间
 */
@property (strong, nonatomic) NSDate * updateDatetime;

@end
