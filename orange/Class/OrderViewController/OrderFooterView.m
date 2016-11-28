//
//  OrderFooterView.m
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderFooterView.h"

@interface OrderFooterView ()

@property (strong, nonatomic) UILabel   *orderPricelabel;

@end

@implementation OrderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = kBackgroundColor;
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

- (void)setOrder:(GKOrder *)order
{
    _order  = order;
    self.orderPricelabel.text           = [NSString stringWithFormat:@"共 %ld 件 总金额 %.2f",
                                           (long)_order.orderVolume, _order.orderPrice];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.orderPricelabel.deFrameTop     = 10.;
    self.orderPricelabel.deFrameRight   = self.deFrameWidth - 16.;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., self.deFrameHeight - 10.);
    CGContextAddLineToPoint(context, self.deFrameWidth, self.deFrameHeight - 10.);
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#f8f8f8"].CGColor);
    CGContextSetLineWidth(context, 10.);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, self.deFrameWidth, self.deFrameHeight);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}


@end
