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


- (void)successLogWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject
{
    // NSInteger stateCode = operation.response.statusCode;
    // NSString *urlString = operation.response.URL.absoluteString;
}

- (void)failureLogWithOperation:(AFHTTPRequestOperation *)operation responseObject:(NSError *)error
{
    NSInteger stateCode = operation.response.statusCode;
    NSString *urlString = [[error userInfo] valueForKey:@"NSErrorFailingURLKey"];
    if (!urlString) {
        urlString = operation.response.URL.absoluteString;
    }
    // NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
    
    
    if (stateCode == 0) {
        if (self.reachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            /*网络错误*/
        } else {
            
        }
    }
}

- (void)requestPath:(NSString *)path method:(NSString *)method parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [super requestPath:path method:method parameters:[parameters configParameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successLogWithOperation:operation responseObject:responseObject];
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failureLogWithOperation:operation responseObject:error];
        
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (void)cancelAllHTTPOperations
{
    [[HttpClient sharedClient].operationQueue cancelAllOperations];
}

@end