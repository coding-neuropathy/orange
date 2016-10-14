//
//  GAdvertise.m
//  orange
//
//  Created by 谢家欣 on 16/10/14.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GAdvertise.h"

@implementation GAdvertise

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"id"              : @"AdvertiseId",
                             @"click_url"       : @"clickURL",
                             @"image_url"       : @"imageURL",
                             };
    
    return keyDic;
}


@end
