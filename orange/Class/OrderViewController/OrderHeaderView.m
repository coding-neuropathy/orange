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

//@property (strong, nonatomic) UILabel   *createOrderLabel;
//@property (strong, nonatomic) UILabel   *orderTipsLabel;
//@property (strong, nonatomic) UILabel   *orderNumberLabel;
//@property (strong, nonatomic) UILabel   *statusTipsLabel;
//@property (strong, nonatomic) UILabel   *statusLabel;
//@property (strong, nonatomic) UIButton  *paymentBtn;

@end

@implementation OrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor colorFromHexString:@"#ffffff"];
        self.paymentEnable      = YES;
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
        _statusTipsLabel.deFrameSize    = CGSizeMake([_statusTipsLabel.text widthWithLineWidth:0. Font:_orderNumberLabel.font], 20.);
        
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
        _statusLabel.textAlignment      = NSTextAlignmentLeft;
        
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UIButton *)paymentBtn
{
    if (!_paymentBtn) {
        _paymentBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentBtn.deFrameSize         = CGSizeMake(74., 32.);
        _paymentBtn.hidden              = YES;
        _paymentBtn.layer.cornerRadius  = 4.;
        _paymentBtn.layer.borderWidth   = 1.;
        _paymentBtn.layer.borderColor   = [UIColor colorFromHexString:@"#6192ff"].CGColor;
        _paymentBtn.titleLabel.font     = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        
        [_paymentBtn setTitle:NSLocalizedStringFromTable(@"payment", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_paymentBtn setTitleColor:[UIColor colorFromHexString:@"6192ff"] forState:UIControlStateNormal];
        [_paymentBtn addTarget:self action:@selector(paymentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_paymentBtn];
    }
    return _paymentBtn;
}

- (void)setOrder:(GKOrder *)order
{
    _order = order;
    
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:order.createdDateTime];
    self.createOrderLabel.text          = [NSString stringWithFormat:@"%@",
                                           [_order.createdDateTime stringWithFormat:kDateFormat_yyyy_mm_dd_HH_mm_ss]];
    
    self.orderNumberLabel.text          = [NSString stringWithFormat:@"%@", self.order.orderNumber];
    self.orderNumberLabel.deFrameSize   = CGSizeMake([self.order.orderNumber widthWithLineWidth:0. Font:self.orderNumberLabel.font], 20.);
    
    DDLogInfo(@"status %ld", order.status);
    if (self.paymentEnable) {
        switch (_order.status) {
            case Expired:
                self.statusLabel.text       = NSLocalizedStringFromTable(@"expired", kLocalizedFile, nil);
                self.statusLabel.textColor  = [UIColor lightGrayColor];
                self.paymentBtn.hidden      = NO;
                break;
            case WaitingForPayment:
                self.statusLabel.text       = NSLocalizedStringFromTable(@"wait-for-payment", kLocalizedFile, nil);
                self.statusLabel.textColor  = [UIColor redColor];
                self.paymentBtn.hidden      = NO;
                break;
            case Paid:
                self.statusLabel.text       = NSLocalizedStringFromTable(@"paid", kLocalizedFile, nil);
                self.statusLabel.textColor  = [UIColor colorFromHexString:@"#757575"];
                self.paymentBtn.hidden      = NO;
                break;
            default:
//            self.paymentBtn.hidden      = YES;
                break;
        }
    }
    self.statusLabel.deFrameSize        = CGSizeMake([self.statusLabel.text widthWithLineWidth:0. Font:self.statusLabel.font], 20.);
    
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
    
    self.statusLabel.deFrameTop         = self.statusTipsLabel.deFrameTop;
    self.statusLabel.deFrameLeft        = self.statusTipsLabel.deFrameRight + 10.;
    

    switch (self.order.status) {
        case WaitingForPayment:
        {
            self.paymentBtn.deFrameRight    = self.deFrameWidth - 16.;
            self.paymentBtn.deFrameBottom   = self.deFrameHeight - 16.;
        }
            break;

        default:
            self.paymentBtn.hidden      = YES;
            break;
    }
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

#pragma mark - button action
- (void)paymentBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapPaymentBtnAction:)]) {
        [_delegate tapPaymentBtnAction:self.order];
    }
}

@end
