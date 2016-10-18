//
//  GADView.m
//  orange
//
//  Created by 谢家欣 on 16/10/17.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GADView.h"


@interface GADView ()

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UIButton      *closeBtn;

@property (strong, nonatomic) GAdvertise    *ad;

@end


@implementation GADView

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView                      = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.deFrameSize          = self.deFrameSize;
        _imageView.contentMode          = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds  = YES;
        
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    DDLogInfo(@"touch touch ");
    if (self.touchADBlock) {
//        DDLogInfo(@"ad url %@", self.ad.clickURL);
        self.touchADBlock(self.ad.clickURL);
    }
}

#pragma mark - set data
- (void)setAdDataArray:(NSArray *)adDataArray
{
    _adDataArray    = adDataArray;
    self.ad = _adDataArray.firstObject;
    
    [self.imageView sd_setImageWithURL:self.ad.imageURL];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.deFrameTop   = 0.;
    self.imageView.deFrameLeft  = 0.;
//    self.imageView
}

@end
