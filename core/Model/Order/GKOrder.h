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
    Expired,
    AddressUnBind,
    WaitingForPayment,
    Paid,
};

@interface GKOrder : GKBaseModel

/**
 *  order id
 */
@property (assign, nonatomic) NSInteger         orderId;

/**
 *  oreder number
 */
@property (strong, nonatomic) NSString          *orderNumber;

/**
 *  order status
 */
@property (assign, nonatomic) GKOrderState      status;

@property (strong, nonatomic) NSArray           *orderItems;
@property (strong, nonatomic) NSDate            *createdDateTime;
@property (strong, nonatomic) NSDate            *updatedDateTime;

//@property (strong, nonatomic) NSString          *wxPaymentURL;

@property (assign, getter=orderVolume, nonatomic) NSInteger orderVolume;
@property (assign, getter=orderPrice, nonatomic) float orderPrice;

@end
