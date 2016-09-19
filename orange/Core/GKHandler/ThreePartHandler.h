//
//  ThreePartHandler.h
//  orange
//
//  Created by 谢家欣 on 16/9/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libWeChatSDK/WXApi.h>

@interface ThreePartHandler : NSObject <WeiboSDKDelegate, WXApiDelegate>

DEFINE_SINGLETON_FOR_HEADER(ThreePartHandler);


- (void)wxShare:(int)scene ShareImage:(UIImage *)shareImage Title:(NSString *)title URL:(NSString *)urlStriing;

#pragma mark - share to weibo
- (void)weiboShareWithTitle:(NSString *)title ShareImage:(UIImage *)shareImage URLString:(NSString *)urlString;

@end
