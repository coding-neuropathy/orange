//
//  UpdatePasswordView.m
//  orange
//
//  Created by 谢家欣 on 16/9/28.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UpdatePasswordView.h"
#import <1PasswordExtension/OnePasswordExtension.h>


@interface UpdatePasswordView () <UITextFieldDelegate>

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
        _passwordTextField.returnKeyType            = UIReturnKeyNext;
//        _passwordTextField.placeholder              = NSLocalizedStringFromTable(@"current-password", kLocalizedFile, nil);
        NSAttributedString *placeholder = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedStringFromTable(@"current-password", kLocalizedFile, nil)
                                           attributes:@{
                                                        NSForegroundColorAttributeName : [UIColor colorFromHexString:@"#666666"],
                                                                                                                                                    }];
        _passwordTextField.attributedPlaceholder    = placeholder;
        _passwordTextField.textColor                = [UIColor colorFromHexString:@"#212121"];
        _passwordTextField.font                     = [UIFont systemFontOfSize:14.];
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
        _refreshPasswordTextField.returnKeyType             = UIReturnKeyNext;
        _refreshPasswordTextField.secureTextEntry           = YES;
        _refreshPasswordTextField.textAlignment             = NSTextAlignmentLeft;
//        _refreshPasswordTextField.placeholder               = NSLocalizedStringFromTable(@"refresh-password", kLocalizedFile, nil);
        NSAttributedString *placeholder                     = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedStringFromTable(@"refresh-password", kLocalizedFile, nil)
                                           attributes:@{
                                                        NSForegroundColorAttributeName : [UIColor colorFromHexString:@"#666666"],
                                                        }];
        _refreshPasswordTextField.attributedPlaceholder     = placeholder;
        _refreshPasswordTextField.textColor                 = [UIColor colorFromHexString:@"#212121"];
        _refreshPasswordTextField.font                      = [UIFont systemFontOfSize:14.];
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
        _confirmPasswordTextField.returnKeyType             = UIReturnKeySend;
        _confirmPasswordTextField.secureTextEntry           = YES;
        _confirmPasswordTextField.textAlignment             = NSTextAlignmentLeft;
//        _confirmPasswordTextField.placeholder               = NSLocalizedStringFromTable(@"confirm-password", kLocalizedFile, nil);
        NSAttributedString *placeholder                     = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedStringFromTable(@"confirm-password", kLocalizedFile, nil)
                                           attributes:@{
                                                        NSForegroundColorAttributeName : [UIColor colorFromHexString:@"#666666"],
                                                        }];
        _confirmPasswordTextField.attributedPlaceholder     = placeholder;
        _confirmPasswordTextField.textColor                 = [UIColor colorFromHexString:@"#212121"];
        _confirmPasswordTextField.font                      = [UIFont systemFontOfSize:14.];
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
        self.passwordTextField.rightView        = self.onePasswordBtn;
        self.passwordTextField.rightViewMode    = UITextFieldViewModeAlways;
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
    if (_delegate && [_delegate respondsToSelector:@selector(handleOnePassword:)]) {
        [_delegate handleOnePassword:sender];
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.passwordTextField) {
            [self.refreshPasswordTextField becomeFirstResponder];
        }
        else if (textField == self.refreshPasswordTextField) {
            [self.confirmPasswordTextField becomeFirstResponder];
        }
        else {
//            [self postButtonAction];
            if (_delegate && [_delegate respondsToSelector:@selector(handleKeyboardSend:)]) {
                [_delegate handleKeyboardSend:textField];
            }
        }
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
