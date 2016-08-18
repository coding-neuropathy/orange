//
//  SignUpView.m
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "SignUpView.h"

@interface SignUpView () <RTLabelDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UILabel       * emailLabel;
@property (strong, nonatomic) UITextField   * emailTextField;
@property (strong, nonatomic) UILabel       * passwordLabel;
@property (strong, nonatomic) UITextField   * passwordTextField;
@property (strong, nonatomic) UILabel       * nicknameLable;
@property (strong, nonatomic) UITextField   * nicknameTextField;

@property (strong, nonatomic) UIButton      * signUpBtn;

@property (strong, nonatomic) RTLabel       * agreementLabel;

@end

@implementation SignUpView

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
        _emailTextField.autocorrectionType          = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType      = UITextAutocapitalizationTypeNone;
        _emailTextField.placeholder                 = NSLocalizedStringFromTable(@"email", kLocalizedFile, nil);
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
        _passwordTextField                              = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.textColor                    = UIColorFromRGB(0x212121);
        _passwordTextField.font                         = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _passwordTextField.adjustsFontSizeToFitWidth    = YES;
//        _passwordTextField.leftView                     = self.passwordLabel;
//        _passwordTextField.leftViewMode                 = UITextFieldViewModeAlways;
        _passwordTextField.autocorrectionType           = UITextAutocorrectionTypeNo;
        _passwordTextField.autocapitalizationType       = UITextAutocapitalizationTypeNone;
        _passwordTextField.secureTextEntry              = YES;
        _passwordTextField.placeholder                  = NSLocalizedStringFromTable(@"password", kLocalizedFile, nil);
        _passwordTextField.clearButtonMode              = UITextFieldViewModeWhileEditing;
        _passwordTextField.keyboardType                 = UIKeyboardTypeAlphabet;
        _passwordTextField.returnKeyType                = UIReturnKeyJoin;
        _passwordTextField.textAlignment                = NSTextAlignmentLeft;
        _passwordTextField.delegate                     = self;
        
        [self addSubview:_passwordTextField];
    }
    return _passwordTextField;
}

- (UILabel *)nicknameLable
{
    if (!_nicknameLable) {
        _nicknameLable                              = [[UILabel alloc] initWithFrame:CGRectZero];
        _nicknameLable.font                         = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _nicknameLable.text                         = NSLocalizedStringFromTable(@"nickname", kLocalizedFile, nil);
        _nicknameLable.textColor                    = UIColorFromRGB(0x212121);
        _nicknameLable.textAlignment                = NSTextAlignmentLeft;
        _nicknameLable.adjustsFontSizeToFitWidth    = YES;
        _nicknameLable.frame                        = CGRectMake(0., 0., 60., 20.);
        
        [self addSubview:_nicknameLable];
    }
    return _nicknameLable;
}

- (UITextField *)nicknameTextField
{
    if (!_nicknameTextField) {
        _nicknameTextField                          = [[UITextField alloc] initWithFrame:CGRectZero];
        _nicknameTextField.textColor                = UIColorFromRGB(0x212121);
        _nicknameTextField.font                     = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
//        _nicknameTextField.leftView                 = self.nicknameLable;
//        _nicknameTextField.leftViewMode             = UITextFieldViewModeAlways;
        _nicknameTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
        _nicknameTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;
        _nicknameTextField.placeholder              = NSLocalizedStringFromTable(@"nickname", kLocalizedFile, nil);
        _nicknameTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
        _nicknameTextField.keyboardType             = UIKeyboardTypeDefault;
        _nicknameTextField.returnKeyType            = UIReturnKeyNext;
        _nicknameTextField.textAlignment            = NSTextAlignmentLeft;
        _nicknameTextField.delegate                 = self;
        
        [self addSubview:_nicknameTextField];
    }
    return _nicknameTextField;
}

- (UIButton *)signUpBtn
{
    if (!_signUpBtn) {
        _signUpBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
        _signUpBtn.layer.borderColor                = UIColorFromRGB(0x5192ff).CGColor;
        _signUpBtn.layer.borderWidth                = 0.5;
        _signUpBtn.titleLabel.textAlignment         = NSTextAlignmentCenter;
        _signUpBtn.titleLabel.font                  = [UIFont fontWithName:@"PingFangSC-Medium" size:18.];
        
        [_signUpBtn setTitle:NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signUpBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        
        [_signUpBtn addTarget:self action:@selector(signUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_signUpBtn];
    }
    return _signUpBtn;
}

- (RTLabel *)agreementLabel
{
    if (!_agreementLabel) {
        _agreementLabel                 = [[RTLabel alloc] initWithFrame:CGRectZero];
        _agreementLabel.font            = [UIFont fontWithName:@"PingFangSC-Medium" size:14.];
        _agreementLabel.textColor       = UIColorFromRGB(0x212121);
        _agreementLabel.text            = @"使用果库，表示你已同意 <a href='http://www.guoku.com/agreement/'><u color='^5192ff'><font color='^5192ff'>使用协议</font></u></a>";
        _agreementLabel.delegate        = self;
        _agreementLabel.textAlignment   = kCTTextAlignmentCenter;
        [self addSubview:_agreementLabel];
    }
    
    return _agreementLabel;
}

- (void)layoutiPhoneSubViews
{
    self.nicknameTextField.frame            = CGRectMake(0., 0., 290 * kScreeenScale, 46. * kScreeenScale);
    self.nicknameTextField.deFrameTop       = 33.;
    self.nicknameTextField.deFrameLeft      = ( self.deFrameWidth - self.nicknameTextField.deFrameWidth ) / 2.;
    
    self.emailTextField.frame               = self.nicknameTextField.frame;
    self.emailTextField.center              = self.nicknameTextField.center;
    self.emailTextField.deFrameTop          = self.nicknameTextField.deFrameBottom + 1.;
    
    self.passwordTextField.frame            = self.emailTextField.frame;
    self.passwordTextField.center           = self.emailTextField.center;
    self.passwordTextField.deFrameTop       = self.emailTextField.deFrameBottom + 1;
    
    self.signUpBtn.frame                    = CGRectMake(0., 0., 290. * kScreeenScale, 44 * kScreeenScale);
    self.signUpBtn.layer.cornerRadius       = self.passwordTextField.deFrameHeight / 2.;
    self.signUpBtn.center                   = self.passwordTextField.center;
    self.signUpBtn.deFrameTop               = self.passwordTextField.deFrameBottom + 16.;
    
    
    self.agreementLabel.frame               = CGRectMake(0., 0., 220. * kScreeenScale, 20.);
    self.agreementLabel.center              = self.signUpBtn.center;
    self.agreementLabel.deFrameTop          = self.signUpBtn.deFrameBottom + 24.;
}

- (void)layoutiPadSubViews
{
    self.nicknameTextField.frame            = CGRectMake(0., 0., 290, 46.);
    self.nicknameTextField.deFrameTop       = 33.;
    self.nicknameTextField.deFrameLeft      = ( self.deFrameWidth - self.nicknameTextField.deFrameWidth ) / 2.;
    
    self.emailTextField.frame               = self.nicknameTextField.frame;
    self.emailTextField.center              = self.nicknameTextField.center;
    self.emailTextField.deFrameTop          = self.nicknameTextField.deFrameBottom + 1.;
    
    self.passwordTextField.frame            = self.emailTextField.frame;
    self.passwordTextField.center           = self.emailTextField.center;
    self.passwordTextField.deFrameTop       = self.emailTextField.deFrameBottom + 1;
    
    self.signUpBtn.frame                    = CGRectMake(0., 0., 290., 44);
    self.signUpBtn.layer.cornerRadius       = self.passwordTextField.deFrameHeight / 2.;
    self.signUpBtn.center                   = self.passwordTextField.center;
    self.signUpBtn.deFrameTop               = self.passwordTextField.deFrameBottom + 16.;
    
    
//    self.agreementLabel.frame               = CGRectMake(0., 0., 220., 20.);
//    self.agreementLabel.center              = self.signUpBtn.center;
//    self.agreementLabel.deFrameTop          = self.signUpBtn.deFrameBottom + 24.;
}

#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPHONE)
        [self layoutiPhoneSubViews];
    else
        [self layoutiPadSubViews];
    
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
    
    CGContextMoveToPoint(context, self.nicknameTextField.deFrameLeft, self.nicknameTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.nicknameTextField.deFrameRight, self.nicknameTextField.deFrameBottom);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

#pragma mark - button action
- (void)signUpBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignUpBtnWithNickname:Email:Passwd:)]) {
        [_delegate tapSignUpBtnWithNickname:self.nicknameTextField.text
                                    Email:self.emailLabel.text
                                    Passwd:self.passwordTextField.text];
    }
}

#pragma mark - <RTLabelDelegate>
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    DDLogInfo(@"url %@", url.absoluteString);
    if (_delegate && [_delegate respondsToSelector:@selector(gotoAgreementWithURL:)]) {
        [_delegate gotoAgreementWithURL:url];
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nicknameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self signUpBtnAction:nil];
    }
        
        
    return YES;
}

#pragma mark - 
- (void)resignResponder
{
    [self.nicknameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
