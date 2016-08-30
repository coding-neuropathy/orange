//
//  CartCell.m
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CartCell.h"

@interface CartCell ()

@property (strong, nonatomic) UILabel   *priceLabel;
@property (strong, nonatomic) UIButton  *addBtn;
@property (strong, nonatomic) UIButton  *decrBtn;
@property (strong, nonatomic) UILabel   *volumeLabel;

@end

@implementation CartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self                = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.font             = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.];
        self.textLabel.textColor        = [UIColor colorFromHexString:@"#212121"];
        
        self.detailTextLabel.font       = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        self.detailTextLabel.textColor  = [UIColor colorFromHexString:@"#757575"];
        
        self.imageView.contentMode      = UIViewContentModeScaleAspectFit;
        
        self.selectionStyle             = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark - lazy load
- (UILabel *)priceLabel
{
    if (!_priceLabel){
        _priceLabel                     = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.deFrameSize         = CGSizeMake(100., 20.);
        _priceLabel.font                = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.];
        _priceLabel.textColor           = [UIColor colorFromHexString:@"#5976C1"];
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.deFrameSize             = CGSizeMake(20., 20.);
        
        [_addBtn setImage:[UIImage imageNamed:@"sku-plus"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_addBtn];
    }
    return _addBtn;
}

- (UIButton *)decrBtn
{
    if (!_decrBtn) {
        _decrBtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
        _decrBtn.deFrameSize            = CGSizeMake(20., 20.);
        
        [_decrBtn setImage:[UIImage imageNamed:@"sku-minus"] forState:UIControlStateNormal];
        [_decrBtn addTarget:self action:@selector(decrBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_decrBtn];
    }
    return _decrBtn;
}

- (UILabel *)volumeLabel
{
    if (!_volumeLabel) {
        _volumeLabel                    = [[UILabel alloc] initWithFrame:CGRectZero];
        _volumeLabel.deFrameSize        = CGSizeMake(40., 20.);
        _volumeLabel.font               = [UIFont fontWithName:@"Roboto-Regular" size:16.];
        _volumeLabel.textColor          = [UIColor colorFromHexString:@"#000000"];
        _volumeLabel.textAlignment      = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_volumeLabel];
    }
    return _volumeLabel;
}

- (void)setCartItem:(ShoppingCart *)cartItem
{
    _cartItem                   = cartItem;
    self.textLabel.text         = _cartItem.entity.entityName;
    self.detailTextLabel.text   = _cartItem.sku.attr_string;
    self.priceLabel.text        = [NSString stringWithFormat:@"¥ %.2f", _cartItem.sku.originPrice];
    self.volumeLabel.text       = [NSString stringWithFormat:@"%ld", _cartItem.volume];
    
    [self.imageView sd_setImageWithURL:_cartItem.entity.imageURL_310x310 placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.imageView.deFrameSize] options:SDWebImageRetryFailed];
    

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.deFrameSize          = CGSizeMake(80. * kScreeenScale, 80. * kScreeenScale);
    self.imageView.deFrameTop           = (self.contentView.deFrameHeight - self.imageView.deFrameHeight) / 2.;
    self.imageView.deFrameLeft          = 10.;
    
    self.textLabel.deFrameSize          = CGSizeMake(210. * kScreeenScale, 22.);
    self.textLabel.deFrameTop           = 12.;
    self.textLabel.deFrameLeft          = self.imageView.deFrameRight + 14.;
    
    self.priceLabel.deFrameLeft         = self.textLabel.deFrameLeft;
    self.priceLabel.deFrameTop          = self.textLabel.deFrameBottom + 4.;
    
    self.detailTextLabel.deFrameSize    = CGSizeMake(210 * kScreeenScale, 20.);
    self.detailTextLabel.center         = self.textLabel.center;
    self.detailTextLabel.deFrameBottom  = self.contentView.deFrameHeight - 14.;
    
    self.addBtn.deFrameLeft             = self.textLabel.deFrameRight + 16.;
    self.addBtn.deFrameTop              = self.textLabel.deFrameTop;
    
    self.decrBtn.center                 = self.addBtn.center;
    self.decrBtn.deFrameBottom          = self.contentView.deFrameHeight - 10.;
    
    self.volumeLabel.center             = self.addBtn.center;
    self.volumeLabel.deFrameTop         = self.addBtn.deFrameBottom + 10.;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
        
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
        
//    CGContextMoveToPoint(context, self.contentView.deFrameWidth, 0.);
//    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
    CGContextMoveToPoint(context, 0., self.contentView.deFrameHeight);
    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
        
        CGContextStrokePath(context);
    
    [super drawRect:rect];
}

#pragma mark - button action
- (void)addBtnAction:(id)sender
{

}

- (void)decrBtnAction:(id)sender
{

}

@end
