//
//  GKOrder.h
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

/**
 *  用户状态
 */
typedef NS_ENUM(NSInteger, GKOrderState) {
    AddressUnBind,
    WaitingForPayment,
    Paid,
};

@interface GKOrder : GKBaseModel

@property (assign, nonatomic) NSInteger         orderId;
@property (strong, nonatomic) NSString          *orderNumber;
@property (assign, nonatomic) GKOrderState      status;
@property (strong, nonatomic) NSArray           *orderItems;
@property (strong, nonatomic) NSDate            *createdDateTime;
@property (strong, nonatomic) NSDate            *updatedDateTime;

@property (assign, getter=orderVolume, nonatomic) NSInteger orderVolume;
@property (assign, getter=orderPrice, nonatomic) float orderPrice;

@end
