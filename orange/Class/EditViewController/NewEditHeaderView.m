//
//  NewEditHeaderView.m
//  orange
//
//  Created by D_Collin on 16/5/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "NewEditHeaderView.h"

@interface NewEditHeaderView ()

@property (nonatomic , strong)UILabel * titleLabel;
@property (strong, nonatomic) UIImageView * avatarImageView;
@end

@implementation NewEditHeaderView

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = NSLocalizedStringFromTable(@"profile Photo", kLocalizedFile, nil);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.layer.cornerRadius = 18.;
        _avatarImageView.layer.masksToBounds = YES;
        
        [self addSubview:_avatarImageView];
    }
    
    return _avatarImageView;
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
    
    self.titleLabel.frame = CGRectMake(0., 0., 100, 16.);
    self.titleLabel.deFrameLeft = 19.;
    self.titleLabel.deFrameTop = 30.;
    
    
    self.avatarImageView.frame = CGRectMake(0.f, 0.f, 36, 36);
    self.avatarImageView.deFrameTop = 16.;
    self.avatarImageView.deFrameRight = IS_IPHONE ? kScreenWidth - 50 :  kScreenWidth - kTabBarWidth - 30.;
}

@end
