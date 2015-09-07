//
//  HomeEntityCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/7.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HomeEntityCell.h"

@interface HomeEntityCell ()

@property (strong, nonatomic) UIImageView * imageView;


@end

@implementation HomeEntityCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
