//
//  GAdvertise.m
//  orange
//
//  Created by 谢家欣 on 16/10/14.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GAdvertise.h"

@interface GAdvertise ()

@property (strong, nonatomic) NSString  *clickURLString;

@end

@implementation GAdvertise

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"id"              : @"AdvertiseId",
                             @"click_url"       : @"clickURLString",
                             @"image_url"       : @"imageURL",
                             };
    
    return keyDic;
}

- (NSURL *)clickURL
{
    return [NSURL URLWithString:self.clickURLString];
}


@end
