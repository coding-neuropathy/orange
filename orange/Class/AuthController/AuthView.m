//
//  AuthView.m
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "AuthView.h"
#import "RTLabel.h"

@interface AuthView () <RTLabelDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIButton * dismissBtn;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIPageControl * pageCtl;
@property (strong, nonatomic) UIButton * signInBtn;
@property (strong, nonatomic) UIButton * signUpBtn;
@property (strong, nonatomic) RTLabel * agreementLabel;

@end

@implementation AuthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

#pragma mark - lazy load view
- (UIButton *)dismissBtn
{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setImage:[UIImage imageNamed:@"close-dark"] forState:UIControlStateNormal];
        
        [_dismissBtn addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_dismissBtn];
    }
    return _dismissBtn;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
//        _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 360. * kScreeenScale);
        for (int i = 0; i < 3; i ++) {
            UIImageView * introView = [[UIImageView alloc] initWithFrame:CGRectMake(360 * kScreeenScale * i, 0., kScreenWidth, 360. * kScreeenScale)];
            introView.image = [UIImage imageNamed:[NSString stringWithFormat:@"auth-%d", i + 1]];
            introView.contentMode = UIViewContentModeScaleAspectFill;
            introView.layer.masksToBounds = YES;
            [_scrollView addSubview:introView];
        }
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageCtl
{
    if (!_pageCtl) {
        _pageCtl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        //        _pageCtr.hidden = YES;
        _pageCtl.currentPage = 0;
        _pageCtl.backgroundColor = [UIColor clearColor];
        _pageCtl.pageIndicatorTintColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.26];
        _pageCtl.currentPageIndicatorTintColor = UIColorFromRGB(0x6192ff);
        //        _pageCtr.layer.cornerRadius = 16.0;
        _pageCtl.numberOfPages = 3;
        _pageCtl.currentPage = 0;
        [self addSubview:_pageCtl];
    }
    
    return _pageCtl;
}

- (UIButton *)signInBtn
{
    if (!_signInBtn) {
        _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signInBtn.layer.masksToBounds = YES;
        _signInBtn.layer.borderColor = UIColorFromRGB(0x6192ff).CGColor;
        _signInBtn.layer.borderWidth = 0.5;
        _signInBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.];
        [_signInBtn setTitle:NSLocalizedStringFromTable(@"sign in", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signInBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [_signInBtn addTarget:self action:@selector(SignInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_signInBtn];
    }
    return _signInBtn;
}

- (UIButton *)signUpBtn
{
    if (!_signUpBtn) {
        _signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signUpBtn.layer.masksToBounds = YES;
        _signUpBtn.layer.borderColor = UIColorFromRGB(0x6192ff).CGColor;
        _signUpBtn.layer.borderWidth = 0.5;
        _signUpBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.];
        [_signUpBtn setTitle:NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_signUpBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [_signUpBtn addTarget:self action:@selector(SignUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_signUpBtn];
    }
    return _signUpBtn;
}

- (RTLabel *)agreementLabel
{
    if (!_agreementLabel) {
        _agreementLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
        _agreementLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.];
        
        
        [self addSubview:_agreementLabel];
    }
    
    return _agreementLabel;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dismissBtn.frame = CGRectMake(0., 0., 32., 32.);
    self.dismissBtn.deFrameTop = 16.;
    self.dismissBtn.deFrameRight = self.deFrameWidth - 16.;
    
    self.scrollView.frame = CGRectMake(0., 0., kScreenWidth, 360. * kScreeenScale);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 360. * kScreeenScale);
    self.scrollView.deFrameTop = 64.;
    
    self.pageCtl.bounds = CGRectMake(0.0, 0.0, 8 * (self.pageCtl.numberOfPages - 1) + 8, 8);
    self.pageCtl.center = CGPointMake(kScreenWidth / 2., self.scrollView.deFrameBottom + 18.);
    
    
    self.signInBtn.frame = CGRectMake(0., 0., 230. * kScreeenScale, 44. * kScreeenScale);
    self.signInBtn.layer.cornerRadius = self.signInBtn.deFrameHeight / 2.;
    self.signInBtn.deFrameTop = self.scrollView.deFrameBottom + 44.;
    self.signInBtn.deFrameLeft = (self.deFrameWidth - self.signInBtn.deFrameWidth) / 2.;
    
    self.signUpBtn.frame = CGRectMake(0., 0., 230. * kScreeenScale, 44. * kScreeenScale);
    self.signUpBtn.layer.cornerRadius = self.signUpBtn.deFrameHeight / 2.;
    self.signUpBtn.center = self.signInBtn.center;
    self.signUpBtn.deFrameTop = self.signInBtn.deFrameBottom + 8.;
    
    
}

#pragma mark - button action
- (void)dismissBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapDismissButton)]) {
        [_delegate tapDismissButton];
    }
}

- (void)SignInBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignInButton:)]) {
        [_delegate tapSignInButton:sender];
    }
}

- (void)SignUpBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignUpButton:)]) {
        [_delegate tapSignUpButton:sender];
    }
}

#pragma mark - <RTLabelDelegate>
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    DDLogInfo(@"url %@", url.absoluteString);
    
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.pageCtl.currentPage = index;
}


@end
