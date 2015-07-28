//
//  DiscoverCategoryView.m
//  orange
//
//  Created by 谢家欣 on 15/7/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverCategoryView.h"

@interface DiscoverCategoryView ()

@property (strong, nonatomic) UILabel * categoryLabel;
@property (strong, nonatomic) UIScrollView * categoryScrollView;

@end

@implementation DiscoverCategoryView

- (UILabel *)categoryLabel
{
    if (!_categoryLabel)
    {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categoryLabel.font = [UIFont systemFontOfSize:14.];
        _categoryLabel.textColor = UIColorFromRGB(0x414243);
        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_categoryLabel];
    }
    return _categoryLabel;
}

- (UIScrollView *)categoryScrollView
{
    if (!_categoryScrollView)
    {
        _categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_categoryScrollView];
    }
    return _categoryScrollView;
}

- (void)setCategories:(NSArray *)categories
{
    _categories = categories;
    
    self.categoryLabel.text = NSLocalizedStringFromTable(@"category", kLocalizedFile,  nil);
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 30.);
}

@end
