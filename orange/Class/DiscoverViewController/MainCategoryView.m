//
//  MainCategoryView.m
//  orange
//
//  Created by 谢家欣 on 16/8/9.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MainCategoryView.h"

@interface MainCategoryView ()

@property (strong, nonatomic) UIImageView * categoryImageView;
@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation MainCategoryView

#pragma mark - init view
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textColor = UIColorFromRGB(0x212121);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
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

#pragma mark - set datas
- (void)setCategory:(GKCategory *)category
{
    _category = category;
    DDLogInfo(@"%@", [_category.title_en lowercaseString]);
    self.titleLabel.text = NSLocalizedStringFromTable([category.title_en lowercaseString],
                                                      kLocalizedFile, nil);;
    self.categoryImageView.image = [UIImage imageNamed:[_category.title_en lowercaseString]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryImageView.frame    = CGRectMake(0., 0., 60., 60.);
    self.titleLabel.frame           = CGRectMake(0., self.categoryImageView.deFrameBottom, 60., 15.);
}






@end
