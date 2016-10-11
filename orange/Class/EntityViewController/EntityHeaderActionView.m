//
//  EntityHeaderActionView.m
//  orange
//
//  Created by 谢家欣 on 15/8/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityHeaderActionView.h"

@interface EntityHeaderActionView ()

@property (strong, nonatomic) UIButton *postBtn;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIView *H;
@end

@implementation EntityHeaderActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    }
    return self;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.deFrameSize     = CGSizeMake(80., 44.);
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 10.)];
        [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_likeButton];
    }
    return _likeButton;
}

- (UIButton *)postBtn
{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_postBtn setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
        [_postBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        _postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_postBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 10.)];
        [_postBtn addTarget:self action:@selector(noteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_postBtn];
    }
    return _postBtn;
}


- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.deFrameSize = CGSizeMake(80., 44.);
        _moreButton.layer.masksToBounds = YES;
        _moreButton.layer.cornerRadius = 4;
        [_moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_moreButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
    }
    return _moreButton;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
//    self.likeButton.frame = CGRectMake(0, 3., 80., 44.);
    if (_entity.isLiked) {
        self.likeButton.selected = YES;
    }
    self.postBtn.frame = CGRectMake(0., 3.,  80., 44.);
//    self.moreButton.frame = CGRectMake(0., 3., 80., 44.);
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPHONE) {
        self.likeButton.center = CGPointMake(kScreenWidth * 3/6-80, self.deFrameHeight/2);
        self.postBtn.center = CGPointMake(kScreenWidth * 3/6, self.deFrameHeight/2);
        self.moreButton.center = CGPointMake(kScreenWidth * 3/6+80, self.deFrameHeight/2);
    }
    else
    {
        if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight
            || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft)
        {
            self.likeButton.center = CGPointMake((kScreenWidth - kTabBarWidth) * 3/6-80 - (kScreenWidth - kScreenHeight)/2, self.deFrameHeight/2);
            self.postBtn.center = CGPointMake((kScreenWidth - kTabBarWidth) * 3/6 - (kScreenWidth - kScreenHeight)/2, self.deFrameHeight/2);
            self.moreButton.center = CGPointMake((kScreenWidth - kTabBarWidth) * 3/6+80 - (kScreenWidth - kScreenHeight)/2, self.deFrameHeight/2);
        }
        else
        {
            self.likeButton.center = CGPointMake((kScreenWidth - kTabBarWidth) * 3/6-80, self.deFrameHeight/2);
            self.postBtn.center = CGPointMake((kScreenWidth - kTabBarWidth) * 3/6, self.deFrameHeight/2);
            self.moreButton.center = CGPointMake((kScreenWidth - kTabBarWidth) * 3/6+80, self.deFrameHeight/2);
        }
        
    }
    self.H.deFrameBottom = self.deFrameHeight;
}
//
//- (void)likeAction
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(TapLikeButtonWithEntity:Button:)])
//    {
//        [_delegate TapLikeButtonWithEntity:self.entity Button:self.likeButton];
//    }
//}

#pragma mark - button action
- (void)likeButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapLikeButtonWithEntity:Button:)])
    {
        [_delegate TapLikeButtonWithEntity:self.entity Button:self.likeButton];
    }
}

- (void)noteButtonAction:(id)sender
{
    if (_headerDelegate && [_headerDelegate respondsToSelector:@selector(tapPostNoteBtn:)])
    {
        [_headerDelegate tapPostNoteBtn:sender];
    }
}

- (void)moreButtonAction:(id)sender
{
    if (_headerDelegate && [_headerDelegate respondsToSelector:@selector(tapMoreBtn:)])
    {
        [_headerDelegate tapMoreBtn:sender];
    }
}


@end
