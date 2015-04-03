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
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSParameterAssert(path);
    NSParameterAssert(method);
    
    if ([method isEqualToString:@"GET"]) {
        [self GET:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"POST"]) {
        [self POST:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"PUT"]) {
        [self PUT:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"DELETE"]) {
        [self DELETE:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"PATCH"]) {
        [self PATCH:path parameters:parameters success:success failure:failure];
    }
}

//- (void)requestPath:(NSString *)path
//             method:(NSString *)method
//         parameters:(NSDictionary *)parameters
//     dataParameters:(NSDictionary *)dataParameters
//            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    NSParameterAssert(path);
//    NSParameterAssert(method);
//    
//    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [dataParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [formData appendPartWithFileData:obj name:key fileName:@"fileName" mimeType:@""];
//        }];
//    }];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        //        DDLogInfo(@"%@", responseObject);
//        //        NSDictionary *responseDict = [responseString objectFromJSONString];
//        NSDictionary * responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        if (success) {
//            success(operation, responseDict);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(operation, error);
//        }
//    }];
//    
//    [self enqueueHTTPRequestOperation:operation];
//}

@end
