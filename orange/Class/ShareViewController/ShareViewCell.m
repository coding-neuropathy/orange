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

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self    = [super initWithFrame:frame];
//    if (self) {
//        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
//        
//        [self addGestureRecognizer:tap];
//    }
//    return self;
//}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView                  = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _imageView.contentMode      = UIViewContentModeScaleToFill;
        _imageView.backgroundColor  = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel                  = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _textLabel.numberOfLines    = 2;
        _textLabel.textAlignment    = NSTextAlignmentCenter;
        _textLabel.textColor        = [UIColor colorFromHexString:@"#212121"];
        _textLabel.font             = [UIFont systemFontOfSize:10];
//        _textLabel.backgroundColor  = [UIColor redColor];
        [_textLabel sizeToFit];
//        _textLabel.adjustsFontSizeToFitWidth    = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)setIconWithImage:(UIImage *)image Title:(NSString *)title
{
    self.imageView.image        = image;
    self.imageView.deFrameSize  = image.size;
    self.textLabel.text         = title;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.imageView.deFrameSize      = CGSizeMake(self.deFrameWidth, self.deFrameWidth);
    self.imageView.deFrameTop       = (self.deFrameWidth - self.imageView.deFrameWidth) / 2.;
    self.imageView.deFrameLeft      = (self.deFrameWidth - self.imageView.deFrameWidth) / 2.;
    
    self.textLabel.deFrameSize      = CGSizeMake(self.deFrameWidth, 30.);
    self.textLabel.deFrameBottom    = self.deFrameHeight;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
