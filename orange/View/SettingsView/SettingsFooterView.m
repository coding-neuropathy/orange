//
//  SettingsFooterView.m
//  orange
//
//  Created by 谢家欣 on 15/3/30.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SettingsFooterView.h"

@interface SettingsFooterView ()

@property (strong, nonatomic) UIButton * signInBtn;
@property (strong, nonatomic) UIButton * signOutBtn;

@end

@implementation SettingsFooterView

- (UIButton *)signInBtn
{
    if (!_signInBtn) {
        _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signInBtn.backgroundColor = UIColorFromRGB(0x427ec0);
        _signInBtn.layer.cornerRadius = 5;
        [_signInBtn setTitle:NSLocalizedStringFromTable(@"sign in", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signInBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        _signInBtn.hidden = YES;
        [self addSubview:_signInBtn];
    }
    return _signInBtn;
}

- (UIButton *)signOutBtn
{
    if (!_signOutBtn) {
        _signOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signOutBtn.backgroundColor = UIColorFromRGB(0xcd1841);
        _signOutBtn.layer.cornerRadius = 5;
        [_signOutBtn setTitle:NSLocalizedStringFromTable(@"sign out", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signOutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        _signOutBtn.hidden = YES;
        [self addSubview:_signOutBtn];
    }
    return _signOutBtn;
}


- (void)setIs_login:(BOOL)is_login
{
    _is_login = is_login;

    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    if (_is_login) {
        self.signOutBtn.hidden = NO;
        self.signOutBtn.frame = CGRectMake(20., 20., kScreenWidth - 40., 44.);

    } else {
        self.signInBtn.hidden = NO;
        self.signInBtn.frame = CGRectMake(20., 20., kScreenWidth - 40., 44.);
    }
}

#pragma mark - button action

- (void)login:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapLoginBtnAction)]){
        [_delegate TapLoginBtnAction];
    }
}

- (void)logout:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapLogoutBtnAction)]) {
        [_delegate TapLogoutBtnAction];
    }
}

@end
