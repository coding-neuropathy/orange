//
//  SignInView.m
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SignInView.h"
#import <libWeChatSDK/WXApi.h>

@interface SignInView () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel       * emailLabel;
@property (strong, nonatomic) UITextField   * emailTextField;
@property (strong, nonatomic) UILabel       * passwordLabel;
@property (strong, nonatomic) UITextField   * passwordTextField;

@property (strong, nonatomic) UIButton      * signBtn;
@property (strong, nonatomic) UIButton      * forgetBtn;

@property (strong, nonatomic) UILabel       * infoLabel;

@property (strong, nonatomic) UIButton      * sinaWeiboBtn;
@property (strong, nonatomic) UIButton      * taobaoBtn;
@property (strong, nonatomic) UIButton      * weixinBtn;

@end

@implementation SignInView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)emailLabel
{
    if (!_emailLabel) {
        _emailLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _emailLabel.font            = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _emailLabel.text            = NSLocalizedStringFromTable(@"email", kLocalizedFile, nil);
        _emailLabel.textColor       = UIColorFromRGB(0x212121);
        _emailLabel.textAlignment   = NSTextAlignmentLeft;
        
//        CGFloat width               = [_emailLabel.text widthWithLineWidth:0. Font:_emailLabel.font];
        _emailLabel.frame           = CGRectMake(0., 0., 60., 20.);
    }
    return _emailLabel;
}

- (UITextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField                             = [[UITextField alloc] initWithFrame:CGRectZero];
        _emailTextField.textColor                   = UIColorFromRGB(0x212121);
        _emailTextField.font                        = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _emailTextField.adjustsFontSizeToFitWidth   = YES;
//        _emailTextField.leftView                    = self.emailLabel;
//        _emailTextField.leftViewMode                = UITextFieldViewModeAlways;
        _emailTextField.autocorrectionType          = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType      = UITextAutocapitalizationTypeNone;
//        _emailTextField.placeholder                 = @"example@guoku.com";
        _emailTextField.placeholder                 = NSLocalizedStringFromTable(@"what's-your-email", kLocalizedFile, nil);
        _emailTextField.clearButtonMode             = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType               = UIReturnKeyNext;
        _emailTextField.keyboardType                = UIKeyboardTypeEmailAddress;
        _emailTextField.textAlignment               = NSTextAlignmentLeft;
        _emailTextField.backgroundColor             = [UIColor clearColor];
        _emailTextField.delegate                    = self;
        
        [self addSubview:_emailTextField];
    }
    return _emailTextField;
}

- (UILabel *)passwordLabel
{
    if (!_passwordLabel) {
        _passwordLabel                              = [[UILabel alloc] initWithFrame:CGRectZero];
        _passwordLabel.font                         = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _passwordLabel.text                         = NSLocalizedStringFromTable(@"password", kLocalizedFile, nil);
        _passwordLabel.textColor                    = UIColorFromRGB(0x212121);
        _passwordLabel.textAlignment                = NSTextAlignmentLeft;
        _passwordLabel.adjustsFontSizeToFitWidth    = YES;
//        CGFloat width                   = [_passwordLabel.text widthWithLineWidth:0. Font:_passwordLabel.font];
        _passwordLabel.frame                        = CGRectMake(0., 0., 60., 20.);
    }
    return _passwordLabel;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField                          = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.textColor                = UIColorFromRGB(0x212121);
        _passwordTextField.font                     = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
//        _passwordTextField.leftView                 = self.passwordLabel;
//        _passwordTextField.leftViewMode             = UITextFieldViewModeAlways;
        _passwordTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
        _passwordTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;
        _passwordTextField.secureTextEntry          = YES;
        _passwordTextField.placeholder              = NSLocalizedStringFromTable(@"what's-your-passowrd", kLocalizedFile, nil);
        
        _passwordTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
        _passwordTextField.keyboardType             = UIKeyboardTypeAlphabet;
        _passwordTextField.returnKeyType            = UIReturnKeyGo;
        _passwordTextField.textAlignment            = NSTextAlignmentLeft;
        
        _passwordTextField.delegate                 = self;
        
        [self addSubview:_passwordTextField];
    }
    return _passwordTextField;
}

- (UIButton *)signBtn
{
    if (!_signBtn) {
        _signBtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
        _signBtn.layer.borderColor          = UIColorFromRGB(0x6192ff).CGColor;
        _signBtn.layer.borderWidth          = 0.5;
        _signBtn.layer.masksToBounds        = YES;
        _signBtn.titleLabel.textAlignment   = NSTextAlignmentCenter;
        _signBtn.titleLabel.font            = [UIFont fontWithName:@"PingFangSC-Medium" size:18.];
        
        [_signBtn setTitle:NSLocalizedStringFromTable(@"sign in", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        
        [_signBtn addTarget:self action:@selector(signBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_signBtn];
    }
    return _signBtn;
}

- (UIButton *)forgetBtn
{
    if (!_forgetBtn) {
        _forgetBtn                          = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.titleLabel.font          = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_forgetBtn setTitle:NSLocalizedStringFromTable(@"forget-password", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:UIColorFromRGB(0x5976c1) forState:UIControlStateNormal];
        
        [_forgetBtn addTarget:self action:@selector(forgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_forgetBtn];
    }
    return _forgetBtn;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel                          = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.deFrameSize              = CGSizeMake(24. * kScreeenScale, 24. * kScreeenScale);
        _infoLabel.font                     = [UIFont fontWithName:@"HelveticaNeue" size:12.];
        _infoLabel.textColor                = UIColorFromRGB(0xbdbdbd);
        _infoLabel.textAlignment            = NSTextAlignmentCenter;
        _infoLabel.text                     = @"or";
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}


- (UIButton *)sinaWeiboBtn
{
    if (!_sinaWeiboBtn) {
        _sinaWeiboBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        _sinaWeiboBtn.deFrameSize           = IS_IPAD   ? CGSizeMake(40., 40.)
                                                        : CGSizeMake(40. * kScreeenScale, 40. * kScreeenScale);
        _sinaWeiboBtn.layer.cornerRadius    = _sinaWeiboBtn.deFrameHeight / 2.;
        _sinaWeiboBtn.backgroundColor       = UIColorFromRGB(0xf8f8f8);
        
        [_sinaWeiboBtn setImage:[UIImage imageNamed:@"login_icon_weibo.png"] forState:UIControlStateNormal];
        [_sinaWeiboBtn addTarget:self action:@selector(weiboBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_sinaWeiboBtn];
    }
    return _sinaWeiboBtn;
}

- (UIButton *)taobaoBtn
{
    if (!_taobaoBtn) {
        _taobaoBtn                          = [UIButton buttonWithType:UIButtonTypeCustom];
        _taobaoBtn.deFrameSize              = IS_IPAD   ? CGSizeMake(40., 40.)
                                                        : CGSizeMake(40. * kScreeenScale, 40. * kScreeenScale);
        _taobaoBtn.layer.cornerRadius       = _taobaoBtn.deFrameHeight / 2.;
        _taobaoBtn.backgroundColor          = UIColorFromRGB(0xf8f8f8);
        
        [_taobaoBtn setImage:[UIImage imageNamed:@"login_icon_taobao.png"] forState:UIControlStateNormal];
        [_taobaoBtn addTarget:self action:@selector(taobaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_taobaoBtn];
    }
    return _taobaoBtn;
}

- (UIButton *)weixinBtn
{
    if (!_weixinBtn) {
        _weixinBtn                          = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinBtn.deFrameSize              = IS_IPAD   ? CGSizeMake(40., 40.)
                                                        : CGSizeMake(40. * kScreeenScale, 40. * kScreeenScale);
        _weixinBtn.layer.cornerRadius       = _weixinBtn.deFrameHeight / 2.;
        _weixinBtn.layer.masksToBounds      = YES;
        _weixinBtn.backgroundColor          = UIColorFromRGB(0xf8f8f8);
        
        [_weixinBtn setImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateNormal];
        [_weixinBtn addTarget:self action:@selector(wechatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_weixinBtn];
    }
    return _weixinBtn;
}

- (void)configSNS
{
    if ([WXApi isWXAppInstalled]) {
        
        self.taobaoBtn.center               = self.signBtn.center;
        self.taobaoBtn.deFrameTop           = self.forgetBtn.deFrameBottom + 120.;
        
        self.sinaWeiboBtn.center            = self.taobaoBtn.center;
        self.sinaWeiboBtn.deFrameRight      = self.taobaoBtn.deFrameLeft - 12.;
        
        self.weixinBtn.center               = self.taobaoBtn.center;
        self.weixinBtn.deFrameLeft          = self.taobaoBtn.deFrameRight + 12.;
        
    } else {
    
        self.taobaoBtn.center               = self.forgetBtn.center;
        self.taobaoBtn.deFrameTop           = self.forgetBtn.deFrameBottom + 120.;
        
        self.sinaWeiboBtn.center            = self.taobaoBtn.center;
        self.sinaWeiboBtn.deFrameLeft       = ( self.deFrameWidth - (self.weixinBtn.deFrameWidth * 2 + 10) )/ 2.;
        
        self.taobaoBtn.deFrameLeft          = self.sinaWeiboBtn.deFrameRight + 10.;
        
        self.weixinBtn.hidden               = YES;
//        self.sinaWeiboBtn.deFrameRight      = self.taobaoBtn.deFrameLeft - 10.;
    }
}


#pragma mark - layout subviews

- (void)layoutiPhonetSubviews
{
    self.emailTextField.frame           = CGRectMake(0., 0., 290 * kScreeenScale, 46. * kScreeenScale);
    self.emailTextField.deFrameTop      = 33.;
    self.emailTextField.deFrameLeft     = ( kScreenWidth - self.emailTextField.deFrameWidth ) / 2.;
    
    self.passwordTextField.frame        = self.emailTextField.frame;
    self.passwordTextField.center       = self.emailTextField.center;
    self.passwordTextField.deFrameTop   = self.emailTextField.deFrameBottom + 1.;
    
    self.signBtn.frame                  = CGRectMake(0., 0., 290 * kScreeenScale, 44. * kScreeenScale);
    self.signBtn.center                 = self.passwordTextField.center;
    self.signBtn.layer.cornerRadius     = self.signBtn.deFrameHeight / 2.;
    self.signBtn.deFrameTop             = self.passwordTextField.deFrameBottom + 16.;
    
    self.forgetBtn.frame                = CGRectMake(0., 0., 144. * kScreeenScale, 20. * kScreeenScale);
    self.forgetBtn.center               = self.signBtn.center;
    self.forgetBtn.deFrameTop           = self.signBtn.deFrameBottom + 24.;
    
    self.infoLabel.center               = self.forgetBtn.center;
    self.infoLabel.deFrameTop           = self.forgetBtn.deFrameBottom + 75.;
    
    [self configSNS];
}

- (void)layoutiPadtSubviews
{
    self.emailTextField.frame           = CGRectMake(0., 0., 290, 46.);
    self.emailTextField.deFrameTop      = 33.;
    self.emailTextField.deFrameLeft     = ( self.deFrameWidth - self.emailTextField.deFrameWidth ) / 2.;
    
    self.passwordTextField.frame        = self.emailTextField.frame;
    self.passwordTextField.center       = self.emailTextField.center;
    self.passwordTextField.deFrameTop   = self.emailTextField.deFrameBottom + 1.;
    
    self.signBtn.frame                  = CGRectMake(0., 0., 290, 44.);
    self.signBtn.center                 = self.passwordTextField.center;
    self.signBtn.layer.cornerRadius     = self.signBtn.deFrameHeight / 2.;
    self.signBtn.deFrameTop             = self.passwordTextField.deFrameBottom + 16.;
    
    self.forgetBtn.frame                = CGRectMake(0., 0., 144., 20.);
    self.forgetBtn.center               = self.signBtn.center;
    self.forgetBtn.deFrameTop           = self.signBtn.deFrameBottom + 24.;
    
    self.infoLabel.center               = self.forgetBtn.center;
    self.infoLabel.deFrameTop           = self.forgetBtn.deFrameBottom + 75.;
    
    [self configSNS];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPHONE)
        [self layoutiPhonetSubviews];
    else
        [self layoutiPadtSubviews];
}


- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, self.emailTextField.deFrameLeft, self.emailTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.emailTextField.deFrameRight, self.emailTextField.deFrameBottom);
    
    CGContextMoveToPoint(context, self.passwordTextField.deFrameLeft, self.passwordTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.passwordTextField.deFrameRight, self.passwordTextField.deFrameBottom);
    
    CGFloat linePosition = self.infoLabel.deFrameTop + self.infoLabel.deFrameHeight / 2.;
    CGContextMoveToPoint(context, self.emailTextField.deFrameLeft, linePosition);
    CGContextAddLineToPoint(context, self.infoLabel.deFrameLeft, linePosition);
    
    CGContextMoveToPoint(context, self.infoLabel.deFrameRight, linePosition);
    CGContextAddLineToPoint(context, self.emailTextField.deFrameRight, linePosition);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField) {
        [self signBtnAction:nil];
    } else {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

#pragma mark - button action
- (void)signBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignBtnWithEmail:Password:)]) {
        [_delegate tapSignBtnWithEmail:self.emailTextField.text Password:self.passwordTextField.text];
    }
}

- (void)forgetBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapForgetBtn:)]) {
        [_delegate tapForgetBtn:sender];
    }
}

- (void)weiboBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapWeiBoBtn:)]) {
        [_delegate tapWeiBoBtn:sender];
    }
}

- (void)taobaoBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapTaobaoBtn:)]) {
        [_delegate tapTaobaoBtn:sender];
    }
}

- (void)wechatBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapWeChatBtn:)]) {
        [_delegate tapWeChatBtn:sender];
    }
}

#pragma mark - public method
- (void)resignResponder
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
