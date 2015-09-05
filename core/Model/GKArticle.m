//
//  GKArticle.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKArticle.h"

@implementation GKArticle

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary * keyDic = @{
                            @"id"           :   @"articleId",
                            @"title"        :   @"title",
                            @"content"      :   @"content",
                            @"url"          :   @"url",
                            @"read_count"   :   @"read_count",
                            @"cover"        :   @"cover",
                            @"creator"      :   @"creator",
                    };
    
    return keyDic;
}

@end
