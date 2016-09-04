//
//  OrderHeaderView.m
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderHeaderView.h"
#import "NSDate+App.h"

@interface OrderHeaderView ()

@property (strong, nonatomic) UILabel   *createOrderLabel;
@property (strong, nonatomic) UILabel   *orderTipsLabel;
@property (strong, nonatomic) UILabel   *orderNumberLabel;
@property (strong, nonatomic) UILabel   *statusTipsLabel;
@property (strong, nonatomic) UILabel   *statusLabel;

@end

@implementation OrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor colorFromHexString:@"#ffffff"];
    }
    return self;
}

#pragma mark - lazy load UIView
- (UILabel *)createOrderLabel
{
    if (!_createOrderLabel) {
        _createOrderLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        _createOrderLabel.deFrameSize   = CGSizeMake(200., 20.);
        _createOrderLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.];
        _createOrderLabel.textColor     = [UIColor colorFromHexString:@"#212121"];
        _createOrderLabel.textAlignment = NSTextAlignmentLeft;
        
        
        [self addSubview:_createOrderLabel];
    }
    return _createOrderLabel;
}

- (UILabel *)orderTipsLabel
{
    if (!_orderTipsLabel) {
        _orderTipsLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderTipsLabel.font            = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _orderTipsLabel.textColor       = [UIColor colorFromHexString:@"#212121"];
        _orderTipsLabel.text            = NSLocalizedStringFromTable(@"order-number", kLocalizedFile, nil);
        _orderTipsLabel.deFrameSize     = CGSizeMake([_orderTipsLabel.text widthWithLineWidth:0. Font:_orderTipsLabel.font], 20.);
        
        
        [self addSubview:_orderTipsLabel];
    }
    return _orderTipsLabel;
}

- (UILabel *)orderNumberLabel
{
    if (!_orderNumberLabel) {
        _orderNumberLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderNumberLabel.font          = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _orderNumberLabel.textColor     = [UIColor colorFromHexString:@"#757575"];
//        _orderNumberLabel.text          = NSLocalizedStringFromTable(@"order-number", kLocalizedFile, nil);
//        _orderNumberLabel.deFrameSize   = CGSizeMake([_orderNumberLabel.text widthWithLineWidth:0. Font:_orderNumberLabel.font], 20.);
        
        [self addSubview:_orderNumberLabel];
    }
    return _orderNumberLabel;
}

- (UILabel *)statusTipsLabel
{
    if (!_statusTipsLabel) {
        _statusTipsLabel                = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusTipsLabel.font           = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _statusTipsLabel.textColor      = [UIColor colorFromHexString:@"#212121"];
        _statusTipsLabel.textAlignment  = NSTextAlignmentLeft;
        _statusTipsLabel.text           = NSLocalizedStringFromTable(@"order-status", kLocalizedFile, nil);
        _statusTipsLabel.deFrameSize    = CGSizeMake([_orderNumberLabel.text widthWithLineWidth:0. Font:_orderNumberLabel.font], 20.);
        
        [self addSubview:_statusTipsLabel];
        
    }
    return _statusTipsLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel                    = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font               = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _statusLabel.textColor          = [UIColor colorFromHexString:@"#757575"];
//        _statusLabel.text               = NSLocalizedStringFromTable(@"order-status", kLocalizedFile, nil);
//        _statusLabel.deFrameSize        = CGSizeMake([_orderNumberLabel.text widthWithLineWidth:0. Font:_orderNumberLabel.font], 20.);
        
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}



- (void)setOrder:(GKOrder *)order
{
    _order = order;
    
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:order.createdDateTime];
    self.createOrderLabel.text          = [NSString stringWithFormat:@"%@",
                                           [_order.createdDateTime stringWithFormat:kDateFormat_yyyy_mm_dd_HH_mm_ss]];
    
    self.orderNumberLabel.text          = [NSString stringWithFormat:@"%@", _order.orderNumber];
    self.orderNumberLabel.deFrameSize   = CGSizeMake([_order.orderNumber widthWithLineWidth:0. Font:self.orderNumberLabel.font], 20.);
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.createOrderLabel.deFrameTop    = 16.;
    self.createOrderLabel.deFrameLeft   = 16.;
    
    self.orderTipsLabel.deFrameTop      = self.createOrderLabel.deFrameBottom + 4.;
    self.orderTipsLabel.deFrameLeft     = self.createOrderLabel.deFrameLeft;
    
    self.orderNumberLabel.deFrameTop    = self.orderTipsLabel.deFrameTop;
    self.orderNumberLabel.deFrameLeft   = self.orderTipsLabel.deFrameRight + 10.;
    
    self.statusTipsLabel.deFrameTop     = self.orderTipsLabel.deFrameBottom + 4.;
    self.statusTipsLabel.deFrameLeft    = self.orderTipsLabel.deFrameLeft;
    
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
        
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
        
    CGContextMoveToPoint(context, 16., self.deFrameHeight);
    CGContextAddLineToPoint(context, self.deFrameWidth, self.deFrameHeight);
        
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

@end
