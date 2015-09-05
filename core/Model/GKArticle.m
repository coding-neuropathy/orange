//
//  GKArticle.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKArticle.h"

@interface GKArticle ()

@property (strong, nonatomic) NSString * cover;

@end

@implementation GKArticle

static NSString * imageHost = @"http://imgcdn.guoku.com/";

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary * keyDic = @{
                            @"article_id"    :   @"articleId",
                            @"title"        :   @"title",
                            @"content"      :   @"content",
                            @"url"          :   @"url",
                            @"read_count"   :   @"read_count",
                            @"cover"        :   @"cover",
                            @"creator"      :   @"creator",
                    };
    
    return keyDic;
}

//+ (NSArray *)keyNames
//{
//    return @[@"id"];
//}

- (NSURL *)coverURL
{
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageHost, self.cover]];
}

@end
