//
//  GKPurchase.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"

/**
 *  购买链接
 */
@interface GKPurchase : GKBaseModel

/**
 * 上下架状态
 */
typedef NS_ENUM(NSInteger, GKBuyLinkStatus) {
    GKBuyREMOVE = 0,
    GKBuySOLDOUT,
    GKBuySALE,
};

/**
 *  店铺名称
 */
@property (nonatomic, strong) NSString *shopName;

/**
 *  购买链接
 */
@property (nonatomic, strong) NSURL *buyLink;

/**
 *  最低价格
 */
@property (nonatomic, assign) float lowestPrice;

/**
 *  最近售出数量
 */
@property (nonatomic, assign) NSInteger volume;

/**
 *  上下架状态
 */
@property (nonatomic, assign) GKBuyLinkStatus status;

/**
 *  店家ID （目前，仅限淘宝天猫）
 */
@property (nonatomic, strong) NSString * seller;

/**
 * 来源商品 ID
 */
@property (nonatomic, strong) NSString * origin_id;

/*
 * 来源
 */
@property (nonatomic, strong) NSString * source;


@end
