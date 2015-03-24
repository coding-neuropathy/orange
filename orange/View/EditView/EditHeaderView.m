//
//  EditHeaderView.m
//  orange
//
//  Created by 谢家欣 on 15/3/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EditHeaderView.h"

@interface EditHeaderView ()

@property (strong, nonatomic) UIImageView * avatarImageView;
@property (strong, nonatomic) UIButton * photoBtn;

@end

@implementation EditHeaderView


- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.layer.cornerRadius = 41.;
        _avatarImageView.layer.masksToBounds = YES;
        
        [self addSubview:_avatarImageView];
    }
    
    return _avatarImageView;
}

- (UIButton *)photoBtn
{
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        _photoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_photoBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_photoBtn setTitle:[NSString fontAwesomeIconStringForEnum:FACamera] forState:UIControlStateNormal];
        _photoBtn.layer.cornerRadius = 41.;
        _photoBtn.layer.masksToBounds = YES;
        _photoBtn.backgroundColor = [UIColor colorWithWhite:0. alpha:0.32];
        [_photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoBtn];
    }
    return _photoBtn;
}


- (void)setAvatarURL:(NSURL *)avatarURL
{
    _avatarURL = avatarURL;
    
    [self.avatarImageView sd_setImageWithURL:_avatarURL placeholderImage:nil options:SDWebImageRetryFailed];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarImageView.frame = CGRectMake(0.f, 0.f, 82, 82);
    self.avatarImageView.center = CGPointMake(kScreenWidth / 2, 81.);
    
    self.photoBtn.frame = self.avatarImageView.frame;

}

- (void)photoBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapPhotoBtn:)]) {
        [_delegate TapPhotoBtn:sender];
    }
}

@end
