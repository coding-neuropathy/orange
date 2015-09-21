//
//  DiscoverCategoryView.m
//  orange
//
//  Created by 谢家欣 on 15/7/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverCategoryView.h"
#import "CategoryImageView.h"

@interface DiscoverCategoryView ()

@property (strong, nonatomic) UILabel * categoryLabel;
@property (strong, nonatomic) UIScrollView * categoryScrollView;

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
    
    
    for (UIView * view in self.categoryScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _categories.count; i++) {
        GKCategory * category = _categories[i];
//        DDLogInfo(@"%@", category);
        CategoryImageView * imageView = [[CategoryImageView alloc] initWithFrame:CGRectMake(i * 100. + i * 5, 0., 100., 100.)];
//        imageView.layer.cornerRadius = 4.;
//        imageView.layer.masksToBounds = YES;
//        imageView.userInteractionEnabled = YES;
        imageView.category = category;
        [imageView sd_setImageWithURL:category.coverURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(100., 100.)]];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryBtnActoin:)];
        [imageView addGestureRecognizer:tap];
        
        [self.categoryScrollView addSubview:imageView];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 30.);
    
    self.categoryScrollView.frame = CGRectMake(10., 45., kScreenWidth - 20., 100.);
    self.categoryScrollView.layer.cornerRadius = 4;
    self.categoryScrollView.layer.masksToBounds = YES;
}

#pragma mark - button action
-(void)categoryBtnActoin:(id)sender
{
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
//    DDLogInfo(@"tap tap %@", tap.view);
    
    CategoryImageView * imageview = (CategoryImageView *)tap.view;
//    DDLogInfo(@"%@", imageview.category);
    if (self.tapBlock) {
        self.tapBlock(imageview.category);
    }
}

@end
