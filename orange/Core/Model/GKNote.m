//
//  GKNote.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKNote.h"
#import "GKUser.h"

@implementation GKNote

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"note_id"              : @"noteId",
                             @"entity_id"            : @"entityId",
                             @"chief_image"          : @"entityChiefImage",
                             @"is_selected"          : @"marked",
                             @"creater"              : @"creator",
                             @"content"              : @"text",
                             @"figure"               : @"image",
                             @"score_already"        : @"score",
                             @"creator_like_already" : @"creatorLiked",
                             @"poke_count"           : @"pokeCount",
                             @"comment_count"        : @"commentCount",
                             @"created_time"         : @"createdTime",
                             @"updated_time"         : @"updatedTime",
                             @"poke_already"         : @"poked",
                             @"comment_already"      : @"commented",
                             @"ask_already"          : @"asked",
                             @"brand"                : @"brand",
                             @"title"                : @"title",
                             @"category_id"          : @"categoryId",
                             @"candidate_id"         : @"candidateId",
                             @"category_text"        : @"category_text"
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"noteId"];
}

+ (NSArray *)banNames
{
    return @[
             @"poker_id_list",
             @"comment_id_list",
             ];
}

- (void)setCreator:(GKUser *)creator
{
    if ([creator isKindOfClass:[GKUser class]]) {
        _creator = creator;
    } else if ([creator isKindOfClass:[NSDictionary class]]) {
        _creator = [GKUser modelFromDictionary:(NSDictionary *)creator];
    }
}

- (void)setEntityChiefImage:(NSURL *)entityChiefImage
{
    if ([entityChiefImage isKindOfClass:[NSURL class]]) {
        _entityChiefImage = entityChiefImage;
    } else if ([entityChiefImage isKindOfClass:[NSString class]]) {
        _entityChiefImage = [NSURL URLWithString:(NSString *)entityChiefImage];
    }
}

- (NSURL *)entityChiefImage_240x240
{
    return [NSURL URLWithString:[self.entityChiefImage.absoluteString stringByAppendingString:@"_240x240.jpg"]];
}

- (NSDate *)createdDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.createdTime];
}

- (NSDate *)updatedDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.updatedTime];
}

@end
