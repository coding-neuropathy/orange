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
    
    }
    return _signBtn;
}

#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.emailTextField.frame           = CGRectMake(0., 0., 290 * kScreeenScale, 46. * kScreeenScale);
    self.emailTextField.deFrameTop      = 33. + kNavigationBarHeight + kStatusBarHeight;
    self.emailTextField.deFrameLeft     = ( kScreenWidth - self.emailTextField.deFrameWidth ) / 2.;
    
    self.passwordTextField.frame        = self.emailTextField.frame;
    self.passwordTextField.center       = self.emailTextField.center;
    self.passwordTextField.deFrameTop   = self.emailTextField.deFrameBottom + 1.;
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
//    CGContextMoveToPoint(context, 0., self.contentView.deFrameHeight);
//    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

@end
