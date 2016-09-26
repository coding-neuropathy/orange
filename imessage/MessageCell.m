//
//  MessageCell.m
//  orange
//
//  Created by 谢家欣 on 16/9/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (strong, nonatomic) UIImageView   *coverImageView;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView                     = [[UIImageView alloc] init];
        _coverImageView.deFrameSize         = CGSizeMake(self.contentView.deFrameHeight - 10., self.contentView.deFrameHeight - 10.);
        _coverImageView.contentMode         = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_coverImageView];
    }
    return _coverImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArticle:(GKArticle *)article
{
    _article    = article;

    self.textLabel.text             = _article.title;
    
    self.textLabel.font             = [UIFont systemFontOfSize:16.];
    self.textLabel.textColor        = [UIColor colorFromHexString:@"#212121"];
    self.textLabel.textAlignment    = NSTextAlignmentLeft;
    self.textLabel.numberOfLines    = 2;
    self.textLabel.lineBreakMode    = NSLineBreakByTruncatingTail;
    
    self.detailTextLabel.text           = _article.digest;
    self.detailTextLabel.textAlignment  = NSTextAlignmentLeft;
    self.detailTextLabel.textColor      = [UIColor colorFromHexString:@"#9d9e9f"];
    self.detailTextLabel.font           = [UIFont systemFontOfSize:14.];
    self.detailTextLabel.numberOfLines  = 3.;
    self.detailTextLabel.lineBreakMode  = NSLineBreakByTruncatingTail;
    
    
//    [self.coverImageView sd_setImageWithURL:_article.coverURL_300
//                           placeholderImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f1f1f1"] andSize:self.coverImageView.deFrameSize]
//                                    options:SDWebImageRetryFailed];
    [self.coverImageView sd_setImageWithURL:_article.coverURL_300
                           placeholderImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f1f1f1"] andSize:self.coverImageView.deFrameSize]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (!error) {
                                          self.coverImage   = image;
                                      }
                           }];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.deFrameTop  = 5.;
    self.coverImageView.deFrameLeft = 5.;
    
    self.textLabel.deFrameSize  = CGSizeMake(self.contentView.deFrameWidth - self.coverImageView.deFrameRight - 20., 40.);
    self.textLabel.deFrameTop   = 10.;
    self.textLabel.deFrameLeft  = self.coverImageView.deFrameRight + 10.;
    
//    self.detailTextLabel.center     = self.textLabel.center;
    self.detailTextLabel.deFrameTop = self.textLabel.deFrameBottom + 5.;
    self.detailTextLabel.deFrameLeft  = self.coverImageView.deFrameRight + 10.;

    
//    self.imageView
//    self.imageView.frame    = CGRectMake(5., 5., self.contentView.frame.size.height - 10, self.contentView.frame.size.height - 10);
}

@end
