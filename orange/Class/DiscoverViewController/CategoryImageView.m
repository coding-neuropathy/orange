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
@property (strong, nonatomic) UIImageView * maskView;

@end

@implementation CategoryImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIImageView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:UIColorFromRGB(0x000000) andSize:CGSizeMake(100., 100.)]];
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (UILabel *)categorylabel
{
    if (!_categorylabel) {
        _categorylabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categorylabel.font = [UIFont boldSystemFontOfSize:14.];
        _categorylabel.textColor = UIColorFromRGB(0xffffff);
        _categorylabel.textAlignment = NSTextAlignmentCenter;
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
        _categoryENlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_categoryENlabel];
    }
    return _categoryENlabel;
}


- (void)setCategory:(GKCategory *)category
{
    _category = category;
//    [self sd_setImageWithURL:_categoty.coverURL];
    self.maskView.alpha = 0.4;
    NSArray * listString = [_category.title componentsSeparatedByString:@" "];
//    DDLogInfo(@"string %@", listString);
    if (listString.count >= 2) {
        self.categorylabel.text = listString[0];
        self.categoryENlabel.text = listString[1];
    } else {
        self.categorylabel.text = listString[0];
    }
 
//    self.layer.mask
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.categorylabel.frame = CGRectMake(0., 0., 100., 18.);
    self.categoryENlabel.frame = CGRectMake(0., 0., 100., 16.);
    self.categorylabel.deFrameTop = 30.;
    self.categoryENlabel.deFrameTop = self.categorylabel.deFrameBottom + 5.;
}

@end
