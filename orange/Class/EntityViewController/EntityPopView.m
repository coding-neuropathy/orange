//
//  EntityPopView.m
//  orange
//
//  Created by 谢家欣 on 15/8/23.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityPopView.h"

@interface EntityPopView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    //图片拉伸的原始倍数
    float time;
    //商品大图
    UIImageView * _imageView;
}
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIPageControl * pageCtr;
@property (strong, nonatomic) UIButton * closeBtn;

@property (strong, nonatomic) UIButton * likeBtn;
@property (strong, nonatomic) UIButton * noteBtn;
@property (strong, nonatomic) UIButton * buyBtn;

//商品大图
//@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation EntityPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0x111111);
//        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//        
//        [pan setMinimumNumberOfTouches:1];
//        [pan setMaximumNumberOfTouches:1];
//        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_closeBtn setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//        _closeBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20.];
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
        _pageCtr                                = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageCtr.hidden                         = YES;
//        _pageCtr.currentPage                    = 2;
        _pageCtr.backgroundColor                = [UIColor clearColor];
        _pageCtr.pageIndicatorTintColor         = [UIColor colorFromHexString:@"#656768"];
        _pageCtr.currentPageIndicatorTintColor  = [UIColor colorFromHexString:@"#ffffff"];
        _pageCtr.layer.cornerRadius = 16.0;
        [self addSubview:_pageCtr];
    }
    
    return _pageCtr;
}

- (UIButton *)likeBtn {
    if (!_likeBtn)
    {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"like w"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
//        _likeBtn.backgroundColor = [UIColor redColor];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 30.)];
        
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)noteBtn {
    if (!_noteBtn)
    {
        _noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noteBtn setImage:[UIImage imageNamed:@"note w"] forState:UIControlStateNormal];
        [_noteBtn setImage:[UIImage imageNamed:@"noted"] forState:UIControlStateSelected];
        _noteBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
//        _noteBtn.backgroundColor = [UIColor yellowColor];
        [_noteBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 30.)];
        [_noteBtn addTarget:self action:@selector(noteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_noteBtn];
    }
    return _noteBtn;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
        [_buyBtn setTitle:NSLocalizedStringFromTable(@"buy", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_buyBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 30.)];
        [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}

#pragma mark - set data
- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    self.scrollView.contentSize = CGSizeMake((kScreenWidth) * ([_entity.imageURLArray count] + 1), kScreenWidth);
    
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithArray:_entity.imageURLArray copyItems:YES];
    
    if (_entity.imageURL)
        [imageArray insertObject:_entity.imageURL atIndex:0];
    
    [imageArray enumerateObjectsUsingBlock:^(NSURL *imageURL, NSUInteger idx, BOOL *stop) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0. + (kScreenWidth) * idx, 0., kScreenWidth, kScreenWidth)];
        _imageView.userInteractionEnabled = YES;
        //图片显示方式
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (IS_IPHONE_6P) {
            NSURL * imageURL_800;
            if ([imageURL.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
                imageURL_800 = [NSURL URLWithString:[imageURL.absoluteString imageURLWithSize:800]];
            } else {
                imageURL_800 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
            }
            
            [_imageView sd_setImageWithURL:imageURL_800 placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:CGSizeMake(kScreenWidth, kScreenWidth)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
            //            [self.scrollView addSubview:imageView];
        } else {
            NSURL * imageURL_640;
            if ([imageURL.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
                imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString imageURLWithSize:640]];
            } else {
                imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
            }
            
            [_imageView sd_setImageWithURL:imageURL_640
                          placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:CGSizeMake(kScreenWidth, kScreenWidth)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
            
        }
        [self.scrollView addSubview:_imageView];
#pragma mark ------------添加点击图片返回以及捏合手势 ----------------------
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAmplify:)];
//        [_imageView addGestureRecognizer:tap];
//        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
//        [_imageView addGestureRecognizer:pinch];
        
    }];
    
    self.likeBtn.selected = _entity.isLiked;
    if (_entity.likeCount > 0)
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_entity.likeCount] forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

//点击图片返回手势
- (void)tapAmplify:(UITapGestureRecognizer *)tap
{
    [self fadeOut];
}
//捏合图片放大缩小手势
//- (void)pinchAction:(UIPinchGestureRecognizer *)pinch
//{
//    if (pinch.state == UIGestureRecognizerStateBegan) {
//        time = 1;
//    }
//    else if (pinch.state == UIGestureRecognizerStateChanged) {
//        _imageView.transform = CGAffineTransformMakeScale(time * pinch.scale, time * pinch.scale);
//    }
//    else if (pinch.state == UIGestureRecognizerStateEnded){
//        time*=pinch.scale;
//    }
//}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.closeBtn.frame = CGRectMake(0., 0., 32., 32.);
    self.closeBtn.deFrameTop = 25.;
    self.closeBtn.deFrameRight = kScreenWidth - 10;
    
    if (IS_IPHONE_4_OR_LESS) {
        self.scrollView.deFrameTop = 55.;
    } else if (IS_IPHONE_5) {
        self.scrollView.deFrameTop = 90.;
    } else {
        self.scrollView.deFrameTop = 100.;
    }

    if ([self.entity.imageURLArray count] > 0) {
        
        self.pageCtr.numberOfPages = [self.entity.imageURLArray count] + 1;
        self.pageCtr.center = CGPointMake(kScreenWidth / 2., self.scrollView.deFrameBottom + 10.);
        self.pageCtr.bounds = CGRectMake(0.0, 0.0, 32 * (_pageCtr.numberOfPages - 1) + 32, 32);
        self.pageCtr.hidden = NO;
    }
    
    self.likeBtn.frame = CGRectMake(0., 0., (kScreenWidth - 48. )/ 3, 36.);
    self.likeBtn.deFrameBottom = kScreenHeight - 30;
    self.likeBtn.deFrameLeft = 12.;
    
    self.noteBtn.frame = self.likeBtn.frame;
    self.noteBtn.deFrameLeft = self.likeBtn.deFrameRight + 12.;
    
    self.buyBtn.frame = self.likeBtn.frame;
    self.buyBtn.deFrameLeft = self.noteBtn.deFrameRight + 12.;
}


#pragma mark - animation
- (void)fadeIn
{
    self.alpha = 0;
//    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    self.scrollView.alpha = 0;
    self.scrollView.transform = CGAffineTransformMakeScale(0.5, 0.5);

    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1.;
        self.scrollView.transform = CGAffineTransformMakeScale(1., 1.);
    } completion:^(BOOL finished) {

    }];

}

- (void)fadeOut
{
    [UIView animateWithDuration:0.35 animations:^{
        self.scrollView.transform = CGAffineTransformMakeScale(0.5, 0.5);
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

#pragma mark - <UIGestureRecognizer>
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    
    CGPoint locationIn = [recognizer locationInView:self];
    
    DDLogInfo(@"touch location y %f x %f", locationIn.y, locationIn.x);
    if (locationIn.y < self.scrollView.deFrameTop) {
        [self fadeOut];
    }
}

#pragma mark - button action
- (void)closeBtnAction:(id)sender
{
    [self fadeOut];
}

- (void)likeBtnAction:(id)sender
{
    if (self.tapLikeBtn) {
        self.tapLikeBtn((UIButton *)sender);
        [self removeFromSuperview];
    }
    
}

- (void)noteBtnAction:(id)sender
{
    if(self.tapNoteBtn)
    {
        self.tapNoteBtn((UIButton *)sender);
        [self removeFromSuperview];
    }
    
}

- (void)buyBtnAction:(id)sender
{
    if (self.tapBuyBtn)
    {
        self.tapBuyBtn((UIButton *)sender);
        [self removeFromSuperview];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    if ([touch view] != self) {
        return NO;
    }
    return YES;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.deFrameWidth;
    self.pageCtr.currentPage = index;

}

- (void)setImageIndex:(NSInteger)idx
{
    [self.scrollView setContentOffset:CGPointMake(idx * kScreenWidth, 0.)];
    self.pageCtr.currentPage = idx + 1;
}

- (void)setNoteBtnSelected
{
    self.noteBtn.selected = YES;
}

- (void)setNoteNumber:(NSInteger)num
{
    [self.noteBtn setTitle:[NSString stringWithFormat:@"%ld", (long)num] forState:UIControlStateNormal];
}
@end
