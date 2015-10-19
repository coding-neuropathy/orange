//
//  UserFooterSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserFooterSectionView.h"

@interface UserFooterSectionView ()

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIButton * moreBtn;

@end

@implementation UserFooterSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textColor = UIColorFromRGB(0x427ec0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 44.);
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., 0);
    CGContextAddLineToPoint(context, kScreenWidth, 0);
    CGContextStrokePath(context);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xf8f8f8).CGColor);
    CGContextSetLineWidth(context, 20.);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextStrokePath(context);
}


@end
