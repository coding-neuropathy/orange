//
//  BaseHttpClient.m
//  orange
//
//  Created by 谢家欣 on 15/4/3.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "BaseHttpClient.h"

@implementation BaseHttpClient

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
            success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    NSParameterAssert(path);
    NSParameterAssert(method);
    
    if ([method isEqualToString:@"GET"]) {
//        [self GET:path parameters:parameters success:success failure:failure];
        [self GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:success failure:failure];
    } else if ([method isEqualToString:@"POST"]) {
//        [self POST:path parameters:parameters success:success failure:failure];
        [self POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:success failure:failure];
    } else if ([method isEqualToString:@"PUT"]) {
        [self PUT:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"DELETE"]) {
        [self DELETE:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"PATCH"]) {
        [self PATCH:path parameters:parameters success:success failure:failure];
    }
}

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
     dataParameters:(NSDictionary *)dataParameters
            success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    NSParameterAssert(path);
    NSParameterAssert(method);

    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [dataParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [formData appendPartWithFileData:obj name:@"image" fileName:key mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:success failure:failure];
//    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [dataParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [formData appendPartWithFileData:obj name:@"image" fileName:key mimeType:@""];
//        }];
//    } success:success failure:failure];
}

@end
