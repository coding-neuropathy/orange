//
//  NoDataView.m
//  orange
//
//  Created by 谢家欣 on 15/3/17.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()

//@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation NoDataView


//- (UILabel *)titleLabel
//{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.textColor = UIColorFromRGB(0x9d9e9f);
//        [self addSubview:_titleLabel];
//    }
//    return _titleLabel;
//}


- (void)setText:(NSString *)text
{
    _text = text;
    
    self.titleLabel.text = _text;
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 20);
    self.titleLabel.deFrameTop = (self.frame.size.height - self.titleLabel.frame.size.height) / 2.;
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 20., self.frame.size.height - kSeparateLineWidth);
    CGContextAddLineToPoint(context, kScreenWidth - 20, self.frame.size.height - kSeparateLineWidth);
    
    CGContextStrokePath(context);
}

@end
