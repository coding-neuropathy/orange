//
//  DiscoverCategoryView.m
//  orange
//
//  Created by 谢家欣 on 15/7/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverCategoryView.h"
//#import "CategoryImageView.h"
#import "MainCategoryView.h"

@interface DiscoverCategoryView () <UIScrollViewDelegate>

@property (strong, nonatomic) UILabel * categoryLabel;
@property (strong, nonatomic) UIScrollView * categoryScrollView;
@property (strong, nonatomic) UIPageControl * pageCtr;

@end

@implementation DiscoverCategoryView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)categoryLabel
{
    if (!_categoryLabel)
    {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categoryLabel.font = [UIFont systemFontOfSize:14.];
        _categoryLabel.textColor = UIColorFromRGB(0x212121);
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
        _categoryScrollView.pagingEnabled = YES;
        _categoryScrollView.delegate = self;
        _categoryScrollView.showsHorizontalScrollIndicator = NO;
        _categoryScrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_categoryScrollView];
    }
    return _categoryScrollView;
}

- (UIPageControl *)pageCtr
{
    if (!_pageCtr) {
        _pageCtr = [[UIPageControl alloc] initWithFrame:CGRectZero];
//        _pageCtr.hidden = YES;
        _pageCtr.currentPage = 0;
        _pageCtr.backgroundColor = [UIColor clearColor];
        _pageCtr.pageIndicatorTintColor = UIColorFromRGB(0xe6e6e6);
        _pageCtr.currentPageIndicatorTintColor = UIColorFromRGB(0x757575);
//        _pageCtr.layer.cornerRadius = 16.0;
        [self addSubview:_pageCtr];
    }
    
    return _pageCtr;
}

#pragma mark - set data
- (void)setCategories:(NSArray *)categories
{
    _categories = categories;
    
    self.categoryLabel.text = NSLocalizedStringFromTable(@"category", kLocalizedFile,  nil);
    
    self.categoryScrollView.contentSize = CGSizeMake(60. * _categories.count + 16. * (_categories.count - 1), 75.);
    
    
    for (UIView * view in self.categoryScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _categories.count; i++) {
        GKCategory * category = _categories[i];
//        DDLogInfo(@"%@", category);
        MainCategoryView * categoryView = [[MainCategoryView alloc] initWithFrame:CGRectMake(i * 60. + i * 16., 0., 60., 75.)];
        categoryView.category = category;

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryBtnActoin:)];
        [categoryView addGestureRecognizer:tap];
        
        [self.categoryScrollView addSubview:categoryView];
    }
    
    self.pageCtr.numberOfPages = [_categories count] / 4;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.categoryLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 30.);
    
    self.categoryScrollView.frame = CGRectMake(16., 10., kScreenWidth - 32., 75.);
//    self.categoryScrollView.layer.cornerRadius = 4;
//    self.categoryScrollView.layer.masksToBounds = YES;

    
    self.pageCtr.bounds = CGRectMake(0.0, 0.0, 6 * (self.pageCtr.numberOfPages - 1) + 6, 6);
    self.pageCtr.center = CGPointMake(kScreenWidth / 2., self.categoryScrollView.deFrameBottom + 20.);

//    self.pageCtr.hidden = NO;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
//    CGContextSetLineWidth(context, kSeparateLineWidth);
//    CGContextMoveToPoint(context, 0., self.deFrameHeight);
//    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
//    CGContextStrokePath(context);
//    
//}

#pragma mark - button action
-(void)categoryBtnActoin:(id)sender
{
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;

    MainCategoryView * categoryView = (MainCategoryView *)tap.view;

    if (self.tapBlock) {
        self.tapBlock(categoryView.category);
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.pageCtr.currentPage = index;
}

@end
