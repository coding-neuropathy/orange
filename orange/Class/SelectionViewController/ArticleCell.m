//
//  ArticleCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ArticleCell.h"

@interface ArticleCell () <RTLabelDelegate>

@property (strong, nonatomic) UIImageView * coverImageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) RTLabel * detailLabel;

@end

@implementation ArticleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView){
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_coverImageView];
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
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (RTLabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
        _detailLabel.paragraphReplacement = @"";
        _detailLabel.lineSpacing = 7.0;
        _detailLabel.delegate = self;
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    self.titleLabel.text = _article.title;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_article.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10.];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_article.title length])];
     self.titleLabel.attributedText = attributedString;
    
    self.detailLabel.text = @"<font face='Helvetica-Light' color='^9d9e9f' size=12>精选图文 </font>";
    
    [self.coverImageView sd_setImageWithURL:_article.coverURL];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth * 0.584, 49);
    self.titleLabel.deFrameTop = 16.;
    self.titleLabel.deFrameLeft = 16.;
    
    self.detailLabel.frame = CGRectMake(0., 0., kScreenWidth * 0.584, 20);
    self.detailLabel.deFrameLeft = self.titleLabel.deFrameLeft;
    self.detailLabel.deFrameBottom = self.contentView.deFrameBottom - 16;
    
    self.coverImageView.frame = CGRectMake(0., 0., 112., 84.);
    self.coverImageView.deFrameTop = 16.;
    self.coverImageView.deFrameRight = kScreenWidth - 16;
    

}

@end
