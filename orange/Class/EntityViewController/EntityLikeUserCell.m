//
//  EntityLikeUserCell.m
//  orange
//
//  Created by 谢家欣 on 15/6/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityLikeUserCell.h"

@interface EntityLikeUserCell ()

@property (strong, nonatomic) UIImageView * avatarView;

@end

@implementation EntityLikeUserCell

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarView.layer.cornerRadius = 18.;
        _avatarView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarView];
    }
    return _avatarView;
}

- (void)setUser:(GKUser *)user
{
    _user = user;
    [self.avatarView sd_setImageWithURL:_user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(36., 36.)]];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarView.frame = CGRectMake(0., 0., 36., 36.);
}


@end
