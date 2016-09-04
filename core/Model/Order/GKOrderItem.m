//
//  GkOrderItem.m
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GkOrderItem.h"

@implementation GKOrderItem

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"entity_title"        : @"entityTitle",
                             @"attr"                : @"skuAttr",
                             @"volume"              : @"volume",
                             @"entity_image"        : @"imageURL",
                             @"grand_total_price"   : @"totalPrice",
                             @"promo_total_price"   : @"promoTotalPrice",
                             @"add_time"            : @"AddDateTime",
                             };
    
    return keyDic;
}

@end
