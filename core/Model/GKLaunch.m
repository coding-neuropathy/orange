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
                             @"launch_id"   : @"launchId",
                             @"title"       : @"title",
                             @"description" : @"desc",
                             @"action"      : @"action",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"launchId"];
}

@end
