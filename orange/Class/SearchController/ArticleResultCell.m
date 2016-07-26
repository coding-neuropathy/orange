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
        
        [self.contentView addSubview:_coverImageView];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
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
        _tipLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        _tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (void)setArticle:(GKArticle *)article
{
    _article = article;
    
    self.titleLabel.text = _article.title;
    
    [self.tipLabel setText:[NSString stringWithFormat:@"%@ %ld  %@ 0",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp],self.article.dig_count,[NSString fontAwesomeIconStringForEnum:FAComment]]];
    
    /**
     *  设置图片
     */
    [self.coverImageView sd_setImageWithURL:_article.coverURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(kScreenWidth -32, (kScreenWidth - 32) / 1.8)]];
    
    
    [self setNeedsLayout];
    //    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
#pragma mark - layout iphone
    
    self.tipLabel.frame = CGRectMake(0., 0., 80., 10.);
    self.tipLabel.deFrameTop = self.frame.size.height - 20;
    self.tipLabel.deFrameRight = self.frame.size.width - 10;
    
    self.coverImageView.frame = CGRectMake(0., 0., 112*kScreenWidth/375, 84*kScreenWidth/375);
    self.coverImageView.deFrameTop = 16.;
    self.coverImageView.deFrameLeft = self.contentView.deFrameLeft + 16;
    
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 48 - 112*kScreenWidth/375, self.contentView.deFrameHeight - 32.);
    self.titleLabel.deFrameTop = -5.;
    self.titleLabel.deFrameLeft = self.coverImageView.deFrameRight + 12;
    

}

@end
