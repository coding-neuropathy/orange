//
//  BaseHttpClient.h
//  orange
//
//  Created by 谢家欣 on 15/4/3.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface BaseHttpClient : AFHTTPRequestOperationManager

/**
 *  发起网络请求
 *
 *  @param path       请求接口URI
 *  @param method     请求类型(GET/POST)
 *  @param parameters API参数字典
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发起网络请求(带二进制数据)
 *
 *  @param path           请求接口URI
 *  @param method         请求类型(GET/POST)
 *  @param parameters     API参数字典
 *  @param dataParameters Data参数字典
 *  @param success        成功block
 *  @param failure        失败block
 */
- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
     dataParameters:(NSDictionary *)dataParameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
