//
//  OrderCell.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell ()

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *priceLabel;
@property (strong, nonatomic) UILabel       *volumeLable;

@end

@implementation OrderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor    = [UIColor colorFromHexString:@"#ffffff"];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView                  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.deFrameSize      = CGSizeMake(80., 80.);
        _imageView.contentMode      = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.deFrameSize     = CGSizeMake(176., 20.);
        _titleLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.];
        _titleLabel.textColor       = [UIColor colorFromHexString:@"#212121"];
        _titleLabel.textAlignment   = NSTextAlignmentLeft;
        _titleLabel.numberOfLines   = 1;
        _titleLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.deFrameSize     = CGSizeMake(55., 20.);
        _priceLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.];
        _priceLabel.textColor       = [UIColor colorFromHexString:@"#5976c1"];
        _priceLabel.textAlignment   = NSTextAlignmentRight;
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)volumeLable
{
    if (!_volumeLable) {
        _volumeLable                = [[UILabel alloc] initWithFrame:CGRectZero];
        _volumeLable.deFrameSize    = CGSizeMake(55., 20.);
        _volumeLable.font           = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.];
        _volumeLable.textColor      = [UIColor colorFromHexString:@"#757575"];
        _volumeLable.textAlignment  = NSTextAlignmentRight;
        [self.contentView addSubview:_volumeLable];
    }
    return _volumeLable;
}

- (void)setOrderItem:(GKOrderItem *)orderItem
{
    _orderItem                  = orderItem;

    [self.imageView sd_setImageWithURL:_orderItem.imageURL
                      placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.imageView.deFrameSize]
                               options:SDWebImageRetryFailed];
//
    self.titleLabel.text            = _orderItem.entityTitle;    
    self.volumeLable.text           = [NSString stringWithFormat:@"x %ld", _orderItem.volume];
    self.priceLabel.text            = [NSString stringWithFormat:@"¥ %.2f", _orderItem.promoTotalPrice];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.deFrameTop       = 10.;
    self.imageView.deFrameLeft      = 16.;
//
//    self.textLabel.deFrameSize      = CGSizeMake(176., 20.);
    self.titleLabel.deFrameTop      = 12.;
    self.titleLabel.deFrameLeft     = self.imageView.deFrameRight + 14.;
    
    self.priceLabel.deFrameTop      = self.titleLabel.deFrameTop;
    self.priceLabel.deFrameRight    = self.contentView.deFrameWidth - 16.;
    
    self.volumeLable.deFrameTop     = self.priceLabel.deFrameBottom + 4;
    self.volumeLable.deFrameRight   = self.priceLabel.deFrameRight;
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 16., self.contentView.deFrameHeight);
    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

@end
