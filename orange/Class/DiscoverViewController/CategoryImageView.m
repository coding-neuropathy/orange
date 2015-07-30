//
//  CategoryImageView.m
//  orange
//
//  Created by 谢家欣 on 15/7/30.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "CategoryImageView.h"

@interface CategoryImageView ()

@property (strong, nonatomic) UILabel * categorylabel;
@property (strong, nonatomic) UILabel * categoryENlabel;

@end

@implementation CategoryImageView

- (UILabel *)categorylabel
{
    if (!_categorylabel) {
        _categorylabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categorylabel.font = [UIFont boldSystemFontOfSize:14.];
        _categorylabel.textColor = UIColorFromRGB(0xffffff);
        
        [self addSubview:_categorylabel];
    }
    return _categorylabel;
}

- (UILabel *)categoryENlabel
{
    if (!_categoryENlabel) {
        _categoryENlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categoryENlabel.font = [UIFont systemFontOfSize:12.];
        _categoryENlabel.textColor = UIColorFromRGB(0xffffff);
        
        [self addSubview:_categoryENlabel];
    }
    return _categoryENlabel;
}


- (void)setCategoty:(GKCategory *)categoty
{
    _categoty = categoty;
    
    [self sd_setImageWithURL:_categoty.coverURL];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
