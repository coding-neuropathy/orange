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

@property (strong, nonatomic) UIButton  *alipayBtn;
@property (strong, nonatomic) UIButton  *wechatPayBtn;
@property (strong, nonatomic) UIButton  *storePayBtn;

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

- (UIButton *)alipayBtn
{
    if (!_alipayBtn) {
        _alipayBtn                      = [UIButton buttonWithType:UIButtonTypeCustom];
        _alipayBtn.deFrameSize          = CGSizeMake((kScreenWidth - 46) / 3., 116.);
        _alipayBtn.titleLabel.font      = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _alipayBtn.layer.cornerRadius   = 4.;
        _alipayBtn.layer.masksToBounds  = YES;
        _alipayBtn.backgroundColor      = [UIColor colorFromHexString:@"#f8f8f8"];
        _alipayBtn.imageEdgeInsets      = UIEdgeInsetsMake(0., 34., 30., 15.);
        _alipayBtn.titleEdgeInsets      = UIEdgeInsetsMake(55., -15., 0., 15.);
        
        [_alipayBtn setImage:[UIImage imageNamed:@"AliPay"] forState:UIControlStateNormal];
        [_alipayBtn setTitle:NSLocalizedStringFromTable(@"alipay", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_alipayBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        [_alipayBtn addTarget:self action:@selector(alipayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_alipayBtn];
    }
    return _alipayBtn;
}

- (UIButton *)wechatPayBtn
{
    if (!_wechatPayBtn) {
        _wechatPayBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatPayBtn.deFrameSize           = CGSizeMake((kScreenWidth - 46) / 3., 116.);
        _wechatPayBtn.titleLabel.font       = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _wechatPayBtn.layer.cornerRadius    = 4.;
        _wechatPayBtn.layer.masksToBounds   = YES;
        _wechatPayBtn.backgroundColor       = [UIColor colorFromHexString:@"#f8f8f8"];
        _wechatPayBtn.imageEdgeInsets       = UIEdgeInsetsMake(0., 34., 30., 0.);
        _wechatPayBtn.titleEdgeInsets       = UIEdgeInsetsMake(55., -15., 0., 15.);
        
        [_wechatPayBtn setTitle:NSLocalizedStringFromTable(@"wechat-pay", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_wechatPayBtn setImage:[UIImage imageNamed:@"WechatPay"] forState:UIControlStateNormal];
        [_wechatPayBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        [_wechatPayBtn addTarget:self action:@selector(wechatPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_wechatPayBtn];
    }
    return _wechatPayBtn;
}

- (UIButton *)storePayBtn
{
    if (!_storePayBtn) {
        _storePayBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        _storePayBtn.deFrameSize           = CGSizeMake((kScreenWidth - 46) / 3., 116.);
        _storePayBtn.titleLabel.font       = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _storePayBtn.titleLabel.textAlignment       = NSTextAlignmentCenter;
        _storePayBtn.layer.cornerRadius    = 4.;
        _storePayBtn.layer.masksToBounds   = YES;
        _storePayBtn.backgroundColor       = [UIColor colorFromHexString:@"#f8f8f8"];
        _storePayBtn.imageEdgeInsets       = UIEdgeInsetsMake(0., 34., 30., 15.);
        _storePayBtn.titleEdgeInsets       = UIEdgeInsetsMake(55., -15, 0., 15.);
        
        [_storePayBtn setTitle:NSLocalizedStringFromTable(@"credit-pay", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_storePayBtn setImage:[UIImage imageNamed:@"Credit Card"] forState:UIControlStateNormal];
        [_storePayBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        [_storePayBtn addTarget:self action:@selector(storePayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_storePayBtn];
    }
    return _storePayBtn;
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
    
    self.alipayBtn.deFrameTop           = self.payTipsLabel.deFrameBottom + 10.;
    self.alipayBtn.deFrameLeft          = self.payTipsLabel.deFrameLeft;
    
    self.wechatPayBtn.deFrameTop        = self.alipayBtn.deFrameTop;
    self.wechatPayBtn.deFrameLeft       = self.alipayBtn.deFrameRight + 10.;
    
    self.storePayBtn.deFrameTop         = self.wechatPayBtn.deFrameTop;
    self.storePayBtn.deFrameLeft        = self.wechatPayBtn.deFrameRight + 10.;
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


#pragma mark - button action
- (void)alipayBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapAlipayBtn:)]) {
    
        [_delegate tapAlipayBtn:sender];
    }
}

- (void)wechatPayBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapWeCahtBtn:)]) {
        
        [_delegate tapWeCahtBtn:sender];
    }
}

- (void)storePayBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapStorePayBtn:)])
    {
        [_delegate tapStorePayBtn:sender];
    }
}

@end
