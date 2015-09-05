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
@property (strong, nonatomic) UIButton *buyButton;
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
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _likeButton.frame = CGRectMake(0, 0, kScreenWidth/3, 44.);
//        UIImage * like = [[UIImage imageNamed:@"like"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        _likeButton.tintColor = UIColorFromRGB(0xffffff);
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        [_likeButton setTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_likeButton setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 10.)];
        [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.entity.isLiked) {
            _likeButton.selected = YES;
        }
        [self addSubview:_likeButton];
    }
    return _likeButton;
}

- (UIButton *)postBtn
{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_postBtn setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
        if (!self.note) {
            [_postBtn setTitle:NSLocalizedStringFromTable(@"note", kLocalizedFile, nil) forState:UIControlStateNormal];
        }else{
            [_postBtn setTitle:NSLocalizedStringFromTable(@"update note", kLocalizedFile, nil) forState:UIControlStateNormal];
        }

        [_postBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        _postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_postBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 10.)];
        [_postBtn addTarget:self action:@selector(noteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_postBtn];
    }
    return _postBtn;
}

- (void)setNote:(GKNote *)note
{
    _note = note;
    if (!self.note) {
        [_postBtn setTitle:NSLocalizedStringFromTable(@"note", kLocalizedFile, nil) forState:UIControlStateNormal];
    }else{
        [_postBtn setTitle:NSLocalizedStringFromTable(@"update note", kLocalizedFile, nil) forState:UIControlStateNormal];
    }
}

- (UIView *)H
{
    if (!_H) {
        _H = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        _H.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:0.95];
        [self addSubview:_H];
    }
    return _H;
}

- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _buyButton.frame = CGRectMake(0., 0., kScreenWidth/3, 44.);
        _buyButton.layer.masksToBounds = YES;
        _buyButton.layer.cornerRadius = 4;
        _buyButton.backgroundColor = UIColorFromRGB(0x427ec0);
        _buyButton.titleLabel.font = [UIFont fontWithName:@"Georgia" size:14.f];
        [_buyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_buyButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [_buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                {
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    [_buyButton setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
                    _buyButton.backgroundColor = [UIColor clearColor];
                    _buyButton.enabled = NO;
                }
                    break;
                case GKBuySOLDOUT:
                {
                    _buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                }
                    break;
                default:
                {
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
                }
                    break;
            }
            
        }
        [self addSubview:_buyButton];
    }
    return _buyButton;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    self.likeButton.frame = CGRectMake(0, 3., 90., 44.);
    self.postBtn.frame = CGRectMake(0., 3.,  120., 44.);
    self.buyButton.frame = CGRectMake(0., 10., 90., 30.);
    
    if (_entity.purchaseArray.count > 0) {
        GKPurchase * purchase = self.entity.purchaseArray[0];
        switch (purchase.status) {
            case GKBuyREMOVE:
            {
                [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                [_buyButton setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
                _buyButton.backgroundColor = [UIColor clearColor];
                _buyButton.enabled = NO;
            }
                break;
            case GKBuySOLDOUT:
            {
                _buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
                [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
            }
                break;
        }
        
    }
    
    
    [self setNeedsLayout];
    
//    DDLogInfo(@"log log");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.likeButton.center = CGPointMake(kScreenWidth * 1/6, self.deFrameHeight/2);
    self.postBtn.center = CGPointMake(kScreenWidth * 3/6, self.deFrameHeight/2);
    self.buyButton.center = CGPointMake(kScreenWidth * 5/6, self.deFrameHeight/2);
    self.H.deFrameBottom = self.deFrameHeight;
}

#pragma mark - button action
- (void)likeButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapLikeBtn:)])
    {
        [_delegate tapLikeBtn:sender];
    }
}

- (void)noteButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapPostNoteBtn:)])
    {
        [_delegate tapPostNoteBtn:sender];
    }
}

- (void)buyButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapBuyBtn:)])
    {
        [_delegate tapBuyBtn:sender];
    }
}

@end
