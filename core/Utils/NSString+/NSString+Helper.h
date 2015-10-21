//
//  NSString+Helper.h
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Helper)

- (NSString *)trimed;
- (NSString *)trimedWithLowercase;

- (NSString *)imageURLWithSize:(NSInteger)size;

- (CGFloat)heightWithLineWidth:(CGFloat)width Font:(UIFont *)font LineHeight:(CGFloat)lineHeight
;
- (CGFloat)widthWithLineWidth:(CGFloat)width Font:(UIFont *)font;

- (NSString *)encodedUrl;
- (BOOL)validateEmail;

@end
