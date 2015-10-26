//
//  GKEntityCategory.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKEntityCategory.h"

@implementation GKEntityCategory

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"category_id"         : @"categoryId",
                             @"category_title"      : @"categoryName",
                             @"category_icon_large" : @"iconURL",
                             @"category_icon_small" : @"iconURL_s",
                             @"status"              : @"status",
                             @"like_count"          : @"likeCount",
                             @"note_count"          : @"noteCount",
                             @"entity_count"        : @"entityCount",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"categoryId"];
}

+ (NSArray *)banNames
{
    return @[
             @"group_id",
             @"category_icon",
             @"title",
             ];
}

- (void)setIconURL:(NSURL *)iconURL
{
    if ([iconURL isKindOfClass:[NSURL class]]) {
        _iconURL = iconURL;
    } else if ([iconURL isKindOfClass:[NSString class]]) {
        _iconURL = [NSURL URLWithString:(NSString *)iconURL];
    }
}

- (void)setIconURL_s:(NSURL *)iconURL_s
{
    if ([iconURL_s isKindOfClass:[NSURL class]]) {
        _iconURL_s = iconURL_s;
    } else if ([iconURL_s isKindOfClass:[NSString class]]) {
        _iconURL_s = [NSURL URLWithString:(NSString *)iconURL_s];
    }
}

//- (NSString *)categoryName
- (void)setCategoryName:(NSString *)categoryName
{
    _categoryName = categoryName;
    NSArray * categoryNameList = [categoryName componentsSeparatedByString:@"-"];
    
    if (categoryNameList.count > 1) {
        _categoryName =  categoryNameList[0];
    }
//    return _categoryName;
}

@end
