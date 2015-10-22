//
//  EntityCell.m
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityCell.h"
#import "ImageLoadingView.h"

@interface EntityCell ()

@property (strong, nonatomic) ImageLoadingView * loading;
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

- (ImageLoadingView *)loading {
    if(!_loading) {
        _loading = [[ImageLoadingView alloc] init];
        _loading.hidesWhenStopped = YES;
        [self.contentView addSubview:_loading];
    }
    return _loading;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    __weak __typeof(&*self)weakSelf = self;
    [self.loading startAnimating];
    if (IS_IPHONE_6P) {
        [self.imageView sd_setImageWithURL:_entity.imageURL_310x310 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(120., 120.)] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.loading stopAnimating];
        }];
    } else {
        [self.imageView sd_setImageWithURL:_entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(120., 120.)] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.loading stopAnimating];
        }];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.imageView.frame = CGRectMake(0., 0., self.deFrameWidth, self.deFrameHeight);
    
    self.loading.center = CGPointMake(self.contentView.deFrameWidth/2, self.contentView.deFrameHeight/2);
    [self.contentView bringSubviewToFront:self.loading];
}

#pragma mark - button action
- (void)ImageBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapImageWithEntity:)]) {
        [_delegate TapImageWithEntity:self.entity];
    }
}

@end
