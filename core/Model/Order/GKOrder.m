//
//  GKOrder.m
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKOrder.h"
#import "GKOrderItem.h"

@interface GKOrder ()

@property (assign, nonatomic) NSTimeInterval    createdTimestamp;
@property (assign, nonatomic) NSTimeInterval    updatedTimestamp;

@end

@implementation GKOrder

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                                @"order_id"             : @"orderId",
                                @"number"               : @"orderNumber",
                                @"status"               : @"status",
                                @"created_datetime"     : @"createdTimestamp",
                                @"updated_dateTime"     : @"updatedTimestamp",
                                @"order_items"          : @"orderItems",
//                                @"wx_payment_qrcode_url": @"wxPaymentURL",
                             };
    
    return keyDic;
}

- (void)setOrderNumber:(NSString *)orderNumber
{
    _orderNumber = [orderNumber stringByReplacingOccurrencesOfString:@"_" withString:@""];
}

- (void)setOrderItems:(NSArray *)orderItems
{
//    NSLog(@"item %@", orderItems);
//    GKOrderItem * orderItem;
    if ([orderItems.firstObject isKindOfClass:[GKOrderItem class]]) {
        _orderItems = orderItems;
    } else {
        NSMutableArray * orderItemArray = [NSMutableArray arrayWithCapacity:orderItems.count];
        for (NSDictionary * row in orderItems) {
            NSLog(@"row %@", row);
            GKOrderItem * orderItem = [GKOrderItem modelFromDictionary:row];
            [orderItemArray addObject:orderItem];
        }
        _orderItems = orderItemArray;
    }
}

- (NSDate *)createdDateTime
{
    return [NSDate dateWithTimeIntervalSince1970:self.createdTimestamp];
}

- (NSDate *)updatedDateTime
{
    return [NSDate dateWithTimeIntervalSince1970:self.updatedTimestamp];
}

- (NSInteger)orderVolume
{
    NSInteger volume = 0;
    for (GKOrderItem * orderItem in self.orderItems) {
        volume += orderItem.volume;
    }
    return volume;
}

- (float)orderPrice
{
    float price = 0.;
    for (GKOrderItem * orderItem in self.orderItems) {
        price += orderItem.promoTotalPrice;
    }
    return price;
}


@end
