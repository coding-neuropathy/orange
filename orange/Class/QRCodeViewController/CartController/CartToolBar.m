//
//  CartToolBar.m
//  orange
//
//  Created by 谢家欣 on 16/8/30.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CartToolBar.h"

@interface CartToolBar ()

@property (strong, nonatomic) UIButton  *checkOutBtn;
@property (strong, nonatomic) UILabel   *priceLabel;

@end

@implementation CartToolBar

- (UIButton *)checkOutBtn
{
    if (!_checkOutBtn) {
        _checkOutBtn                               = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkOutBtn.backgroundColor               = UIColorFromRGB(0x6192ff);
        _checkOutBtn.deFrameSize                   = CGSizeMake(128., self.deFrameHeight);
        _checkOutBtn.titleLabel.font               = [UIFont fontWithName:@"PingFangSC-Medium" size:16.];
        _checkOutBtn.titleLabel.textAlignment      = NSTextAlignmentCenter;
//        _orderBtn.enabled                       = NO;
        _checkOutBtn.enabled                        = NO;
        
        [_checkOutBtn setTitle:NSLocalizedStringFromTable(@"submit-order", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_checkOutBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_checkOutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] andSize:_checkOutBtn.deFrameSize]
                                forState:UIControlStateDisabled];
        [_checkOutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] andSize:_checkOutBtn.deFrameSize] forState:UIControlStateDisabled];
        
        [_checkOutBtn addTarget:self action:@selector(checkOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_checkOutBtn];
    }
    return _checkOutBtn;
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
    if (_price > 0) {
        self.checkOutBtn.enabled            = YES;
    }
    [super setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.checkOutBtn.deFrameRight               = self.deFrameRight;
    self.priceLabel.deFrameTop                  = 16.;
    self.priceLabel.deFrameLeft                 = 16.;
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
- (void)checkOutBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapCheckOutBtn:)]) {
        [_delegate tapCheckOutBtn:sender];
    }
}

#pragma mark - pubilc method
- (void)updatePriceWithprice:(float)price
{
    self.priceLabel.text    = [NSString stringWithFormat:@"¥ %.2f", price];
    if (price > 0) self.checkOutBtn.enabled   = YES;
}

@end
