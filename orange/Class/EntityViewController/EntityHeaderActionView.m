//
//  EntityHeaderActionView.m
//  orange
//
//  Created by 谢家欣 on 15/6/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityHeaderActionView.h"

@interface EntityHeaderActionView ()

@property (strong, nonatomic) UIButton * likeBtn;
@property (strong, nonatomic) UIButton * likeNumBtn;
@property (strong, nonatomic) UIButton * buyBtn;

@end

@implementation EntityHeaderActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.layer.cornerRadius = 4;
        [_likeBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        _likeBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _likeBtn.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        _likeBtn.layer.borderWidth = 0.5;
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.];
        _likeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_likeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateSelected];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateHighlighted|UIControlStateSelected];
        [_likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,13, 0, 0)];
        
        [_likeBtn setTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) forState:UIControlStateNormal];
        
        [_likeBtn addTarget:self action:@selector(TapLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)buyBtn
{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 4;
        _buyBtn.backgroundColor = UIColorFromRGB(0x427ec0);
        _buyBtn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:14.f];
        [_buyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//        [_buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [_buyBtn addTarget:self action:@selector(TapBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    self.likeBtn.selected = self.entity.liked;
    DDLogInfo(@"price %f", _entity.lowestPrice);
    [self.buyBtn setTitle:[NSString stringWithFormat:@"¥ %0.2f", _entity.lowestPrice] forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.likeBtn.frame = CGRectMake(0, 12., 62., 30.);
    self.likeBtn.deFrameLeft = 16.;

    self.buyBtn.frame = CGRectMake(0, 0, 77., 30);
    self.buyBtn.center = self.likeBtn.center;
    self.buyBtn.deFrameRight = self.deFrameRight - 16;
}

#pragma mark - button action
- (void)TapLikeBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handelTapLikeBtn:)]) {
        [_delegate handelTapLikeBtn:sender];
    }
}

- (void)TapBuyBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handelTapBuyBtn:)]) {
        [_delegate handelTapBuyBtn:sender];
    }
}

@end
