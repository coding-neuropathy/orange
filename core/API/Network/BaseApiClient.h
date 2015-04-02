//
//  BaseApiClient.h
//  orange
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BaseApiClient : AFHTTPSessionManager

+ (instancetype)sharedClinet;

@end
