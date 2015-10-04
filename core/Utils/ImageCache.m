//
//  ImageCache.m
//  pomelo
//
//  Created by 谢家欣 on 15/10/4.
//  Copyright © 2015年 guoku. All rights reserved.
//

#import "ImageCache.h"
#import "NSString+App.h"

@implementation ImageCache

+ (BOOL)saveImageWhthData:(NSData *)data URL:(NSURL *)url
{
    //    NSError * err = nil;
    NSString * imagefile = [url.absoluteString md5];
    
    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.guoku.iphone"];
    //    NSLog(@"url %@", containerURL);
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", imagefile]];
    BOOL result = [data writeToURL:containerURL atomically:YES];
    return result;
}

+ (NSData *)readImageWithURL:(NSURL *)url
{
    NSString * imagefile = [url.absoluteString md5];
    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.guoku.iphone"];
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", imagefile]];
    
    return [NSData dataWithContentsOfURL:containerURL];
    //    return data;
}


@end
