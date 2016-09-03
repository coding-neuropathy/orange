//
//  ArticlePreView.m
//  orange
//
//  Created by 谢家欣 on 16/9/3.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticlePreView.h"

@interface ArticlePreView ()

@property (strong, nonatomic) UIImageView   *CoverImageView;
@property (strong, nonatomic) UILabel       *titleLable;
@property (strong, nonatomic) UILabel       *detailLabel;

@end

@implementation ArticlePreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
