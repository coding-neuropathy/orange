//
//  GKArticleComment.m
//  orange
//
//  Created by 谢家欣 on 16/7/12.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKArticleComment.h"

@interface GKArticleComment ()

@property (assign, nonatomic) NSTimeInterval createTime;
@property (assign, nonatomic) NSTimeInterval updateTime;

@end


@implementation GKArticleComment

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary * keyDic = @{
                                @"comment_id"       :       @"commentId",
                                @"article_id"       :       @"articleId",
                                @"user"             :       @"user",
                                @"content"          :       @"content",
                                @"create_time"      :       @"createTime",
                                @"update_time"      :       @"updateTime",
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

- (NSDate *)createDatetime
{
    if (!_createDatetime) {
        _createDatetime = [NSDate dateWithTimeIntervalSince1970:self.createTime];
    }
    return _createDatetime;
}

- (NSDate *)updateDatetime
{
    if (!_updateDatetime) {
        _updateDatetime = [NSDate dateWithTimeIntervalSince1970:self.updateTime];
    }
    return _updateDatetime;
}


@end
