//
//  GKLaunch.m
//  orange
//
//  Created by 谢家欣 on 15/11/22.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "GKLaunch.h"

@interface GKLaunch ()

@property (strong, nonatomic) NSString * launch_image_url;
@property (strong, nonatomic) NSString * action;

@end

@implementation GKLaunch

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"launch_id"   : @"launchId",
                             @"title"       : @"title",
                             @"description" : @"desc",
                             @"action"      : @"action",
                             @"launch_image_url"    : @"launch_image_url",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"launchId"];
}

- (NSURL *)launchImageUrl
{
    NSURL * image_url = [NSURL URLWithString:self.launch_image_url];
    
    return image_url;
}

- (NSURL *)actionURL
{
    return [NSURL URLWithString:self.action];
}

@end
