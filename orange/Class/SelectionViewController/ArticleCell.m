//
//  ArticleCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ArticleCell.h"

@interface ArticleCell ()

@property (strong, nonatomic) UIImageView * coverImageView;
@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation ArticleCell

- (UIImageView *)coverImageView
{
    if (!_coverImageView){
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_coverImageView];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    self.titleLabel.text = _article.title;
    
    [self.coverImageView sd_setImageWithURL:_article.coverURL];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0., 0., 219, 49);
    self.titleLabel.deFrameTop = 16.;
    self.titleLabel.deFrameLeft = 16.;
    
    self.coverImageView.frame = CGRectMake(0., 0., 112., 84.);
    self.coverImageView.deFrameTop = 16.;
    self.coverImageView.deFrameRight = kScreenWidth - 16;
    

}

@end
