//
//  GKUser.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKUser.h"

@implementation GKUser
@synthesize avatarURL = _avatarURL;
@synthesize avatarURL_s = _avatarURL_s;

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"user_id"          : @"userId",
                             @"nickname"         : @"nickname",
                             @"sina_screen_name" : @"sinaScreenName",
                             @"taobao_nick"      : @"taobaoScreenName",
                             @"avatar_large"     : @"avatarURL",
                             @"avatar_small"     : @"avatarURL_s",
                             @"is_active"        : @"user_state",
                             @"gender"           : @"gender",
                             @"bio"              : @"bio",
                             @"following_count"  : @"followingCount",
                             @"fan_count"        : @"fanCount",
                             @"article_count"    : @"articleCount",
                             @"money_i_need"     : @"totalMoney",
                             @"like_count"       : @"likeCount",
                             @"entity_note_count": @"noteCount",
                             @"tag_count"        : @"tagCount",
                             @"dig_count"        : @"digCount",
//                             @"same_follow"      : @"sameFollowArray",
//                             @"like_statistics"  : @"likeStatisticsDic",
//                             @"expert_statistics": @"expertStatisticsDic",
                             @"relation"         : @"relation",
                             @"email"            : @"email",
                             @"location"         : @"location",
                             @"mail_verified'"   : @"mail_verified",
                             @"authorized_author": @"authorized_author",
                             @"authorized_seller": @"authorized_seller",
                             @"nick"             : @"nick",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"userId"];
}

+ (NSArray *)banNames
{
    return @[
             @"likeStatisticsArray",
             @"expertStatisticsArray",
             ];
}


- (void)setAvatarURL:(NSURL *)avatarURL
{
    if ([avatarURL isKindOfClass:[NSURL class]]) {
        _avatarURL = avatarURL;
    } else if ([avatarURL isKindOfClass:[NSString class]]) {
        _avatarURL = [NSURL URLWithString:(NSString *)avatarURL];
    }
}

- (void)setAvatarURL_s:(NSURL *)avatarURL_s
{
    if ([avatarURL_s isKindOfClass:[NSURL class]]) {
        _avatarURL_s = avatarURL_s;
    } else if ([avatarURL_s isKindOfClass:[NSString class]]) {
        _avatarURL_s = [NSURL URLWithString:(NSString *)avatarURL_s];
    }
}

//- (NSString *)gender
//{
//    if ([_gender isEqualToString:@"M"]) {
//        return @"男";
//    } else if ([_gender isEqualToString:@"F"]) {
//        return @"女";
//    } else {
//        return @"其他";
//    }
//}

- (NSString *)location
{
    if (!_location) {
        return @"";
    }
    return _location;
}

- (NSURL *)avatarURL_s
{
    NSRange range =[[_avatarURL_s absoluteString] rangeOfString:@"avatar/default"];
    if (range.location != NSNotFound) {
        if ([_gender isEqualToString:@"M"]) {
            return [NSURL URLWithString:@"https://imgcdn.guoku.com/avatar/large_241168_e55b9a0dca05d994949759833e904256.png"];
        }
        if ([_gender isEqualToString:@"F"]) {
            return [NSURL URLWithString:@"https://imgcdn.guoku.com/avatar/large_241169_92feeb8dc546542a8577e1edb0f80af2.png"];
        }
        if ([_gender isEqualToString:@"O"]) {
            return [NSURL URLWithString:@"https://imgcdn.guoku.com/avatar/large_241170_637c2ee4729634de9fc848f9754c263b.png"];
        }
    }
    return _avatarURL_s;

}

- (NSURL *)avatarURL
{
    NSRange range =[[_avatarURL absoluteString] rangeOfString:@"avatar/default"];
    if (range.location != NSNotFound) {
        if ([_gender isEqualToString:@"M"]) {
            return [NSURL URLWithString:@"https://imgcdn.guoku.com/avatar/large_241168_e55b9a0dca05d994949759833e904256.png"];
        }
        if ([_gender isEqualToString:@"F"]) {
            return [NSURL URLWithString:@"https://imgcdn.guoku.com/avatar/large_241169_92feeb8dc546542a8577e1edb0f80af2.png"];
        }
        if ([_gender isEqualToString:@"O"]) {
            return [NSURL URLWithString:@"https://imgcdn.guoku.com/avatar/large_241170_637c2ee4729634de9fc848f9754c263b.png"];
        }
    }
    return _avatarURL;

}

@end
