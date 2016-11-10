//
//  EntityLikeUserCell.m
//  orange
//
//  Created by 谢家欣 on 15/6/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityLikeUserCell.h"

@interface EntityLikeUserCell ()

@property (strong, nonatomic) UIImageView   *avatarView;
@property (strong, nonatomic) UIButton      *gotoEntityLikeListBtn;

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

- (UIButton *)gotoEntityLikeListBtn
{
    if (!_gotoEntityLikeListBtn) {
        _gotoEntityLikeListBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoEntityLikeListBtn.deFrameSize      = CGSizeMake(140., 20.);
        _gotoEntityLikeListBtn.titleLabel.font  = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        [_gotoEntityLikeListBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        [_gotoEntityLikeListBtn addTarget:self action:@selector(gotaoEntityLikeListAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_gotoEntityLikeListBtn];
    }
    return _gotoEntityLikeListBtn;
}

- (void)setUser:(GKUser *)user
{
    _user = user;
    [self.avatarView sd_setImageWithURL:_user.avatarURL
                       placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.contentView.deFrameSize]];
    
    
    [self setNeedsLayout];
}

- (void)setLikeUsers:(NSArray *)likeUsers
{
    _likeUsers  = likeUsers;
    
    [self.gotoEntityLikeListBtn setTitle:[NSString stringWithFormat:@"%ld 人喜爱 %@", (long)_likeUsers.count,
                                                  [NSString fontAwesomeIconStringForEnum:FAAngleRight]]
                                        forState:UIControlStateNormal];
    CGFloat width = [self.gotoEntityLikeListBtn.titleLabel.text widthWithLineWidth:0. Font:self.gotoEntityLikeListBtn.titleLabel.font];
    self.gotoEntityLikeListBtn.deFrameSize  = CGSizeMake(width, 20.);
    
    
    /**
     *  删除 imageview 防止重复渲染
     */
    for (UIView * view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger count = _likeUsers.count > 4 ? 4 : _likeUsers.count;
    for (int i = 0; i < count; i ++) {
        UIImageView * avatarImage       = [[UIImageView alloc] initWithFrame:CGRectZero];
        avatarImage.deFrameSize         = CGSizeMake(32., 32.);
        avatarImage.layer.cornerRadius  = avatarImage.deFrameHeight / 2.;
        avatarImage.layer.borderWidth   = 2.;
        avatarImage.layer.borderColor   = [UIColor colorFromHexString:@"#ffffff"].CGColor;
        avatarImage.layer.masksToBounds = YES;
        avatarImage.tag                 = i;
        GKUser * user                   = [likeUsers objectAtIndex:i];
        
        [avatarImage sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:avatarImage.deFrameSize] options:SDWebImageRetryFailed];
        
        avatarImage.deFrameLeft         = 16. + i * 24.;
        avatarImage.deFrameBottom       = self.deFrameHeight - 16.;
        
        [self.contentView insertSubview:avatarImage atIndex:count - i];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPAD) {
        self.avatarView.layer.cornerRadius          = self.avatarView.deFrameHeight / 2.;
    } else {
        
        self.gotoEntityLikeListBtn.center           = self.contentView.center;
        self.gotoEntityLikeListBtn.deFrameRight     = self.deFrameWidth - 16.;
    }
//    self.avatarView.frame = CGRectMake(0., 0., self.contentView., 36.);
}

#pragma mark - button action
- (void)gotaoEntityLikeListAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleGotoEntityLikeListBtn:)]) {
        [_delegate handleGotoEntityLikeListBtn:sender];
    }
}


@end
