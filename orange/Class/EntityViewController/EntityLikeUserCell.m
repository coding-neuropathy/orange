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
        _avatarView                     = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _avatarView.layer.cornerRadius = 18.;
        _avatarView.deFrameSize         = self.contentView.deFrameSize;
        _avatarView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_avatarView];
    }
    return _avatarView;
}

- (void)setUser:(GKUser *)user
{
    _user = user;
    [self.avatarView sd_setImageWithURL:_user.avatarURL
                       placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.contentView.deFrameSize]];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarView.layer.cornerRadius  = self.avatarView.deFrameHeight / 2.;
//    self.avatarView.frame = CGRectMake(0., 0., self.contentView., 36.);
}


@end
