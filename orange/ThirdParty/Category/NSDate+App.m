//
//  NSDate+App.m
//  Blueberry
//
//  Created by 魏哲 on 13-10-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "NSDate+App.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (App)

+ (NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)format
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringWithDefaultFormat
{
    NSTimeInterval minutes = - [self timeIntervalSinceNow] / 60;
    
    if (minutes < 1) {
        return [NSString stringWithFormat:@"%.0f%@", - [self timeIntervalSinceNow], NSLocalizedStringFromTable(@"seconds", kLocalizedFile, nil)];
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%.0f%@", minutes, NSLocalizedStringFromTable(@"minutes", kLocalizedFile, nil)];
    } else if (minutes < 60 * 24) {
        return [NSString stringWithFormat:@"%.0f%@", minutes / 60, NSLocalizedStringFromTable(@"hours", kLocalizedFile, nil)];
    } else if (minutes < 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%.0f%@", minutes / 60 / 24, NSLocalizedStringFromTable(@"days", kLocalizedFile, nil)];
    } else {
        return [NSString stringWithFormat:@"%.0f%@", minutes / 60 / 24 / 7, NSLocalizedStringFromTable(@"weeks", kLocalizedFile, nil)];
        /*
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
        }
        return [dateFormatter stringFromDate:self];
         */
    }
}

@end
