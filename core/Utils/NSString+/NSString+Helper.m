//
//  NSString+Helper.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (NSString *)trimedWithLowercase
{
    NSString * ret = [[self lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return ret;
}

- (NSString *)trimed
{
    NSString * ret = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return ret;
}

- (NSString *)imageURLWithSize:(NSInteger)size
{
    NSString    *uri_string;
    if ([self hasPrefix:@"https://imgcdn.guoku.com/"]) {
        uri_string = [self stringByReplacingOccurrencesOfString:@"https://imgcdn.guoku.com/" withString:@""];
    } else {
        uri_string = [self stringByReplacingOccurrencesOfString:@"http://imgcdn.guoku.com/" withString:@""];
    }
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[uri_string componentsSeparatedByString:@"/"]];
    
    [array insertObject:[NSNumber numberWithInteger:size] atIndex:1];
    NSString * image_uri_string = [[array valueForKey:@"description"] componentsJoinedByString:@"/"];
    
    return [NSString stringWithFormat:@"http://imgcdn.guoku.com/%@", image_uri_string];
}

- (CGFloat)heightWithLineWidth:(CGFloat)width Font:(UIFont *)font LineHeight:(CGFloat)lineHeight
{
    
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineHeight];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    //    size.height = ceilf(size.height);
    //    size.width  = ceilf(size.width);
    //    return fmaxf(60.f, size.height + 25.);
    return size.height;
}

- (CGFloat)widthWithLineWidth:(CGFloat)width Font:(UIFont *)font
{
    //    CGFloat width = 286.;
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    return size.width;
}

- (NSString *)encodedUrl
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
