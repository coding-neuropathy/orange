//
//  ArticleResultCell.m
//  orange
//
//  Created by D_Collin on 16/7/12.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticleResultCell.h"

@interface ArticleResultCell ()

@property (strong, nonatomic) UIImageView * coverImageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * tipLabel;
@end

@implementation ArticleResultCell

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
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_coverImageView];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        _titleLabel.textColor = UIColorFromRGB(0x212121);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel)
    {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
//        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        _tipLabel.backgroundColor = [UIColor clearColor];
//        _tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _tipLabel.textColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.26];
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    self.titleLabel.text = _article.title;

    [self.tipLabel setText:[NSString stringWithFormat:@"%@ %ld  %@ 0",
                            [NSString fontAwesomeIconStringForEnum:FAThumbsOUp],
                            _article.dig_count,[NSString fontAwesomeIconStringForEnum:FAComment]]];
    
     //  设置图片
    [self.coverImageView sd_setImageWithURL:_article.coverURL
                           placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(90., 90.)]];
    
    
    [self setNeedsLayout];
    //    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
#pragma mark - layout iphone
    
    self.coverImageView.frame = CGRectMake(0., 0., 90., 90.);
    self.coverImageView.deFrameTop = 12.;
    self.coverImageView.deFrameLeft = 12.;

    self.titleLabel.frame = CGRectMake(0., 0., self.contentView.deFrameWidth - (self.coverImageView.deFrameRight + 12. * 2.), 40.);
    self.titleLabel.deFrameTop = 18.;
    self.titleLabel.deFrameLeft = self.coverImageView.deFrameRight + 12;
    
    self.tipLabel.frame = CGRectMake(0., 0., 80., 10.);
//    self.tipLabel.deFrameTop = self.frame.size.height - 20;
    self.tipLabel.deFrameRight = self.contentView.deFrameRight - 12.;
    self.tipLabel.deFrameBottom = self.contentView.deFrameBottom - 19.;

}

@end
