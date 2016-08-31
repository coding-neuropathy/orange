//
//  ShoppingCart.m
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ShoppingCart.h"

@implementation ShoppingCart

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"cart_id"         : @"cartId",
                             @"volume"          : @"volume",
                             @"entity"          : @"entity",
                             @"sku"             : @"sku",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"cartId"];
}

- (void)setEntity:(id)entity
{
    if ([entity isKindOfClass:[GKEntity class]]) {
        _entity             = entity;
    } else {
        _entity             = [GKEntity modelFromDictionary:entity];
    }
}

- (void)setSku:(id)sku
{
    if ([sku isKindOfClass:[GKEntitySKU class]]) {
        _sku                = sku;
    } else {
        _sku                = [GKEntitySKU modelFromDictionary:sku];
    }
}


- (float)price
{
#if DEBUG
    NSLog(@"%ld", self.volume);
#endif
    return self.sku.promoPrice * self.volume;
}



@end
