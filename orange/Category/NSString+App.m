//
//  NSString+App.m
//  Blueberry
//
//  Created by 回特 on 13-10-12.
//  Copyright (c) 2013年 huiter. All rights reserved.
//

#import "NSString+App.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (App)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

- (NSString *)encodedUrl
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

- (BOOL)isValidEmail
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\w\\+\\-_.]+@[\\w_-]+(\\.[\\w_-]+)+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    return [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (NSUInteger)unsignedIntValue
{
    return [self integerValue];
}

-(NSComparisonResult)compareNumberStrings:(NSString *)str {
    NSNumber * me = [NSNumber numberWithFloat:[self floatValue]];
    NSNumber * you = [NSNumber numberWithFloat:[str floatValue]];
    
    return [you compare:me];
}

@end
