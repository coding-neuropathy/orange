//
//  EntityHeaderView.m
//  orange
//
//  Created by 谢家欣 on 15/3/12.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityHeaderView.h"

@interface EntityHeaderView () <UIScrollViewDelegate>
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIPageControl * pageCtr;
@property (strong, nonatomic) UIButton * likeBtn;
@property (strong, nonatomic) UIButton * buyBtn;

@end

@implementation EntityHeaderView

@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
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
        _pageCtr.pageIndicatorTintColor = UIColorFromRGB(0xbbbcbd);
        _pageCtr.currentPageIndicatorTintColor = UIColorFromRGB(0x414243);
        _pageCtr.layer.cornerRadius = 10.0;
        [self addSubview:_pageCtr];
    }
    
    return _pageCtr;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.layer.cornerRadius = 2;
        _likeBtn.backgroundColor = [UIColor clearColor];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        _likeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_likeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_likeBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateSelected];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateHighlighted|UIControlStateSelected];
        [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [_likeBtn addTarget:self action:@selector(TapLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)buyBtn
{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.layer.masksToBounds = YES;
//        _buyBtn.layer.cornerRadius = 2;
        _buyBtn.backgroundColor = UIColorFromRGB(0x427ec0);
        _buyBtn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:16.f];
        [_buyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [_buyBtn addTarget:self action:@selector(TapBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
//    NSLog(@"images %@", _entity.imageURLArray);
    
    if((![_entity.brand isEqual:[NSNull null]])&&(![_entity.brand isEqualToString:@""])&&(_entity.brand))
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", _entity.brand, _entity.title];
    }
    if((![_entity.title isEqual:[NSNull null]])&&(_entity.title))
    {
        self.titleLabel.text = _entity.title;
    }
    
    
    self.scrollView.contentSize = CGSizeMake((kScreenWidth - 20) * ([_entity.imageURLArray count] + 1), kScreenWidth - 20);
    
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithArray:_entity.imageURLArray copyItems:YES];
    
    [imageArray insertObject:_entity.imageURL atIndex:0];
    
//    NSLog(@"images %@", imageArray);
    [imageArray enumerateObjectsUsingBlock:^(NSURL *imageURL, NSUInteger idx, BOOL *stop) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0. + (kScreenWidth - 20) * idx, 0., kScreenWidth - 20., kScreenWidth - 20.)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageurl a]
        NSURL * imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
        
        [imageView sd_setImageWithURL:imageURL_640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth -20, kScreenWidth -20)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
        [self.scrollView addSubview:imageView];
        
    }];
    
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"喜爱 %lu", _entity.likeCount] forState:UIControlStateNormal];
    if(_entity.likeCount == 0)
    {
        [self.likeBtn setTitle:[NSString stringWithFormat:@"喜爱"] forState:UIControlStateNormal];
    }
    self.likeBtn.selected = _entity.liked;
    [self.buyBtn setTitle:[NSString stringWithFormat:@"¥ %0.2f", _entity.lowestPrice] forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 25.);
    self.scrollView.frame = CGRectMake(10., 51., kScreenWidth - 20., kScreenWidth - 20.);
    
    if ([_entity.imageURLArray count] > 0) {
        
        self.pageCtr.numberOfPages = [_entity.imageURLArray count] + 1;
        self.pageCtr.center = CGPointMake(self.scrollView.frame.size.width / 2., self.scrollView.frame.size.height + 15.);
        self.pageCtr.bounds = CGRectMake(0.0, 0.0, 20 * (_pageCtr.numberOfPages - 1) + 20, 20);
        self.pageCtr.hidden = NO;
    }
    
    self.likeBtn.frame = CGRectMake(0, 0, 120, 36);
    self.likeBtn.deFrameLeft = 10.;
    self.likeBtn.deFrameTop = self.scrollView.deFrameBottom + 15.;
    
    self.buyBtn.frame = CGRectMake(0, 0, 120, 36);
    self.buyBtn.deFrameRight= kScreenWidth - 10.;
    self.buyBtn.deFrameTop = self.scrollView.deFrameBottom + 15.;

}

#pragma mark - button action
- (void)TapLikeBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapLikeBtnAction:)]) {
        [_delegate TapLikeBtnAction:sender];
    }
}

- (void)TapBuyBtn:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapBuyBtnAction:)]) {
        [_delegate TapBuyBtnAction:sender];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageCtr.currentPage = index;
}

@end
