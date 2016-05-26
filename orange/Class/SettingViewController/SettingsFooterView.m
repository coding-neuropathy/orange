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
        _signInBtn.backgroundColor = UIColorFromRGB(0x6EAAF0);
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
        _signOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, 0, self.deFrameWidth + 2, 44)];
        _signOutBtn.backgroundColor = UIColorFromRGB(0xcd1841);
        _signOutBtn.layer.cornerRadius = 0;
        _signOutBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        _signOutBtn.layer.borderWidth = 0.5;
        _signOutBtn.backgroundColor = UIColorFromRGB(0xffffff);
        [_signOutBtn setTitle:NSLocalizedStringFromTable(@"sign out", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:UIColorFromRGB(0x427EC0) forState:UIControlStateNormal];
        [_signOutBtn setImage:[UIImage imageNamed:@"logout_icon"] forState:UIControlStateNormal];
        [_signOutBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 28,0 , 0)];
        [_signOutBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 18,0 , 0)];
        [_signOutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        _signOutBtn.hidden = YES;
        _signOutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_signOutBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
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
        self.signOutBtn.frame = CGRectMake(0, 20, kScreenWidth, 44.);

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
