//
//  HttpClient.h
//  orange
//
//  Created by 谢家欣 on 15/4/4.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "BaseHttpClient.h"

@interface HttpClient : BaseHttpClient


@property (nonatomic, assign) AFNetworkReachabilityStatus reachabilityStatus;


/**
 *  获取共享单例
 *
 *  @return GKHTTPClient的共享单例
 */
+ (HttpClient *)sharedClient;

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
 *  取消所有网络请求
 */
+ (void)cancelAllHTTPOperations;
@end
