//
//  LaunchView.m
//  orange
//
//  Created by 谢家欣 on 15/11/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()

@property (strong, nonatomic) UIImageView * launchImage;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detialLable;
@property (strong, nonatomic) UIButton * actionBtn;
@property (strong, nonatomic) UIButton * closeBtn;

@end

@implementation LaunchView

- (UIImageView *)launchImage
{
    if (!_launchImage) {
        _launchImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _launchImage.contentMode = UIViewContentModeScaleAspectFill;
        _launchImage.layer.masksToBounds = YES;
//        _launchImage.layer.cornerRadius = 4.;
        [self addSubview:_launchImage];
    }
    return _launchImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:20.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detialLable
{
    if (!_detialLable) {
        _detialLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _detialLable.font = [UIFont systemFontOfSize:14.];
        _detialLable.textColor = UIColorFromRGB(0x9d9e9f);
        _detialLable.textAlignment = NSTextAlignmentCenter;
        _detialLable.numberOfLines = 2;
        
        [self addSubview:_detialLable];
    }
    return _detialLable;
}

- (UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionBtn setBackgroundColor:UIColorFromRGB(0x6eaaf0)];
        _actionBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        [_actionBtn setTitle:[NSString stringWithFormat:@"即刻体验 %@", [NSString fontAwesomeIconStringForEnum:FAArrowCircleORight]] forState:UIControlStateNormal];
        [_actionBtn addTarget:self action:@selector(TapActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionBtn];
    }
    return _actionBtn;
}

- (void)setLaunch:(GKLaunch *)launch
{
    _launch = launch;
    
    [self.launchImage sd_setImageWithURL:_launch.launchImageUrl];
    self.titleLabel.text = _launch.title;
    self.detialLable.text = _launch.desc;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.launchImage.frame = CGRectMake(0., 0., 290, 240.);
    
    self.titleLabel.frame = CGRectMake(0., 0., self.deFrameWidth, 24.);
    self.titleLabel.deFrameTop = 50;
    
    self.detialLable.frame = CGRectMake(0., 0., self.deFrameWidth, 50);
    self.detialLable.deFrameTop = self.titleLabel.deFrameBottom + 10.;
    
    self.launchImage.frame = CGRectMake(0., 0., self.deFrameWidth, 240.);
    self.launchImage.deFrameTop = self.detialLable.deFrameBottom;
    
    self.actionBtn.frame = CGRectMake(0., 0., self.deFrameWidth, 50.);
    self.actionBtn.deFrameTop = self.deFrameHeight - 50.;
}

#pragma mark - button action 
- (void)TapActionBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleActionBtn:)]) {
        [_delegate handleActionBtn:sender];
    }
}

@end
