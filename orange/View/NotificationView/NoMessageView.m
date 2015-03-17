//
//  NoMessageView.m
//  orange
//
//  Created by 谢家欣 on 15/3/17.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NoMessageView.h"

@interface NoMessageView ()

@property (strong, nonatomic) UIImageView * noticImageView;

@end

@implementation NoMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel.text = @"没有收到任何消息";
        self.detailLabel.text = @"当有人关注你、点评你添加的商品\n或发生任何与你相关的事件时，会在这里通知你";
        
        UIImage * noticImage = [UIImage imageNamed:@"empty_notifaction.png"];
        self.noticImageView.image = noticImage;
    }
    return self;
}

- (UIImageView *)noticImageView
{
    if (!_noticImageView) {
        
        _noticImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _noticImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _noticImageView.image = noticImage;
        [self addSubview:_noticImageView];
    }
    return _noticImageView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 2;
        _detailLabel.font = [UIFont systemFontOfSize:14.];
        _detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noticImageView.frame = CGRectMake((kScreenWidth - self.noticImageView.image.size.width) / 2, 0., self.noticImageView.image.size.width, self.noticImageView.image.size.width);
    self.noticImageView.deFrameTop = 60.;
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 20.);
    self.titleLabel.deFrameTop = self.noticImageView.frame.origin.y + self.noticImageView.frame.size.height + 40.;
    self.detailLabel.frame = CGRectMake(0., 40., kScreenWidth, 40.);
    self.detailLabel.deFrameTop = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10.;
}

@end
