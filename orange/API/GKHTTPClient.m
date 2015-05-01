//
//  GKHTTPClient.m
//  Blueberry
//
//  Created by 魏哲 on 13-11-29.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "GKHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Passport.h"

@implementation GKHTTPClient

+ (GKHTTPClient *)sharedClient
{
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    static GKHTTPClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[GKHTTPClient alloc] initWithBaseURL:baseURL];
    });
    sharedClient.baseURL = baseURL;
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    NSParameterAssert(url);
    
    self = [super initWithBaseURL:url];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        __weak __typeof(&*self)weakSelf = self;
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                {
                    /*网络已断开*/
                    break;
                }
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    break;
                }
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    break;
                }
                    
                case AFNetworkReachabilityStatusUnknown:
                {
                    break;
                }
            }
        }];
    }
    return self;
}

/**
 *  配置参数
 *
 *  @param parameters 基本参数字典
 *
 *  @return 添加了用户认证等信息后的参数字典
 */
+ (NSDictionary *)configParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newDict setObject:kApiKey forKey:@"api_key"];

    NSString *session = [Passport sharedInstance].session;
    if (session) {
        [newDict setObject:session forKey:@"session"];
    }
    [newDict setObject:[GKHTTPClient signWithParamters:newDict] forKey:@"sign"];
    return newDict;
}

/**
 *  签名算法
 *
 *  @param paramters 参数字典
 *
 *  @return 签名
 */
+ (NSString *)signWithParamters:(NSDictionary *)paramters
{
    NSMutableString *signString = [NSMutableString string];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:paramters.allKeys];
    [keys sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * string = [NSString stringWithFormat:@"%@=%@", obj, paramters[obj]];
        [signString appendString:string];
    }];
    
    [signString appendString:kApiSecret];
    NSString *sign = [[signString md5] lowercaseString];
    
    return sign;
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
    [super requestPath:path method:method parameters:[GKHTTPClient configParameters:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successLogWithOperation:operation responseObject:responseObject];
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failureLogWithOperation:operation responseObject:error];
        DDLogInfo(@"%@", [[error userInfo] valueForKey:@"NSErrorFailingURLKey"]);
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (void)requestPath:(NSString *)path method:(NSString *)method parameters:(NSDictionary *)parameters dataParameters:(NSDictionary *)dataParameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [super requestPath:path method:method parameters:[GKHTTPClient configParameters:parameters] dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [[GKHTTPClient sharedClient].operationQueue cancelAllOperations];
}

@end
