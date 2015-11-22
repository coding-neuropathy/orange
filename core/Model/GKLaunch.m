//
//  GKLaunch.m
//  orange
//
//  Created by 谢家欣 on 15/11/22.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "GKLaunch.h"

@implementation GKLaunch

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"title"       : @"title",
                             @"description" : @"description",
                             @"action"      : @"action",
//                             @"comment_id"           : @"commentId",
//                             @"note_id"              : @"noteId",
//                             @"entity_id"            : @"entityId",
//                             @"creator"              : @"creator",
//                             @"content"              : @"text",
//                             @"created_time"         : @"createdTime",
//                             @"updated_time"         : @"updatedTime",
//                             @"reply_to_comment_id"  : @"repliedCommentId",
//                             @"reply_to_user"        : @"repliedUser",
                             };
    
    return keyDic;
}

@end
