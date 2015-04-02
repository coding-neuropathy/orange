//
//  NSDictionary+Sign.m
//  orange
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "NSDictionary+Sign.h"
#import <CommonCrypto/CommonDigest.h>

#define kApiKey @"0b19c2b93687347e95c6b6f5cc91bb87"
#define kApiSecret @"47b41864d64bd46"

@implementation NSDictionary (Sign)

- (NSString *)md5WithString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
/**
 *  签名算法
 *
 *  @param paramters 参数字典
 *
 *  @return 签名
 */
- (NSString *)signWithParamters:(NSDictionary *)paramters
{
    NSMutableString *signString = [NSMutableString string];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:paramters.allKeys];
    [keys sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * string = [NSString stringWithFormat:@"%@=%@", obj, paramters[obj]];
        [signString appendString:string];
    }];
    
    [signString appendString:kApiSecret];
    NSString *sign = [[self md5WithString:signString] lowercaseString];
    
    return sign;
}

- (NSDictionary *)configParameters
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self];
    [newDict setObject:kApiKey forKey:@"api_key"];
    
//    NSString *session = [Passport sharedInstance].session;
//    if (session) {
//        [newDict setObject:session forKey:@"session"];
//    }
    [newDict setObject:[self signWithParamters:newDict] forKey:@"sign"];
    return (NSDictionary *)newDict;
}

@end
