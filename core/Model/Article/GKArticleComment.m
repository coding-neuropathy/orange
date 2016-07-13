//
//  GKArticleComment.m
//  orange
//
//  Created by 谢家欣 on 16/7/12.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKArticleComment.h"


@implementation GKArticleComment

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary * keyDic = @{
                                @"comment_id"       :       @"commentId",
                                @"article_id"       :       @"articleId",
                                @"user"             :       @"user",
                                @"content"          :       @"content",
                                @"update_time"      :       @"update_time",
                            };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"commentId", @"articleId"];
}

- (void)setUser:(GKUser *)user
{
    if ([user isKindOfClass:[GKUser class]]) {
        _user = user;
    } else if ([user isKindOfClass:[NSDictionary class]]) {
        _user = [GKUser modelFromDictionary:(NSDictionary *)user];
    }
}


@end
