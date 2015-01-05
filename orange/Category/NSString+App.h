//
//  NSString+App.h
//  Blueberry
//
//  Created by 回特 on 13-10-12.
//  Copyright (c) 2013年 huiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (App)

- (NSString *)md5;

- (NSString *)encodedUrl;

- (BOOL)isValidEmail;

- (NSUInteger)unsignedIntValue;

-(NSComparisonResult)compareNumberStrings:(NSString *)str;
@end
