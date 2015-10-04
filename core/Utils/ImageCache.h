//
//  ImageCache.h
//  pomelo
//
//  Created by 谢家欣 on 15/10/4.
//  Copyright © 2015年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+ (BOOL)saveImageWhthData:(NSData *)data URL:(NSURL *)url;
+ (NSData *)readImageWithURL:(NSURL *)url;

@end
