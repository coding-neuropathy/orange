//
//  EntityPopView.m
//  orange
//
//  Created by 谢家欣 on 15/8/23.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityPopView.h"

@interface EntityPopView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIPageControl * pageCtr;
@property (strong, nonatomic) UIButton * closeBtn;

@end

@implementation EntityPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0x111111);
    }
    return self;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16.];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenWidth)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageCtr
{
    if (!_pageCtr) {
        _pageCtr = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageCtr.hidden = YES;
        _pageCtr.currentPage = 0;
        _pageCtr.backgroundColor = [UIColor clearColor];
        _pageCtr.pageIndicatorTintColor = UIColorFromRGB(0x656768);
        _pageCtr.currentPageIndicatorTintColor = UIColorFromRGB(0xffffff);
        _pageCtr.layer.cornerRadius = 16.0;
        [self addSubview:_pageCtr];
    }
    
    return _pageCtr;
}


- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    self.scrollView.contentSize = CGSizeMake((kScreenWidth) * ([_entity.imageURLArray count] + 1), kScreenWidth);
    
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithArray:_entity.imageURLArray copyItems:YES];
    
    if (_entity.imageURL)
        [imageArray insertObject:_entity.imageURL atIndex:0];
    
    [imageArray enumerateObjectsUsingBlock:^(NSURL *imageURL, NSUInteger idx, BOOL *stop) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0. + (kScreenWidth) * idx, 0., kScreenWidth, kScreenWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (IS_IPHONE_6P) {
            NSURL * imageURL_800;
            if ([imageURL.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
                imageURL_800 = [NSURL URLWithString:[imageURL.absoluteString imageURLWithSize:800]];
            } else {
                imageURL_800 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
            }
            
            [imageView sd_setImageWithURL:imageURL_800 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth, kScreenWidth)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
            //            [self.scrollView addSubview:imageView];
        } else {
            NSURL * imageURL_640;
            if ([imageURL.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
                imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString imageURLWithSize:640]];
            } else {
                imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
            }
            
            [imageView sd_setImageWithURL:imageURL_640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth, kScreenWidth)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
            
        }
        [self.scrollView addSubview:imageView];
    }];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.closeBtn.frame = CGRectMake(0., 0., 32., 32.);
    self.closeBtn.deFrameTop = 25.;
    self.closeBtn.deFrameRight = kScreenWidth - 10;
    self.scrollView.deFrameTop = 100.;
    
    if ([_entity.imageURLArray count] > 0) {
        
        self.pageCtr.numberOfPages = [_entity.imageURLArray count] + 1;
        self.pageCtr.center = CGPointMake(kScreenWidth / 2., self.scrollView.deFrameBottom + 10.);
        self.pageCtr.bounds = CGRectMake(0.0, 0.0, 32 * (_pageCtr.numberOfPages - 1) + 32, 32);
        self.pageCtr.hidden = NO;
    }
}


#pragma mark - animation
- (void)fadeIn
{
    self.alpha = 0;
//    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(270));
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);

    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1.;
        self.transform = CGAffineTransformMakeScale(1., 1.);
//        self.bounds = CGRectMake(0.0, 0.0,kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
//        _scrollView.contentSize = CGSizeMake(self.frame.size.height * _pages, self.frame.size.width);
    }];
    
    //    DDLogInfo(@"faded in %@", self);
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - public method 
- (void)showInWindowWithAnimated:(BOOL)animated
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    if(animated)
    {
        [self fadeIn];
    }
}

#pragma mark - button action
- (void)closeBtnAction:(id)sender
{
    [self fadeOut];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageCtr.currentPage = index;
}

@end
