//
//  ShoppingCart.h
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"
#import "GKEntitySKU.h"
#import "GkEntity.h"

@interface ShoppingCart : GKBaseModel


@property (assign, nonatomic) NSInteger     cartId;
@property (assign, nonatomic) NSInteger     volume;
@property (strong, nonatomic) GKEntity      *entity;
@property (strong, nonatomic) GKEntitySKU   *sku;

@property (assign, nonatomic) float         price;

@end
