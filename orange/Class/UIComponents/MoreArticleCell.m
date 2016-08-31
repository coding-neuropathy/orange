//
//  MoreArticleCell.m
//  orange
//
//  Created by D_Collin on 16/6/16.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MoreArticleCell.h"

@interface MoreArticleCell ()<RTLabelDelegate>

@property (strong, nonatomic) UIImageView * coverImageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) RTLabel * tagsLabel;

@end

@implementation MoreArticleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        
    }
    return self;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView){
        _coverImageView                     = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverImageView.deFrameSize         = CGSizeMake(112*kScreenWidth/375, 84*kScreenWidth/375);
        _coverImageView.contentMode         = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_coverImageView];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font            = [UIFont boldSystemFontOfSize:17.];
        _titleLabel.textColor       = UIColorFromRGB(0x414243);
        _titleLabel.textAlignment   = NSTextAlignmentLeft;
        _titleLabel.numberOfLines   = 2;
        
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel                    = [[UILabel alloc] initWithFrame:CGRectZero];
        //        _detailLabel.paragraphReplacement = @"";
        //        _detailLabel.lineSpacing = 7.0;
        //        _detailLabel.delegate = self;
        _detailLabel.font               = [UIFont systemFontOfSize:14.];
        _detailLabel.numberOfLines      = 2;
        _detailLabel.textColor          = [UIColor colorFromHexString:@"#9d9e9f"];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (RTLabel *)tagsLabel
{
    if (!_tagsLabel) {
        _tagsLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
        _tagsLabel.paragraphReplacement = @"";
        _tagsLabel.lineSpacing = 7.;
        _tagsLabel.delegate = self;
        [self.contentView addSubview:_tagsLabel];
    }
    return _tagsLabel;
}


- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    self.titleLabel.text = _article.title;
    
    self.detailLabel.text = _article.content;
    self.detailLabel.text = [_article.content trimed];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7.];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
    self.detailLabel.attributedText = attributedString;
    self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    /**
     *  设置图片
     */
    [self.coverImageView sd_setImageWithURL:_article.coverURL placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.coverImageView.deFrameSize]];
    
    
    [self setNeedsLayout];
    //    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPAD) {
#pragma mark - layout ipad
        self.coverImageView.frame = CGRectMake(0., 0., self.contentView.deFrameWidth - 32, (self.contentView.deFrameWidth - 32) / 1.8);
        self.coverImageView.deFrameTop = 16.;
        self.coverImageView.deFrameLeft = 16;
        
        CGFloat height = [self.article.title heightWithLineWidth:self.contentView.deFrameWidth - 32 Font:[UIFont systemFontOfSize:17.] LineHeight:7];
        self.titleLabel.frame = CGRectMake(0., 0., self.contentView.deFrameWidth - 32., height);
        self.titleLabel.deFrameLeft = 16.;
        self.titleLabel.deFrameTop = self.coverImageView.deFrameBottom + 10.;
        
        self.detailLabel.frame = CGRectMake(0., 0., self.contentView.deFrameWidth - 32, 70);
        self.detailLabel.center = self.titleLabel.center;
        self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom + 5;
        
        
    } else {
#pragma mark - layout iphone
//        self.coverImageView.frame = CGRectMake(0., 0., 112*kScreenWidth/375, 84*kScreenWidth/375);
        self.coverImageView.deFrameTop = 16.;
        self.coverImageView.deFrameLeft = self.contentView.deFrameLeft + 16;
        
        self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 48 - 112*kScreenWidth/375, self.contentView.deFrameHeight - 32.);
        self.titleLabel.deFrameTop = -5.;
        self.titleLabel.deFrameLeft = self.coverImageView.deFrameRight + 12;
        
        self.detailLabel.frame = CGRectMake(0., 0., kScreenWidth - 48 - 112*kScreenWidth/375, 50);
        self.detailLabel.deFrameLeft = self.titleLabel.deFrameLeft;
        self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom - 19.;
    }
}

#pragma mark - <RTLabelDelegate>
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    [[OpenCenter sharedOpenCenter] openArticleTagWithName:url.absoluteString];
}

@end
