//
//  NoResultView.m
//  orange
//
//  Created by 谢家欣 on 16/8/2.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "NoResultView.h"

@interface NoResultView ()

@property (strong, nonatomic) UILabel * textLabel;

@end

@implementation NoResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:20.];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.27];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.textLabel.text = _text;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(0., 0., kScreenWidth, 30.);
    self.textLabel.center = self.center;
    [super layoutSubviews];
}


@end
