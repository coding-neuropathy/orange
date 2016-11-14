//
//  EntityHeaderActionView.m
//  orange
//
//  Created by 谢家欣 on 15/8/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityHeaderActionView.h"
#import "UIImage+Resize.h"

@interface EntityHeaderActionView ()

//@property (strong, nonatomic) UIButton *postBtn;
//@property (strong, nonatomic) UIButton *moreButton;
//@property (strong, nonatomic) UIView *H;
@property (strong, nonatomic) UIButton  *buyBtn;
@property (strong, nonatomic) UIButton  *likeBtn;

@end

@implementation EntityHeaderActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    }
    return self;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.deFrameSize        = IS_IPAD ? CGSizeMake(200., 40.) : CGSizeMake((kScreenWidth - 44.) / 2., 40.);
        _likeBtn.titleLabel.font    = [UIFont fontWithName:@"PingFangSC-Regular" size:12.];
        _likeBtn.layer.cornerRadius = 4.;
        _likeBtn.layer.borderWidth  = 1.;
        _likeBtn.layer.borderColor  = [UIColor colorFromHexString:@"#f1f2f6"].CGColor;
    
        
        [_likeBtn setImage:[[UIImage imageNamed:@"heart"] resizedImageToSize:CGSizeMake(20., 20.)] forState:UIControlStateNormal];
        [_likeBtn setImage:[[UIImage imageNamed:@"hearted"] resizedImageToSize:CGSizeMake(20., 20.)] forState:UIControlStateSelected];
        [_likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0, 0., 0.)];
        
        [_likeBtn setTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorFromHexString:@"#757575"] forState:UIControlStateNormal];
        [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 0, 0., -10.)];
        
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_likeBtn setBackgroundColor:[UIColor colorFromHexString:@"#F5F6FA"]];
        
        
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)buyBtn
{
    if (!_buyBtn) {
        _buyBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.deFrameSize         = IS_IPAD ? CGSizeMake(200., 40.) : CGSizeMake((kScreenWidth - 44.) / 2., 40.);
        _buyBtn.titleLabel.font     = [UIFont fontWithName:@"PingFangSC-Regular" size:12.];
        _buyBtn.layer.cornerRadius  = 4.;
        _buyBtn.layer.masksToBounds = YES;
//        _likeBtn.layer.borderWidth  = 1.;
//        _likeBtn.layer.borderColor  = [UIColor colorFromHexString:@"#f1f2f6"].CGColor;
        [_buyBtn setTitleColor:[UIColor colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#6192ff"] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        [_buyBtn setBackgroundColor:[UIColor colorFromHexString:@"#6192FF"]];
        
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}



- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    if (_entity.isLiked) {
        self.likeBtn.selected = YES;
    }
    
    /**
     *  set buy btn status
     */
        if (_entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                {
                    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyBtn setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    [self.buyBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
                    //                    self.buyBtn.backgroundColor = [UIColor clearColor];
//                    [self.buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] andSize:_buyBtn.deFrameSize] forState:UIControlStateDisabled];
                    self.buyBtn.backgroundColor = [UIColor clearColor];
                    self.buyBtn.enabled = NO;
                }
                    break;
                case GKBuySOLDOUT:
                {
                    //                    self.buyBtn.backgroundColor = UIColorFromRGB(0x9d9e9f);
//                    [self.buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#9d9e9f"] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
                    self.buyBtn.backgroundColor = [UIColor colorFromHexString:@"#9d9e9f"];
                    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyBtn setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                }
                    break;
                default:
                {
                    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyBtn setTitle:[NSString stringWithFormat:@"¥ %0.2f 去购买", self.entity.lowestPrice]
                                 forState:UIControlStateNormal];
//                    [self.buyBtn setBackgroundColor:[UIColor colorFromHexString:@"#6192FF"]];
                    self.buyBtn.backgroundColor = [UIColor colorFromHexString:@"#6192ff"];
                }
                    break;
            }
        }
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.buyBtn.deFrameLeft     = IS_IPAD ? 136. : 16.;
    self.buyBtn.deFrameBottom   = self.deFrameHeight - 20.;
    
    self.likeBtn.center         = self.buyBtn.center;
    self.likeBtn.deFrameRight   = IS_IPAD ? self.deFrameWidth - 136. : self.deFrameWidth - 16.;
}

#pragma mark - button action
- (void)likeBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapLikeButtonWithEntity:Button:)]) {
        [_delegate TapLikeButtonWithEntity:self.entity Button:sender];
    }
}

- (void)buyBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapBuyButtonActionWithEntity:)]) {
        [_delegate TapBuyButtonActionWithEntity:self.entity];
    }
}



@end
