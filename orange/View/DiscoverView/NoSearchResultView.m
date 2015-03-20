//
//  NoSearchResultView.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NoSearchResultView.h"

@implementation NoSearchResultView


- (void)setType:(EmptyType)type
{
    _type = type;
    self.titleLabel.text = @"搜索无结果";
    self.detailLabel.text = @"没有找到任何相关商品/标签/用户，\n不妨换个关键词试试";
    
    UIImage * noticImage = [UIImage imageNamed:@"empty_SR.png"];
    self.noticImageView.image = noticImage;

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noticImageView.frame = CGRectMake((kScreenWidth - self.noticImageView.image.size.width) / 2, 0., self.noticImageView.image.size.width, self.noticImageView.image.size.width);
    self.noticImageView.deFrameTop = 60.;
    
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 20.);
    self.titleLabel.font = [UIFont systemFontOfSize:16.];
    self.titleLabel.textColor = UIColorFromRGB(0x414243);;
    self.titleLabel.deFrameTop = self.noticImageView.frame.origin.y + self.noticImageView.frame.size.height + 40.;
    
    self.detailLabel.frame = CGRectMake(0., 40., kScreenWidth, 40.);
    self.detailLabel.deFrameTop = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10.;
}

@end
