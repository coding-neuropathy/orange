//
//  CheckoutFooterView.m
//  orange
//
//  Created by 谢家欣 on 16/9/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CheckoutFooterView.h"

@interface CheckoutFooterView ()

@property (strong, nonatomic) UILabel   *orderPricelabel;
@property (strong, nonatomic) UILabel   *payTipsLabel;

@end

@implementation CheckoutFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor colorFromHexString:@"#ffffff"];
    }
    return self;
}


- (UILabel *)orderPricelabel
{
    if (!_orderPricelabel) {
        _orderPricelabel                = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderPricelabel.deFrameSize    = CGSizeMake(200., 20.);
        _orderPricelabel.font           = [UIFont fontWithName:@"PingFangSC-Medium" size:14.];
        _orderPricelabel.textAlignment  = NSTextAlignmentRight;
        _orderPricelabel.textColor      = [UIColor colorFromHexString:@"#5976c1"];
        
        [self addSubview:_orderPricelabel];
    }
    return _orderPricelabel;
}

- (UILabel *)payTipsLabel
{
    if (!_payTipsLabel) {
        _payTipsLabel                   = [[UILabel alloc] initWithFrame:CGRectZero];
        _payTipsLabel.deFrameSize       = CGSizeMake(100., 20.);
        _payTipsLabel.font              = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _payTipsLabel.textColor         = [UIColor colorFromHexString:@"#212121"];
        _payTipsLabel.textAlignment     = NSTextAlignmentLeft;
        
        [self addSubview:_payTipsLabel];
    }
    return _payTipsLabel;
}

- (void)setOrder:(GKOrder *)order
{
    _order  = order;
    self.orderPricelabel.text           = [NSString stringWithFormat:@"共 %ld 件 总金额 %.2f",
                                           _order.orderVolume, _order.orderPrice];
    self.payTipsLabel.text              = NSLocalizedStringFromTable(@"payment", kLocalizedFile, nil);
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.orderPricelabel.deFrameTop     = 10.;
    self.orderPricelabel.deFrameRight   = self.deFrameWidth - 16.;
    
    self.payTipsLabel.deFrameTop        = self.orderPricelabel.deFrameBottom + 34.;
    self.payTipsLabel.deFrameLeft       = 16.;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., 40.);
    CGContextAddLineToPoint(context, self.deFrameWidth, 40.);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}
@end
