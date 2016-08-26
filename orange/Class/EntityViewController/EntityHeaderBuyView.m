//
//  EntityHeaderBuyView.m
//  orange
//
//  Created by 谢家欣 on 15/8/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityHeaderBuyView.h"

@interface EntityHeaderBuyView ()

@property (strong, nonatomic) UIButton *postBtn;
@property (strong, nonatomic) UIButton *buyButton;
@property (strong, nonatomic) UIView *H;
@end

@implementation EntityHeaderBuyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    }
    return self;
}


- (UIView *)H
{
    if (!_H) {
        _H = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        _H.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:0.95];
        //[self addSubview:_H];
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
        _buyButton.backgroundColor = [UIColor colorFromHexString:@"#6eaaf0"];
        //设置购买按钮的字体样式以及字号大小
        _buyButton.titleLabel.font = [UIFont fontWithName:@"Georgia" size:17.f];
        //设置字体样式居中
        [_buyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_buyButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [_buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                  //商品购买链接数组
        if (self.entity.purchaseArray.count > 0) {
            //购买链接
            GKPurchase * purchase = self.entity.purchaseArray[0];
                       //上下架状态
            switch (purchase.status) {
                     //
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
                    [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f 去购买", self.entity.lowestPrice] forState:UIControlStateNormal];
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
                [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f 去购买", self.entity.lowestPrice] forState:UIControlStateNormal];
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
    
    DDLogInfo(@"entity buy view  %f", self.deFrameHeight);
    
    self.buyButton.frame = IS_IPAD ? CGRectMake(0., 0., self.deFrameWidth - 40., 40.) : CGRectMake(0., 0., self.deFrameWidth -20., 40.);
    
    self.buyButton.center = CGPointMake(self.deFrameWidth * 3/6, self.deFrameHeight / 2);
    self.H.deFrameBottom = self.deFrameHeight;
}

#pragma mark - button Buy
- (void)buyButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapBuyBtn:)])
    {
        [_delegate tapBuyBtn:sender];
    }
}

@end
