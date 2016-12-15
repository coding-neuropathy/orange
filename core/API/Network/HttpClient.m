//
//  HttpClient.m
//  orange
//
//  Created by 谢家欣 on 15/4/4.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HttpClient.h"
#import "NSDictionary+Sign.h"

@interface HttpClient ()

//@property (strong, nonatomic, readwrite) NSURL * baseURL;

@end

@implementation HttpClient

+ (HttpClient *)sharedClient
{
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    static HttpClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[HttpClient alloc] initWithBaseURL:baseURL];
    });
//    sharedClient.baseURL = baseURL;
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    NSParameterAssert(url);
    
    self = [super initWithBaseURL:url];
    if (self) {
        NSOperationQueue *operationQueue = self.operationQueue;
        
        __weak __typeof(&*self)weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
        [self.reachabilityManager startMonitoring];
    }
    return self;
}


- (void)successLogWithOperation:(NSURLSessionDataTask *)operation responseObject:(id)responseObject
{
    // NSInteger stateCode = operation.response.statusCode;
    NSString *urlString = operation.response.URL.absoluteString;
    NSLog(@"url %@", urlString);
}

- (NSInteger)failureLogWithOperation:(NSURLSessionDataTask *)operation responseObject:(NSError *)error
{
//    NSInteger stateCode = operation.response.statusCode;
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)operation.response;
    
    NSInteger stateCode = httpResponse.statusCode;
    
//    NSString *urlString = [[error userInfo] valueForKey:@"NSErrorFailingURLKey"];
//    if (!urlString) {
//        urlString = operation.response.URL.absoluteString;
//    }
//    
    if (stateCode == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GKNetworkReachabilityStatusNotReachable" object:nil];
    }
    
    return stateCode;
}

- (void)requestPath:(NSString *)path method:(NSString *)method
                parameters:(NSDictionary *)parameters
                success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                failure:(void (^)(NSInteger, NSError *error))failure
{
#ifndef TARGET_OS_IOS
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
    [super requestPath:path method:method parameters:[parameters configParameters] success:^(NSURLSessionDataTask *operation, id responseObject) {
#ifdef DDLogInfo
        [self successLogWithOperation:operation responseObject:responseObject];
#endif
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         NSInteger stateCode = [self failureLogWithOperation:operation responseObject:error];
//        NSLog(@"error %@", [[error userInfo] allKeys]);
//        NSLog(@"error %@", [[error userInfo] objectForKey:@"NSErrorFailingURLKey"]);
//        NSData      *data   = [[error userInfo] objectForKey:@"com.alamofire.serialization.response.error.data"];
//        NSString    *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", string);
        if (failure) {
            failure(stateCode, error);
        }
    }];
}

- (void)requestPath:(NSString *)path method:(NSString *)method
                parameters:(NSDictionary *)parameters
                dataParameters:(NSDictionary *)dataParameters
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSInteger, NSError *))failure
{
    [super requestPath:path method:method parameters:[parameters configParameters] dataParameters:dataParameters success:^(NSURLSessionDataTask *operation, id responseObject) {
#ifdef DDLogInfo
        [self successLogWithOperation:operation responseObject:responseObject];
#endif
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSInteger stateCode = [self failureLogWithOperation:operation responseObject:error];
        
        if (failure) {
            failure(stateCode, error);
        }
    }];
}

- (void)cancelAllHTTPOperations
{
    [self.operationQueue cancelAllOperations];
}

@end
