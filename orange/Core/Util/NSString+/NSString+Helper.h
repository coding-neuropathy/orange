//
//  NSString+Helper.h
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

- (NSString *)Trimed;
- (NSString *)imageURLWithSize:(NSInteger)size;

- (CGFloat)heightWithLineWidth:(CGFloat)width Font:(UIFont *)font;
- (CGFloat)widthWithLineWidth:(CGFloat)width Font:(UIFont *)font;

- (BOOL)validateEmail;

@end
