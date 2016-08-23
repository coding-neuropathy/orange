//
//  GKEntitySKU.h
//  orange
//
//  Created by 谢家欣 on 16/8/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKEntitySKU : GKBaseModel

@property (assign, nonatomic) NSInteger     skuId;
@property (strong, nonatomic) NSString      *entityId;
@property (assign, nonatomic) float         originPrice;
@property (assign, nonatomic) float         promoPrice;
@property (assign, nonatomic) float         discount;
@property (strong, nonatomic) NSDictionary  *attrs;
@property (assign, nonatomic) NSInteger     stock;
@property (assign, nonatomic) BOOL          status;


@end
