//
//  MenuHeaderView.m
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MenuHeaderView.h"

@interface MenuHeaderView ()

@property (strong, nonatomic) UIButton * avatarBtn;

@end

@implementation MenuHeaderView

- (UIButton *)avatarBtn
{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _avatarBtn.backgroundColor = [UIColor redColor];
        _avatarBtn.imageView.layer.cornerRadius = 18;
        
        [_avatarBtn addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_avatarBtn];
    }
    return _avatarBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (k_isLogin) {
        //        DDLogInfo(@"image url %@", [Passport sharedInstance].user.avatarURL);
        [self.avatarBtn sd_setImageWithURL:[Passport sharedInstance].user.avatarURL forState:UIControlStateNormal];
    } else {
        [self.avatarBtn setImage:[UIImage imageNamed:@"profile_icon"] forState:UIControlStateNormal];
    }
    
    self.avatarBtn.frame = CGRectMake(0., 20., 36., 36.);
    self.avatarBtn.center = self.center;
}


#pragma mark - button action
- (void)avatarBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapAvatarBtn)]) {
        [_delegate TapAvatarBtn];
    }
}

@end
