//
//  CategoryArticleCell.m
//  orange
//
//  Created by D_Collin on 16/1/28.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CategoryArticleCell.h"

@interface CategoryArticleCell ()<RTLabelDelegate>

@property (nonatomic , strong) UIImageView * coverImageView;

@property (nonatomic , strong) UILabel * titleLabel;

@property (nonatomic , strong)RTLabel * detailLabel;

@end

@implementation CategoryArticleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:_coverImageView];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (RTLabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
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
    [self.coverImageView sd_setImageWithURL:_article.coverURL_300];
    
    [self setNeedsLayout];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = CGRectMake(0., 0., 112 * kScreenWidth/375, 84 * kScreenWidth/375);
    self.coverImageView.deFrameTop = 16.;
    self.coverImageView.deFrameRight = self.contentView.deFrameRight - 16;
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 48 - 112 * kScreenWidth/375, 50);
    self.titleLabel.deFrameTop = 16.;
    self.titleLabel.deFrameLeft = 16.;
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
