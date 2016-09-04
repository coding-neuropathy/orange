//
//  GKOrder.h
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKOrder : GKBaseModel

@property (assign, nonatomic) NSInteger         orderId;
@property (strong, nonatomic) NSString          *orderNumber;
@property (assign, nonatomic) NSInteger         status;
@property (strong, nonatomic) NSArray           *orderItems;
@property (strong, nonatomic) NSDate            *createdDateTime;
@property (strong, nonatomic) NSDate            *updatedDateTime;

@property (assign, getter=orderVolume, nonatomic) NSInteger orderVolume;
@property (assign, getter=orderPrice, nonatomic) float orderPrice;

@end