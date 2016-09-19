//
//  ShareView.m
//  orange
//
//  Created by huiter on 15/7/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ShareView.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface ShareView () <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>
//@property(nonatomic, strong) UIView * mask;
@property(nonatomic, strong) UIView * board;
@property (strong, nonatomic) UILabel   *titleLabel;
@property(nonatomic, strong) UIButton   *cancel;

@property(nonatomic, strong) UIImage * image;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * subTitle;
@property(nonatomic, strong) NSString * url;
@property(nonatomic, strong) MFMailComposeViewController *composer;


@end

@implementation ShareView



- (instancetype)initWithTitle:(NSString *)title SubTitle:(NSString *)subTitle Image:(UIImage *)image URL:(NSString *)url
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
//        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.title = title;
        self.subTitle = subTitle;
        self.image = image;
        self.url = url;
    }
    return self;
}

- (UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.deFrameSize = CGSizeMake(kScreenWidth, 52.);
        _cancel.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
        [_cancel setTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor colorFromHexString:@"#414243"] forState:UIControlStateNormal];
        
        [_cancel addTarget:self action:@selector(TapCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        _cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:_cancel];
    }
    return _cancel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.text            = NSLocalizedStringFromTable(@"share", kLocalizedFile, nil);
        
        CGFloat titleWidth          = [_titleLabel.text widthWithLineWidth:0. Font:_titleLabel.font];
        _titleLabel.deFrameSize     = CGSizeMake(titleWidth, 30.);
        _titleLabel.textColor       = [UIColor colorFromHexString:@"#9d9e9f"];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        //        title.center = line.center;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.center      = self.center;
    self.titleLabel.deFrameTop  = 15.;
    
    
    {
    
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_moment.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForMoment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width/2, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = NSLocalizedStringFromTable(@"wechat-moments", kLocalizedFile, nil);
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_wechat.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForWechat:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width*3/2+12, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = NSLocalizedStringFromTable(@"wechat", kLocalizedFile, nil);
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_weibo.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width*5/2+12*2, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = NSLocalizedStringFromTable(@"weibo", kLocalizedFile, nil);
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_safari.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForSafari:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width*7/2+12*3, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"在 Safari 中打开";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_mail.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForMail:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width*9/2+12*4, width/2+62);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = NSLocalizedStringFromTable(@"mail", kLocalizedFile, nil);
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = [UIColor colorFromHexString:@"#212121"];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
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
        [icon addTarget:self action:@selector(ShareActionForRefresh:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width/2, width/2+202);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"刷新";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_copy.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForCopy:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width*3/2+12, width/2+202);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, width, 30)];
        title.text = @"复制链接";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = [UIColor colorFromHexString:@"#212121"];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    if(![self.type isEqualToString:@"url"]){
        
        NSInteger width = (kScreenWidth -30 - 12*4)/5;
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [icon setImage:[UIImage imageNamed:@"share_report.png"] forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ShareActionForReport:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:icon];
        
        icon.center = CGPointMake(15+ width*5/2+12*2, width/2+202);
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
        title.text = @"举报";
        title.font = [UIFont systemFontOfSize:10];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x000000);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [title sizeToFit];
        [self addSubview:title];
        
        title.center = icon.center;
        title.deFrameTop = icon.deFrameBottom + 10;
    }
    
    {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.board.deFrameHeight - 52.5, kScreenWidth, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [self.board addSubview:line];
    }
    
    self.cancel.deFrameBottom = self.deFrameHeight;
//    [self.board addSubview:self.cancel];
    
//    [self insertSubview:self.mask atIndex:0];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#e6e6e6"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 15., 30.);
    CGContextAddLineToPoint(context, self.titleLabel.deFrameLeft - 10., 30.);
    
    CGContextMoveToPoint(context, self.titleLabel.deFrameRight + 10., 30.);
    CGContextAddLineToPoint(context, self.deFrameWidth - 15., 30.);
    
    CGContextStrokePath(context);
    
}

- (void)show
{
//    [self setNeedsDisplay];
//    self.alpha = 0;
//    self.board.deFrameTop = kScreenHeight;
//    [kAppDelegate.window.rootViewController.view addSubview:self];
//    
//    [UIView animateWithDuration:0.35 animations:^{
//        self.alpha = 1;
//        self.board.deFrameBottom = kScreenHeight;
//    } completion:^(BOOL finished) {
//        
//    }];
}
- (void)dismiss
{
//    
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.alpha = 0;
//        self.board.deFrameTop = kScreenHeight;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    
}

//- (void)wxShare:(int)scene
//{
//    WXMediaMessage *message = [WXMediaMessage message];
//    
//    UIImage *image = [self.image  imageWithSize:CGSizeMake(220.f, 220.f)];
//    NSData *oldData = UIImageJPEGRepresentation(image, 1.0);
//    CGFloat size = oldData.length / 1024;
//    if (size > 25.0f) {
//        CGFloat f = 25.0f / size;
//        NSData *datas = UIImageJPEGRepresentation(image, f);
//        //            float s = datas.length / 1024;
//        //            GKLog(@"s---%f",s);
//        UIImage *smallImage = [UIImage imageWithData:datas];
//        [message setThumbImage:smallImage];
//    }
//    else{
//        [message setThumbImage:image];
//    }
//    
//    WXWebpageObject *webPage = [WXWebpageObject object];
//    webPage.webpageUrl = [self.url stringByAppendingString:@"?from=wechat"];
//    message.mediaObject = webPage;
//    if(scene == 1)
//    {
//        message.title = self.title;
//        message.description = @"";
//    }
//    else
//    {
//        message.title = @"果库 - 精英消费指南";
//        message.description = self.title;
//    }
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene =scene;
//    
//    if ([WXApi sendReq:req]) {
//        if (scene == 1) {
////            [AVAnalytics event:@"share entity to moments" attributes:@{@"entity":self.title}];
//            [MobClick event:@"share entity to moments" attributes:@{@"entity":self.title}];
//        } else {
////            [AVAnalytics event:@"share entity to wechat" attributes:@{@"entity":self.title}];
//            [MobClick event:@"share entity to wechat" attributes:@{@"entity":self.title}];
//        }
//    }
//    else{
//        [SVProgressHUD showImage:nil status:@"分享失败"];
//    }
//}
//
//- (void)weiboShare
//{
//    WBMessageObject *message = [WBMessageObject message];
////    message.text = self.title;
//    WBImageObject *image = [WBImageObject object];
//    message.text = [NSString stringWithFormat:@"%@ %@?from=weibo", self.title, self.url];
//    image.imageData = UIImageJPEGRepresentation(self.image, 1.0);
//    message.imageObject = image;
//    
//    
//    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
//    
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = kGK_WeiboRedirectURL;
//    authRequest.scope = @"all";
//    
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",};
//    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
//    [WeiboSDK sendRequest:request];
//}

#pragma mark - button action

-(void)ShareActionForMoment:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleShareOnMomentsAction:)]) {
        [_delegate handleShareOnMomentsAction:sender];
    }
}

-(void)ShareActionForWechat:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleShareToWeChat:)]) {
        [_delegate handleShareToWeChat:sender];
    }
}

-(void)ShareActionForWeibo:(id)sender
{
//    [self weiboShare];
//    [self dismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(handleShareToWeibo:)]) {
        [_delegate handleShareToWeibo:sender];
    }
}

-(void)ShareActionForSafari:(id)sender
{
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.url]];
//    [self dismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(handleOpenInSafari:)]) {
        [_delegate handleOpenInSafari:sender];
    }
}

-(void)ShareActionForMail:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleSendMail:)]) {
        [_delegate handleSendMail:sender];
    }

}


-(void)ShareActionForRefresh:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlePageRefreshRequest:)])
    {
        [_delegate handlePageRefreshRequest:sender];
    }
}

-(void)ShareActionForCopy:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlerCopyURL:)]) {
        [_delegate handlerCopyURL:sender];
    }
}

-(void)ShareActionForReport:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlerTipOff:)]) {
        [_delegate handlerTipOff:sender];
    }
}

#pragma mark - button action
- (void)TapCancelBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleCancelBtnAction:)]) {
        [_delegate handleCancelBtnAction:sender];
    }
}


@end
