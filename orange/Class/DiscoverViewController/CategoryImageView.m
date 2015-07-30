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
    NSArray * listString = [_category.title componentsSeparatedByString:@" "];
//    DDLogInfo(@"string %@", listString);
    
    self.categorylabel.text = listString[0];
    self.categoryENlabel.text = listString[1];
 
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
