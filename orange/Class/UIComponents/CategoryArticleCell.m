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

@property (strong, nonatomic) UILabel * contentLabel;

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

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:13.];
        _contentLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 2.;
        //        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        _contentLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (void)setArticle:(GKArticle *)article
{
    _article = article;
    self.titleLabel.text = _article.title;
    
    self.contentLabel.text = _article.digest;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_article.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:_article.digest];
    NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    
    NSInteger x = 4;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        x = 2;
    }
    else{
        x = 2;
    }
    
    [paragraphStyle setLineSpacing:x];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_article.title length])];
    self.titleLabel.attributedText = attributedString;
    
    NSInteger y = 4;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        y = 2;
    }
    else
    {
        y = 4;
    }
    [paragraphStyle2 setLineSpacing:y];
    paragraphStyle2.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [_article.digest length])];
    self.contentLabel.attributedText = attributedString2;
    
    [self.coverImageView sd_setImageWithURL:_article.coverURL_300];
    
    [self setNeedsLayout];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPHONE) {
        self.coverImageView.frame = CGRectMake(0., 0., 112*kScreenWidth/375, 84*kScreenWidth/375);
        self.coverImageView.deFrameTop = 16.;
        self.coverImageView.deFrameLeft = self.contentView.deFrameLeft + 16;
        self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 48 - 112*kScreenWidth/375, self.contentView.deFrameHeight - 32.);
        self.titleLabel.deFrameTop = -5.;
        self.titleLabel.deFrameLeft = self.coverImageView.deFrameRight + 12;
        
        self.contentLabel.frame = CGRectMake(0., 0., kScreenWidth - 48 - 112*kScreenWidth/375, 50);
        self.contentLabel.deFrameLeft = self.titleLabel.deFrameLeft;
        self.contentLabel.deFrameTop = self.titleLabel.deFrameBottom - 19.;
    }
    else
    {
        self.coverImageView.frame = CGRectMake(0., 0., self.contentView.deFrameWidth, self.contentView.deFrameWidth / 1.8);
        
        self.titleLabel.frame = CGRectMake(0., 0., self.contentView.deFrameWidth - 20., 45.);
        self.titleLabel.deFrameLeft = 10.;
        self.titleLabel.deFrameTop = self.coverImageView.deFrameBottom + 15.;
        self.contentLabel.frame = CGRectMake(0., 0., self.contentView.deFrameWidth - 20., 45.);
        self.contentLabel.deFrameLeft = self.titleLabel.deFrameLeft;
        self.contentLabel.deFrameTop = self.titleLabel.deFrameBottom;
    }
    
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
