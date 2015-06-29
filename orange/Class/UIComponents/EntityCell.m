//
//  EntityCell.m
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityCell.h"

@interface EntityCell ()
@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation EntityCell

- (UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = UIColorFromRGB(0xffffff);
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(ImageBtnAction:)];
        [_imageView addGestureRecognizer:tap];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    if (IS_IPHONE_6P) {
            [self.imageView sd_setImageWithURL:_entity.imageURL_310x310 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(120., 120.)]];
    } else {
        [self.imageView sd_setImageWithURL:_entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(120., 120.)]];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0., 0., self.deFrameWidth, self.deFrameHeight);
}

#pragma mark - button action
- (void)ImageBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapImageWithEntity:)]) {
        [_delegate TapImageWithEntity:self.entity];
    }
}

@end
