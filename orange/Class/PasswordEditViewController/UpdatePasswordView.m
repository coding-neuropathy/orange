//
//  UpdatePasswordView.m
//  orange
//
//  Created by 谢家欣 on 16/9/28.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UpdatePasswordView.h"
#import <1PasswordExtension/OnePasswordExtension.h>


@interface UpdatePasswordView ()

@property (nonatomic, strong) UITextField   *passwordTextField;
@property (nonatomic, strong) UITextField   *refreshPasswordTextField;
@property (nonatomic, strong) UITextField   *confirmPasswordTextField;

@property (strong, nonatomic) UIButton      *onePasswordBtn;

@end

@implementation UpdatePasswordView


- (UIButton *)onePasswordBtn
{
    if (!_onePasswordBtn) {
        _onePasswordBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _onePasswordBtn.deFrameSize     = CGSizeMake(32., 32.);
        [_onePasswordBtn setImage:[UIImage imageNamed:@"1password-button"] forState:UIControlStateNormal];
        [_onePasswordBtn addTarget:self action:@selector(tapOnePasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_onePasswordBtn];
    }
    return _onePasswordBtn;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField                          = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.deFrameSize              = CGSizeMake(self.deFrameWidth - 80., 44.);
        _passwordTextField.keyboardType             = UIKeyboardTypeAlphabet;
        _passwordTextField.secureTextEntry          = YES;
        _passwordTextField.textAlignment            = NSTextAlignmentLeft;
        _passwordTextField.placeholder              = NSLocalizedStringFromTable(@"old-password", kLocalizedFile, nil);
        _passwordTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;
        
        [self addSubview:_passwordTextField];
    }
    return _passwordTextField;
}

- (UITextField *)refreshPasswordTextField
{
    if (!_refreshPasswordTextField) {
        _refreshPasswordTextField                           = [[UITextField alloc] initWithFrame:CGRectZero];
        _refreshPasswordTextField.deFrameSize               = CGSizeMake(self.deFrameWidth - 80., 44.);
        _refreshPasswordTextField.keyboardType              = UIKeyboardTypeAlphabet;
        _refreshPasswordTextField.secureTextEntry           = YES;
        _refreshPasswordTextField.textAlignment             = NSTextAlignmentLeft;
        _refreshPasswordTextField.placeholder               = NSLocalizedStringFromTable(@"refresh-password", kLocalizedFile, nil);
        _refreshPasswordTextField.autocapitalizationType    = UITextAutocapitalizationTypeNone;
        
        [self addSubview:_refreshPasswordTextField];
    }
    return _refreshPasswordTextField;

}

- (UITextField *)confirmPasswordTextField
{
    if (!_confirmPasswordTextField) {
        _confirmPasswordTextField                           = [[UITextField alloc] initWithFrame:CGRectZero];
        _confirmPasswordTextField.deFrameSize               = CGSizeMake(self.deFrameWidth - 80., 44.);
        _confirmPasswordTextField.keyboardType              = UIKeyboardTypeAlphabet;
        _confirmPasswordTextField.secureTextEntry           = YES;
        _confirmPasswordTextField.textAlignment             = NSTextAlignmentLeft;
        _confirmPasswordTextField.placeholder               = NSLocalizedStringFromTable(@"confirm-password", kLocalizedFile, nil);
        _confirmPasswordTextField.autocapitalizationType    = UITextAutocapitalizationTypeNone;
        
        [self addSubview:_confirmPasswordTextField];
    
    }
    return _confirmPasswordTextField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.passwordTextField.deFrameTop           = 30.;
    self.passwordTextField.deFrameLeft          = 40.;
    
    self.refreshPasswordTextField.center        = self.passwordTextField.center;
    self.refreshPasswordTextField.deFrameTop    = self.passwordTextField.deFrameBottom + 10.;
//    self.refreshPasswordTextField.deFrameLeft   = self.passwordTextField.deFrameLeft;
    
    self.confirmPasswordTextField.center        = self.passwordTextField.center;
    self.confirmPasswordTextField.deFrameTop    = self.refreshPasswordTextField.deFrameBottom + 10.;
    
    if ([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        self.onePasswordBtn.center          = self.passwordTextField.center;
        self.onePasswordBtn.deFrameLeft     = self.passwordTextField.deFrameRight + 5.;
        
        [self addSubview:self.onePasswordBtn];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
 
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, self.passwordTextField.deFrameLeft, self.passwordTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.passwordTextField.deFrameRight, self.passwordTextField.deFrameBottom);
    
    CGContextMoveToPoint(context, self.refreshPasswordTextField.deFrameLeft, self.refreshPasswordTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.refreshPasswordTextField.deFrameRight, self.refreshPasswordTextField.deFrameBottom);
    
    CGContextMoveToPoint(context, self.confirmPasswordTextField.deFrameLeft, self.confirmPasswordTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.confirmPasswordTextField.deFrameRight, self.confirmPasswordTextField.deFrameBottom);
//    CGContextMoveToPoint(context, 0., self.contentView.deFrameHeight);
//    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
    CGContextStrokePath(context);
    
}

#pragma mark - button action
- (void)tapOnePasswordBtn:(id)sender
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
