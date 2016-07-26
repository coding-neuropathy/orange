//
//  CategoryResultView.m
//  orange
//
//  Created by D_Collin on 16/7/14.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CategoryResultView.h"

@interface CategoriesNameLabel : UILabel

@property (nonatomic , strong)GKEntityCategory * category;

@property (nonatomic , strong)UILabel * categoryLabel;

@end

@interface CategoryResultView ()

@property (nonatomic , strong)UILabel * cateLabel;

@property (nonatomic , strong)UIImageView * imgView;

@property (nonatomic , strong)UIScrollView * cateScrollView;

@end

@implementation CategoryResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView.image = [UIImage imageNamed:@"yellow"];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)cateLabel
{
    if (!_cateLabel) {
        _cateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _cateLabel.font = [UIFont fontWithName:@"Semiblod" size:14.];
        _cateLabel.textColor = UIColorFromRGB(0x414243);
        _cateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_cateLabel];
    }
    return _cateLabel;
}

- (UIScrollView *)cateScrollView
{
    if (!_cateScrollView) {
        _cateScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
//        _cateScrollView.backgroundColor = [UIColor yellowColor];
        _cateScrollView.scrollsToTop = NO;
        _cateScrollView.showsHorizontalScrollIndicator = NO;
        _cateScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_cateScrollView];
    }
    return _cateScrollView;
}

- (void)setCategorys:(NSMutableArray *)categorys
{
    _categorys = categorys;
    
    self.cateLabel.text = NSLocalizedStringFromTable(@"category", kLocalizedFile, nil);
    self.cateScrollView.contentSize = CGSizeMake(50 * _categorys.count + 18 * (_categorys.count - 1), 50.);
    for (int i = 0; i < categorys.count; i ++) {
        GKEntityCategory * category = _categorys[i];
        CategoriesNameLabel * label = [[CategoriesNameLabel alloc]initWithFrame:CGRectMake(i * 50. + i * 18., 0., 60., 25.)];
        label.category = category;
        label.text = category.categoryName;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(categoryAction:)];
        [label addGestureRecognizer:tap];
        
        [self.cateScrollView addSubview:label];
    }
    [self setNeedsLayout];
}

#pragma mark --------- Label action ------------

- (void)categoryAction:(id)sender
{
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
    CategoriesNameLabel * label = (CategoriesNameLabel *)tap.view;
    if (self.tapCategoryBlock) {
        self.tapCategoryBlock(label.category);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.imgView.frame = CGRectMake(11., 16., 10., 10.);
    self.cateLabel.frame = CGRectMake(15., 1., 100., 40.);
    self.cateScrollView.frame = IS_IPHONE?CGRectMake(10., 45., kScreenWidth - 20., 80.):CGRectMake(10., 45., kScreenWidth  - kTabBarWidth - 20., 80.);
    self.cateScrollView.layer.cornerRadius = 4;
    self.cateScrollView.layer.masksToBounds = YES;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextStrokePath(context);
    
}

@end

@implementation CategoriesNameLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 12.;
        self.layer.masksToBounds = YES;
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
        self.font = [UIFont systemFontOfSize:14.];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (UILabel *)categoryLabel
{
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0., 0., 50., 25.)];
        _categoryLabel.font = [UIFont systemFontOfSize:14.];
        _categoryLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _categoryLabel.textColor = UIColorFromRGB(0x414243);
        [self addSubview:_categoryLabel];
    }
    return _categoryLabel;
}

@end
