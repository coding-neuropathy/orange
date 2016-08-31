//
//  ShareView.m
//  orange
//
//  Created by huiter on 15/7/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ShareView.h"
//#import "LoginView.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface ShareView () <UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) UIView * mask;
@property(nonatomic, strong) UIView * board;
@property(nonatomic, strong) UIButton * cancel;

@property(nonatomic, strong) UIImage * image;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * subTitle;
@property(nonatomic, strong) NSString * url;
@property(nonatomic, strong) MFMailComposeViewController *composer;


@end

@implementation ShareView


- (instancetype)initWithTitle:(NSString *)title SubTitle:(NSString *)subTitle Image:(UIImage *)image URL:(NSString *)url
{
    self = [self init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.title = title;
        self.subTitle = subTitle;
        self.image = image;
        self.url = url;
    }
    return self;
}

- (UIView *)mask
{
    if(!_mask) {
        _mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
        _mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return _mask;
}


- (UIView *)board
{
    if(!_board) {
        _board = [[UIView alloc]initWithFrame:IS_IPHONE ? CGRectMake(0, kScreenHeight - 358, kScreenWidth, 358) : CGRectMake(0, kScreenHeight - 458, kScreenWidth, 458)];
        _board.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return _board;
}

- (UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,52)];
        _cancel.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [_cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.board];

    
    {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, 29 , kScreenWidth - 30, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [self.board addSubview:line];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        title.text = @"分享";
        title.textColor = UIColorFromRGB(0x9d9e9f);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = UIColorFromRGB(0xf4f4f4);
        title.center = line.center;
        [self.board addSubview:title];
    }
    
    {
    
         NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_moment.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForMoment) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width/2, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"微信朋友圈";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_wechat.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForWechat) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width*3/2+12, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"微信好友";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_weibo.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForWeibo) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width*5/2+12*2, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"新浪微博";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_safari.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForSafari) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width*7/2+12*3, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"在 Safari 中打开";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_mail.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForMail) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width*9/2+12*4, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"Mail";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
//        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15,  178, kScreenWidth - 30, 0.5)];
//        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
//        [self.board addSubview:line];
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_refresh.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForRefresh) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width/2, width/2+202);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"刷新";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_copy.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForCopy) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width*3/2+12, width/2+202);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"复制链接";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    if(![self.type isEqualToString:@"url"]){
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_report.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForReport) forControlEvents:UIControlEventTouchUpInside];
        [self.board addSubview:icon];
        
        icon.center = CGPointMake(15+ width*5/2+12*2, width/2+202);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"举报";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self.board addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.board.deFrameHeight - 52.5, kScreenWidth, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [self.board addSubview:line];
    }
    
    self.cancel.deFrameBottom = self.board.deFrameHeight;
    [self.board addSubview:self.cancel];
    
    [self insertSubview:self.mask atIndex:0];
}

- (void)show
{
    [self setNeedsDisplay];
    self.alpha = 0;
    self.board.deFrameTop = kScreenHeight;
    [kAppDelegate.window.rootViewController.view addSubview:self];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
        self.board.deFrameBottom = kScreenHeight;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismiss
{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        self.board.deFrameTop = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)wxShare:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    UIImage *image = [self.image  imageWithSize:CGSizeMake(220.f, 220.f)];
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
    webPage.webpageUrl = [self.url stringByAppendingString:@"?from=wechat"];
    message.mediaObject = webPage;
    if(scene == 1)
    {
        message.title = self.title;
        message.description = @"";
    }
    else
    {
        message.title = @"果库 - 精英消费指南";
        message.description = self.title;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =scene;
    
    if ([WXApi sendReq:req]) {
        if (scene == 1) {
//            [AVAnalytics event:@"share entity to moments" attributes:@{@"entity":self.title}];
            [MobClick event:@"share entity to moments" attributes:@{@"entity":self.title}];
        } else {
//            [AVAnalytics event:@"share entity to wechat" attributes:@{@"entity":self.title}];
            [MobClick event:@"share entity to wechat" attributes:@{@"entity":self.title}];
        }
    }
    else{
        [SVProgressHUD showImage:nil status:@"分享失败"];
    }
}

- (void)weiboShare
{
    WBMessageObject *message = [WBMessageObject message];
//    message.text = self.title;
    WBImageObject *image = [WBImageObject object];
    message.text = [NSString stringWithFormat:@"%@ %@?from=weibo", self.title, self.url];
    image.imageData = UIImageJPEGRepresentation(self.image, 1.0);
    message.imageObject = image;
    
    
    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kGK_WeiboRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];


}

#pragma mark - button action

-(void)ShareActionForMoment
{
    [self wxShare:1];
    [self dismiss];
}

-(void)ShareActionForWechat
{
    [self wxShare:0];
    [self dismiss];
}

-(void)ShareActionForWeibo
{
    [self weiboShare];
    [self dismiss];
}

-(void)ShareActionForSafari
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.url]];
    [self dismiss];
}

-(void)ShareActionForMail
{

    if ([MFMailComposeViewController canSendMail]) {
        self.composer = [[MFMailComposeViewController alloc] init];
        self.composer.mailComposeDelegate = self;
        [self.composer setSubject:@"果库 - 精英消费指南"];
        [self.composer setMessageBody:[self.title stringByAppendingString:[NSString stringWithFormat:@"<br><a href='%@' target='_blank'>购买链接</a>",self.url]] isHTML:YES];
        /*
        if (self.image) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            UIImage *ui = self.image;
            pasteboard.image = ui;
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(ui)];
            [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@" "];
        }
         */
        


        if (self.composer) {
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
            [kAppDelegate.activeVC presentViewController:self.composer animated:YES completion:^{
            }];
        }
    }else
    {
        [SVProgressHUD showImage:nil status:@"当前设备没有设置邮箱"];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:

            break;
        case MFMailComposeResultSent:
            [SVProgressHUD showImage:nil status:@"发送成功"];
            break;
        case MFMailComposeResultFailed:
            [SVProgressHUD showImage:nil status:@"发送失败"];
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [kAppDelegate.activeVC dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)ShareActionForRefresh
{
    [self dismiss];
    if (self.tapRefreshButtonBlock) {
        self.tapRefreshButtonBlock();
    }
}

-(void)ShareActionForCopy
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.url;
    [SVProgressHUD showImage:nil status:@"已复制"];
    [self dismiss];
    
}

-(void)ShareActionForReport
{
    if(!k_isLogin)
    {
//        LoginView * view = [[LoginView alloc]init];
//        [view show];
        [[OpenCenter sharedOpenCenter] openAuthPage];
//        return;
    } else {
        ReportViewController * VC = [[ReportViewController alloc] init];
        VC.entity = self.entity;
        [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
        [self dismiss];
    }
}


-(UIImage *)shareImage
{
    
    UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weibo_share_bg.jpg"]];
    
    UIImageView * entityImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 564, 564)];
    entityImage.contentMode = UIViewContentModeScaleAspectFit;
    entityImage.image = self.image;
    entityImage.deFrameTop = 38;
    entityImage.deFrameLeft = 38;
    [view addSubview:entityImage];
    
    
    UILabel * brand = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.deFrameWidth, 20)];
    brand.text = self.entity.brand;
    brand.textAlignment = NSTextAlignmentCenter;
    brand.font = [UIFont boldSystemFontOfSize:28];
    brand.textColor = UIColorFromRGB(0x414243);
    brand.deFrameTop = entityImage.deFrameBottom + 32;
    [view addSubview:brand];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.deFrameWidth, 28)];
    title.text = self.entity.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:28];
    title.textColor = UIColorFromRGB(0x414243);
    title.deFrameTop = brand.deFrameBottom + 9;
    [view addSubview:title];
    
    UILabel * price = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.deFrameWidth, 28)];
    price.text = [NSString stringWithFormat:@"￥%0.2f",self.entity.lowestPrice];
    price.textAlignment = NSTextAlignmentCenter;
    price.font = [UIFont systemFontOfSize:28];
    price.textColor = UIColorFromRGB(0x414243);
    price.deFrameTop = title.deFrameBottom + 9;
    [view addSubview:price];

    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, view.bounds)];
    
    return resultImg;
}


@end
