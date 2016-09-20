//
//  ShareViewCell.m
//  orange
//
//  Created by 谢家欣 on 16/9/20.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ShareViewCell.h"

@interface ShareViewCell ()

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *textLabel;

@end

@implementation ShareViewCell

- (UIImageView *)imageView
{
    if (_imageView) {
        _imageView                  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.deFrameSize      = CGSizeMake(self.deFrameWidth, self.deFrameWidth);
        _imageView.backgroundColor  = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel                  = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment    = NSTextAlignmentCenter;
        _textLabel.textColor        = [UIColor colorFromHexString:@"#212121"];
        _textLabel.font             = [UIFont systemFontOfSize:10];
        
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
