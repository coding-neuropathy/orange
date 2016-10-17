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

@end


@implementation GADView

- (void)setAdDataArray:(NSArray *)adDataArray
{
    _adDataArray    = adDataArray;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
