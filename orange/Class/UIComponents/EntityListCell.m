//
//  EntityListCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/17.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "EntityListCell.h"

@interface EntityListCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * priceLabel;
@property (strong, nonatomic) UIButton * likeBtn;

@end

@implementation EntityListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:18.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.numberOfLines = 2.;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont fontWithName:@"Georgia" size:18.];
        _priceLabel.textColor = UIColorFromRGB(0x427ec0);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;

    [self.imageView sd_setImageWithURL:_entity.imageURL_240x240];
    self.titleLabel.text = _entity.title;
    GKPurchase * purchase = [_entity.purchaseArray objectAtIndex:0];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", purchase.lowestPrice];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0., 0., 90., 90.);
    self.imageView.deFrameTop = 10.;
    self.imageView.deFrameLeft = 10.;

    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 110., 44);
    self.titleLabel.deFrameLeft = self.imageView.deFrameRight + 10.;
    self.titleLabel.deFrameTop = self.imageView.deFrameTop;
    
    self.priceLabel.frame = CGRectMake(0., 0., 100., 20);
    self.priceLabel.deFrameLeft = self.imageView.deFrameRight + 10;
    self.priceLabel.deFrameBottom = self.contentView.deFrameBottom - 10;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    
    CGContextStrokePath(context);
}


@end
