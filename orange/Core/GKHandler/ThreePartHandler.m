//
//  ThreePartHandler.m
//  orange
//
//  Created by 谢家欣 on 16/9/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ThreePartHandler.h"

@implementation ThreePartHandler

DEFINE_SINGLETON_FOR_CLASS(ThreePartHandler);

#pragma mark - weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    if ([response isKindOfClass:WBAuthorizeResponse.class] && !response.statusCode)
    {
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"wbtoken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WBAuthResp" object:response.userInfo];
    } else {
        DDLogError(@"weibo auth error %@", [response userInfo]);
    }
    
}

#pragma mark - wechat delegate
- (void)onResp:(BaseResp *)resp
{
    //    DDLogInfo(@"resp %@", resp);
    //    NSInteger wechatType = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:kWechatType] integerValue];
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //        DDLogError(@"error code %d", resp.errCode);
        switch (resp.errCode) {
                case 0:
            {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //                    [SVProgressHUD showImage:nil status:@"分享成功"];
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"share-success", kLocalizedFile, nil)];
                });
            }
                break;
                case -2:
                
                break;
            default:
            {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //                    [SVProgressHUD showImage:nil status:@"分享失败"];
                    [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"share-failure", kLocalizedFile, nil)];
                });
            }
                break;
        }
    }
    
    if([resp isKindOfClass:[SendAuthResp class]]) {
        //        DDLogInfo(@"resp %@", [(SendAuthResp *)resp code]);
        switch (resp.errCode) {
                case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WechatAuthResp" object:resp];
                break;
                
            default:
                break;
        }
        
    }
    
}

@end
