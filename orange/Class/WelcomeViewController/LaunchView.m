//
//  LaunchView.m
//  orange
//
//  Created by 谢家欣 on 15/11/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()

@property (strong, nonatomic) UIImageView *launchImage;
@property (strong, nonatomic) UIImageView *logoImageView;

//@property (strong, nonatomic) UILabel * titleLabel;
//@property (strong, nonatomic) UILabel * detailLabel;
//@property (strong, nonatomic) UIButton * actionBtn;
@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation LaunchView

- (UIImageView *)launchImage
{
    if (!_launchImage) {
        _launchImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _launchImage.deFrameSize    = IS_IPAD ? self.deFrameSize : CGSizeMake(kScreenWidth, (540. / 667.) * kScreenHeight);
        _launchImage.contentMode = UIViewContentModeScaleAspectFill;
        _launchImage.layer.cornerRadius = 4.;
        _launchImage.layer.masksToBounds = YES;
        _launchImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapActionBtn:)];
        [self.launchImage addGestureRecognizer:tap];
        [self addSubview:_launchImage];
    }
    return _launchImage;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.deFrameSize           = CGSizeMake(54., 30.);
        _closeBtn.backgroundColor       = [UIColor colorFromHexString:@"#f4f4f4"];
        _closeBtn.layer.cornerRadius    = _closeBtn.deFrameHeight / 2.;
        _closeBtn.layer.masksToBounds   = YES;
        
        _closeBtn.titleLabel.font       = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        
        [_closeBtn setTitle:NSLocalizedStringFromTable(@"skip", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeBtn;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView                  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _logoImageView.image            = [UIImage imageNamed:@"splash_logo"];
        _logoImageView.deFrameSize      = CGSizeMake(86., 64.);
        _logoImageView.contentMode      = UIViewContentModeScaleAspectFit;
        _logoImageView.backgroundColor  = [UIColor clearColor];
        
        [self addSubview:_logoImageView];
    }
    return _logoImageView;
}


- (void)setLaunch:(GKLaunch *)launch
{
    _launch = launch;
    
    [self.launchImage sd_setImageWithURL:_launch.launchImageURL_580];
    
    if (IS_IPHONE) {
        DDLogInfo(@"%@", self.closeBtn);
        [self insertSubview:self.closeBtn aboveSubview:self.launchImage];
//        [self addSubview:self.closeBtn];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{

    if (IS_IPHONE) {
        self.closeBtn.deFrameTop        = 24.;
        self.closeBtn.deFrameRight      = self.deFrameWidth - 24.;
        
        self.logoImageView.center           = self.launchImage.center;
        self.logoImageView.deFrameBottom    = self.deFrameBottom - 32.;
    }
    
    [super layoutSubviews];
    
}

#pragma mark - button action 
- (void)TapActionBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleActionBtn:)]) {
        [_delegate handleActionBtn:sender];
    }
}

- (void)closeBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapCloseBtn:)]) {
        [_delegate tapCloseBtn:sender];
    }
}

@end
