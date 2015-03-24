//
//  NSString+Helper.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (NSString *)Trimed
{
    NSString * ret = [[self lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return ret;
}

- (NSString *)imageURLWithSize:(NSInteger)size
{
    NSString * uri_string = [self stringByReplacingOccurrencesOfString:@"http://imgcdn.guoku.com/" withString:@""];
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[uri_string componentsSeparatedByString:@"/"]];
    
    [array insertObject:[NSNumber numberWithInteger:size] atIndex:1];
    //        NSLog(@"%@", array);
    NSString * image_uri_string = [[array valueForKey:@"description"] componentsJoinedByString:@"/"];
//    NSLog(@"%@", image_uri_string);
    
    return [NSString stringWithFormat:@"http://imgcdn.guoku.com/%@", image_uri_string];
}

- (CGFloat)heightWithLineWidth:(CGFloat)width Font:(UIFont *)font
{
    
    //    CGFloat width = 286;
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
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

- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
