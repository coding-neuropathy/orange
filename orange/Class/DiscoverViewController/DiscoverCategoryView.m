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
        _categoryScrollView.scrollsToTop = NO;
        _categoryScrollView.showsHorizontalScrollIndicator = NO;
        _categoryScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_categoryScrollView];
    }
    return _categoryScrollView;
}

- (void)setCategories:(NSArray *)categories
{
    _categories = categories;
    
    self.categoryLabel.text = NSLocalizedStringFromTable(@"category", kLocalizedFile,  nil);
    
    self.categoryScrollView.contentSize = CGSizeMake(100 * _categories.count + 5 * (_categories.count - 1), 100.);
    
    for (int i = 0; i < _categories.count; i++) {
        GKCategory * category = _categories[i];
//        DDLogInfo(@"%@", category);
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 100. + i * 5, 0., 100., 100.)];
//        imageView.layer.cornerRadius = 4.;
//        imageView.layer.masksToBounds = YES;
//        [imageView sd_setImageWithURL:category.coverURL];
//        [self.categoryScrollView addSubview:imageView];
        UIButton * categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame = CGRectMake(i * 100. + i * 5., 0., 100., 100.);
        categoryBtn.layer.cornerRadius = 4.;
        categoryBtn.layer.masksToBounds = YES;
        [categoryBtn setTitle:category.title forState:UIControlStateNormal];
        [categoryBtn sd_setImageWithURL:category.coverURL forState:UIControlStateNormal];
        [categoryBtn addTarget:self action:@selector(categoryBtnActoin:) forControlEvents:UIControlEventTouchDragInside];
        
        [self.categoryScrollView addSubview:categoryBtn];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 30.);
    
    self.categoryScrollView.frame = CGRectMake(10., 45., kScreenWidth - 20., 100.);
}

#pragma mark - button action
-(void)categoryBtnActoin:(id)sender
{

}

@end
