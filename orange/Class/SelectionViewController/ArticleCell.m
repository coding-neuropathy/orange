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
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UILabel * timeLabel;

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
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _detailLabel.paragraphReplacement = @"";
//        _detailLabel.lineSpacing = 7.0;
//        _detailLabel.delegate = self;
        _detailLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.];
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        _timeLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}


- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    self.titleLabel.text = _article.title;
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_article.title];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
//    [paragraphStyle setLineSpacing:10.];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_article.title length])];
//     self.titleLabel.attributedText = attributedString;
    
    self.detailLabel.text = _article.content;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
    self.detailLabel.attributedText = attributedString;
    
    [self.coverImageView sd_setImageWithURL:_article.coverURL];
    
    NSDate * date =  [NSDate dateWithTimeIntervalSince1970:_article.pub_time];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAClockO], [date stringWithDefaultFormat]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = CGRectMake(0., 0., kScreenWidth - 32, (kScreenWidth - 32) / 1.8);
    self.coverImageView.deFrameTop = 16.;
    self.coverImageView.deFrameLeft = 16;
    
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 32., 25);
    self.titleLabel.deFrameLeft = 10.;
    self.titleLabel.deFrameTop = self.coverImageView.deFrameBottom + 16;
    
    self.detailLabel.frame = CGRectMake(0., 0., kScreenWidth -32, 40);
    self.detailLabel.center = self.titleLabel.center;
    self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom + 5;

    self.timeLabel.frame = CGRectMake(0., 0., 100., 20.);
    self.timeLabel.deFrameBottom = self.contentView.deFrameHeight - 16.;
    self.timeLabel.deFrameRight = self.contentView.deFrameRight - 16.;
    
}

@end
