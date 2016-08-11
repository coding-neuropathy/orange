//
//  SignInView.m
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SignInView.h"

@interface SignInView ()

@property (strong, nonatomic) UILabel       * emailLabel;
@property (strong, nonatomic) UITextField   * emailTextField;
@property (strong, nonatomic) UILabel       * passwordLabel;
@property (strong, nonatomic) UITextField   * passwordTextField;

@property (strong, nonatomic) UIButton      * signBtn;
@property (strong, nonatomic) UIButton      * forgetBtn;

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
        _emailLabel.frame           = CGRectMake(0., 0., 80., 20.);
    }
    return _emailLabel;
}

- (UITextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField                         = [[UITextField alloc] initWithFrame:CGRectZero];
        _emailTextField.textColor               = UIColorFromRGB(0xbdbdbd);
        _emailTextField.font                    = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _emailTextField.leftView                = self.emailLabel;
        _emailTextField.leftViewMode            = UITextFieldViewModeAlways;
        _emailTextField.autocorrectionType      = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType  = UITextAutocapitalizationTypeNone;
        _emailTextField.placeholder             = @"example@guoku.com";
        _emailTextField.clearButtonMode         = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType           = UIReturnKeyNext;
        _emailTextField.keyboardType            = UIKeyboardTypeEmailAddress;
        _emailTextField.textAlignment           = NSTextAlignmentLeft;
        _emailTextField.backgroundColor         = [UIColor clearColor];
        [self addSubview:_emailTextField];
    }
    return _emailTextField;
}

- (UILabel *)passwordLabel
{
    if (!_passwordLabel) {
        _passwordLabel                  = [[UILabel alloc] initWithFrame:CGRectZero];
        _passwordLabel.font             = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _passwordLabel.text             = NSLocalizedStringFromTable(@"password", kLocalizedFile, nil);
        _passwordLabel.textColor        = UIColorFromRGB(0x212121);
        _passwordLabel.textAlignment    = NSTextAlignmentLeft;
        
//        CGFloat width                   = [_passwordLabel.text widthWithLineWidth:0. Font:_passwordLabel.font];
        _passwordLabel.frame            = CGRectMake(0., 0., 80., 20.);
    }
    return _passwordLabel;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField                          = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.textColor                = UIColorFromRGB(0xbdbdbd);
        _passwordTextField.font                     = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _passwordTextField.leftView                 = self.passwordLabel;
        _passwordTextField.leftViewMode             = UITextFieldViewModeAlways;
        _passwordTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
        _passwordTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;
        _passwordTextField.secureTextEntry          = YES;
        _passwordTextField.placeholder              = @"";
        _passwordTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
        _passwordTextField.keyboardType             = UIKeyboardTypeAlphabet;
        _passwordTextField.returnKeyType            = UIReturnKeyGo;
        _passwordTextField.textAlignment            = NSTextAlignmentLeft;
        
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

#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
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
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
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

@end
