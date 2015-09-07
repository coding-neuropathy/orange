//
//  GKArticle.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKArticle.h"
#import "NSString+Helper.h"

@interface GKArticle ()

@property (strong, nonatomic) NSString * cover;
@property (strong, nonatomic) NSString * url_string;

@end

@implementation GKArticle

static NSString * imageHost = @"http://imgcdn.guoku.com/";

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary * keyDic = @{
                            @"article_id"   :   @"articleId",
                            @"title"        :   @"title",
                            @"content"      :   @"content",
//                            @"url"          :   @"url",
                            @"read_count"   :   @"read_count",
                            @"cover"        :   @"cover",
                            @"url"          :   @"url_string",
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
    NSString * url_stirng = [NSString stringWithFormat:@"%@%@", imageHost, self.cover];
    ;
    return [NSURL URLWithString:[url_stirng imageURLWithSize:240.]];
}

- (NSURL *)articleURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.guoku.com%@", self.url_string]];
}

@end
