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

#pragma mark - share to wechat
- (void)wxShare:(int)scene ShareImage:(UIImage *)shareImage Title:(NSString *)title URL:(NSString *)urlStriing
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    UIImage *image = [shareImage imageWithSize:CGSizeMake(220.f, 220.f)];
    NSData *oldData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat size = oldData.length / 1024;
    if (size > 25.0f) {
        CGFloat f = 25.0f / size;
        NSData *datas = UIImageJPEGRepresentation(image, f);
        //            float s = datas.length / 1024;
        //            GKLog(@"s---%f",s);
        UIImage *smallImage = [UIImage imageWithData:datas];
        [message setThumbImage:smallImage];
    }
    else{
        [message setThumbImage:image];
    }
    
    WXWebpageObject *webPage = [WXWebpageObject object];
    webPage.webpageUrl = [urlStriing stringByAppendingString:@"?from=wechat"];
    message.mediaObject = webPage;
    if(scene == 1)
    {
        message.title = title;
        message.description = @"";
    }
    else
    {
        message.title = @"果库 - 精英消费指南";
        message.description = title;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =scene;
    
    if ([WXApi sendReq:req]) {
        if (scene == 1) {
            [MobClick event:@"share entity to moments" attributes:@{@"entity":title}];
        } else {
            [MobClick event:@"share entity to wechat" attributes:@{@"entity":title}];
        }
    }
    else{
        [SVProgressHUD showImage:nil status:@"分享失败"];
    }
}

#pragma mark - share to weibo
- (void)weiboShareWithTitle:(NSString *)title ShareImage:(UIImage *)shareImage URLString:(NSString *)urlString
{
    WBMessageObject *message = [WBMessageObject message];
    //    message.text = self.title;
    WBImageObject *image = [WBImageObject object];
    message.text = [NSString stringWithFormat:@"%@ %@?from=weibo", title, urlString];
    image.imageData = UIImageJPEGRepresentation(shareImage, 1.0);
    message.imageObject = image;
    
    
    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kGK_WeiboRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",};
    [WeiboSDK sendRequest:request];
}


@end
