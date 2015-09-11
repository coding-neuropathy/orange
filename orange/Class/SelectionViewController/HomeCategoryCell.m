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

@end

@implementation HomeCategoryCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.layer.cornerRadius = 4.;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)setCategory:(GKCategory *)category
{
    _category = category;
    [self.imageView sd_setImageWithURL:_category.coverURL];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(0., 0., 110., 60.);
}

@end
