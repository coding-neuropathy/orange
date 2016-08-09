//
//  DiscoverCategoryCell.m
//  orange
//
//  Created by 谢家欣 on 16/8/9.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "DiscoverCategoryCell.h"

@interface DiscoverCategoryCell ()

@property (strong, nonatomic) UIImageView * categoryImageView;
@property (strong, nonatomic) UILabel * titleLable;

@end

@implementation DiscoverCategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _categoryImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_categoryImageView];
    
    }
    return _categoryImageView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10.];
        _titleLable.textColor = UIColorFromRGB(0x212121);
        _titleLable.textAlignment = NSTextAlignmentCenter;
//        [_titleLable adjustsFontSizeToFitWidth];
        _titleLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLable];
    }
    return _titleLable;
}


- (void)setCategory:(GKCategory *)category
{
    _category = category;
    self.categoryImageView.image = [UIImage imageNamed:[_category.title_en lowercaseString]];
//    self.titleLable.text = _category.title_cn;
    self.titleLable.text = NSLocalizedStringFromTable([category.title_en lowercaseString], kLocalizedFile, nil);
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryImageView.frame    = CGRectMake(0., 0., self.deFrameWidth, self.deFrameWidth);
    self.titleLable.frame           = CGRectMake(0., 0., self.deFrameWidth, 12.);
    
    self.titleLable.deFrameTop      = self.categoryImageView.deFrameBottom + 2.;
}

@end
