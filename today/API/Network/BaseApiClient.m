//
//  BaseApiClient.m
//  orange
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "BaseApiClient.h"

//#define kBaseURL @"http://api.guoku.com/mobile/v4/"
#define kBaseURL @"http://h.guoku.com/mobile/v4/"

@implementation BaseApiClient

+ (instancetype)sharedClinet
{
    static BaseApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseApiClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sharedClient setSecurityPolicy:securityPolicy];
    });
    
    return _sharedClient;
}

@end
