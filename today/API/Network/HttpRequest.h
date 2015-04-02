//
//  HttpRequest.h
//  orange
//
//  Created by 谢家欣 on 15/4/1.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+ (void)getDataWithParamters:(NSDictionary *)paramters URL:(NSString *)url
                       Block:(void (^)(id res, NSError * error))block;

@end
