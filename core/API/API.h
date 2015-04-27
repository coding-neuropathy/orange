//
//  API.h
//  orange
//
//  Created by 谢家欣 on 15/4/4.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject


/**
 *  获取精选列表
 *
 *  @param timestamp 时间戳
 *  @param cateId    旧版categoryId(0 ~ 11)
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getSelectionListWithTimestamp:(NSTimeInterval)timestamp
//                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *dataArray))success
                              failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取热门商品列表
 *
 *  @param type    类型(24小时/7天)
 *  @param success 成功block
 *  @param failure 失败block
 */
+(void)getHotEntityListWithType:(NSString *)type
                        success:(void (^)(NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取 24小时 Top 10 商品列表
 *
 *  @param count   获取商品个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getTopTenEntityCount:(NSInteger)count
                     success:(void (^)(NSArray * array))success
                     failure:(void (^)(NSInteger stateCode))failure;

@end
