//
//  GKCategory.m
//  orange
//
//  Created by 谢家欣 on 15/7/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKCategory.h"

@implementation GKCategory

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                                @"id"       :   @"groupId",
                                @"status"   :   @"status",
                                @"title"    :   @"title",
                                @"cover_url":   @"coverURL",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"groupId"];
}

- (void)setCoverURL:(NSURL *)coverURL
{
    if ([coverURL isKindOfClass:[NSURL class]]) {
        _coverURL = coverURL;
    } else if ([coverURL isKindOfClass:[NSString class]]) {
        _coverURL = [NSURL URLWithString:(NSString *)coverURL];
    }
}

@end
