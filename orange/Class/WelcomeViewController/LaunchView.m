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
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UIButton * actionBtn;
@property (strong, nonatomic) UIButton * closeBtn;

@end

@implementation LaunchView

- (UIImageView *)launchImage
{
    if (!_launchImage) {
        _launchImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _launchImage.contentMode = UIViewContentModeScaleAspectFill;
        _launchImage.layer.cornerRadius = 4.;
        _launchImage.layer.masksToBounds = YES;
        _launchImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapActionBtn:)];
        [self.launchImage addGestureRecognizer:tap];
//        _launchImage.backgroundColor = UIColorFromRGB(0xf1f1f1);
//        _launchImage.layer.cornerRadius = 4.;
        [self addSubview:_launchImage];
    }
    return _launchImage;
}

//- (UILabel *)titleLabel
//{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.font = [UIFont systemFontOfSize:20.];
//        _titleLabel.textColor = UIColorFromRGB(0x414243);
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:_titleLabel];
//    }
//    return _titleLabel;
//}

//- (UILabel *)detailLabel
//{
//    if (!_detailLabel) {
//        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _detailLabel.font = [UIFont systemFontOfSize:14.];
//        _detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
//        _detailLabel.textAlignment = NSTextAlignmentCenter;
//        _detailLabel.numberOfLines = 2;
//        
//        [self addSubview:_detailLabel];
//    }
//    return _detailLabel;
//}

//- (UIButton *)actionBtn
//{
//    if (!_actionBtn) {
//        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_actionBtn setBackgroundColor:UIColorFromRGB(0x6eaaf0)];
//        _actionBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
//
//        [_actionBtn addTarget:self action:@selector(TapActionBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_actionBtn];
//    }
//    return _actionBtn;
//}

- (void)setLaunch:(GKLaunch *)launch
{
    _launch = launch;
    
    [self.launchImage sd_setImageWithURL:_launch.launchImageURL_580];
//    self.titleLabel.text = _launch.title;
//    self.detailLabel.text = _launch.desc;
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7.];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
//    self.detailLabel.attributedText = attributedString;
//    
//    [self.actionBtn setTitle:[NSString stringWithFormat:@"%@ %@", _launch.action_title, [NSString fontAwesomeIconStringForEnum:FAArrowCircleORight]] forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.launchImage.frame = CGRectMake(0., 0., 290, 240.);
    
//    self.titleLabel.frame = CGRectMake(0., 0., self.deFrameWidth, 24.);
//    self.titleLabel.deFrameTop = 50;
//    
//    self.detailLabel.frame = CGRectMake(25., 0., self.deFrameWidth - 50., 60);
//    self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom + 10.;
    

    
//    self.actionBtn.frame = CGRectMake(0., 0., self.deFrameWidth, 50.);
//    self.actionBtn.deFrameTop = self.deFrameHeight - 50.;
    
    self.launchImage.frame = CGRectMake(0., 0., kScreenWidth * 0.8, kScreenWidth * 0.8 * 4 / 3);
//    self.launchImage.deFrameBottom = self.actionBtn.deFrameTop;
    
}

#pragma mark - button action 
- (void)TapActionBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleActionBtn:)]) {
        [_delegate handleActionBtn:sender];
    }
}

@end
