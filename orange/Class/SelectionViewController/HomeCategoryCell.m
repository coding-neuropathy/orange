//
//  HomeCategoryCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/11.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HomeCategoryCell.h"

@interface HomeCategoryCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation HomeCategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.layer.cornerRadius = 6.;
        _imageView.layer.masksToBounds = YES;

        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView insertSubview:_titleLabel aboveSubview:self.imageView];
    }
    return _titleLabel;
}

- (void)setCategory:(GKCategory *)category
{
    _category = category;
    [self.imageView sd_setImageWithURL:_category.coverURL];
    self.titleLabel.text = _category.title;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(10., 10., self.contentView.deFrameWidth - 20, self.contentView.deFrameWidth - 20.);
    self.titleLabel.frame = CGRectMake(0., 0., self.contentView.deFrameWidth, 20);
    self.titleLabel.center = self.imageView.center;
}

@end
