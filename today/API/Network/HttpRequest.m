//
//  HttpRequest.m
//  orange
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HttpRequest.h"
#import "BaseApiClient.h"
#import "NSDictionary+Sign.h"

@implementation HttpRequest

+ (void)getDataWithParamters:(NSDictionary *)paramters URL:(NSString *)url
                       Block:(void (^)(id res, NSError * error))block
{
    
    //    DDLogInfo(@"info %@", [paramters sign] );
    [[BaseApiClient sharedClinet] GET:url parameters:[paramters configParameters] success:^(NSURLSessionDataTask *task, id JSON) {
        NSLog(@"get res %@", JSON);
        
        if (block) {
            block((NSArray *)JSON, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
//            DDLogError(@"get error %@", error);
            block(nil, error);
        }
    }];
}


@end
