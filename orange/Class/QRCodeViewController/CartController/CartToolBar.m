//
//  CartToolBar.m
//  orange
//
//  Created by 谢家欣 on 16/8/30.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CartToolBar.h"

@interface CartToolBar ()

@property (strong, nonatomic) UIButton  *orderBtn;
@property (strong, nonatomic) UILabel   *priceLabel;

@end

@implementation CartToolBar

- (UIButton *)orderBtn
{
    if (!_orderBtn) {
        _orderBtn                               = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderBtn.backgroundColor               = UIColorFromRGB(0x6192ff);
        _orderBtn.deFrameSize                   = CGSizeMake(128., self.deFrameHeight);
        _orderBtn.titleLabel.font               = [UIFont fontWithName:@"PingFangSC-Medium" size:16.];
        _orderBtn.titleLabel.textAlignment      = NSTextAlignmentCenter;
        _orderBtn.enabled                       = NO;
        
        [_orderBtn setTitle:NSLocalizedStringFromTable(@"submit-order", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_orderBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] andSize:_orderBtn.deFrameSize] forState:UIControlStateDisabled];
        
        [_orderBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_orderBtn];
    }
    return _orderBtn;
}

- (UILabel *)priceLabel
{
    if(!_priceLabel) {
        _priceLabel                             = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.deFrameSize                 = CGSizeMake(100., 20.);
        _priceLabel.textColor                   = UIColorFromRGB(0x5976c1);
        _priceLabel.font                        = [UIFont fontWithName:@"Roboto-Bold" size:16.];
        _priceLabel.textAlignment               = NSTextAlignmentLeft;
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}


- (void)setPrice:(CGFloat)price
{
    _price      = price;

    [super setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    
    CGContextMoveToPoint(context, 0., 0.);
    CGContextAddLineToPoint(context, self.deFrameWidth, 0.);
    
    CGContextStrokePath(context);
}

#pragma mark - button action
- (void)orderBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapOrderBtn:)]) {
        [_delegate tapOrderBtn:sender];
    }
}

#pragma mark - pubilc method
- (void)updatePriceWithprice:(float)price
{
    self.priceLabel.text    = [NSString stringWithFormat:@"¥ %.2f", price];
    self.orderBtn.enabled   = YES;
}

@end
