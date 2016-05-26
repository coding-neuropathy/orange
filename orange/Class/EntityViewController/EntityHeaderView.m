//
//  EntityHeaderView.m
//  orange
//
//  Created by 谢家欣 on 15/3/12.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityHeaderView.h"
#import "NSString+Helper.h"

@interface EntityHeaderView () <UIScrollViewDelegate>
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIPageControl * pageCtr;
//@property (strong, nonatomic) UIButton * likeBtn;
//@property (strong, nonatomic) UIButton * buyBtn;

@end

static CGFloat kEntityViewMarginLeft = 16.;

@implementation EntityHeaderView

@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
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
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapBuyBtn:)];
//        [_scrollView addGestureRecognizer:tap];
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
        _pageCtr.pageIndicatorTintColor = UIColorFromRGB(0xe6e6e6);
        _pageCtr.currentPageIndicatorTintColor = UIColorFromRGB(0x5ba9ff);
        _pageCtr.layer.cornerRadius = 16.0;
        [self addSubview:_pageCtr];
    }
    
    return _pageCtr;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
//    NSLog(@"images %@", _entity.imageURLArray);
    
    if((![_entity.brand isEqual:[NSNull null]])&&(![_entity.brand isEqualToString:@""])&&(_entity.brand))
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", _entity.brand, _entity.title];
    }
    else if((![_entity.title isEqual:[NSNull null]])&&(_entity.title))
    {
        self.titleLabel.text = _entity.title;
    }
    
    
    self.scrollView.contentSize = CGSizeMake((kScreenWidth - 32) * ([_entity.imageURLArray count] + 1), kScreenWidth - 32);
    
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithArray:_entity.imageURLArray copyItems:YES];
    
    if (_entity.imageURL)
        [imageArray insertObject:_entity.imageURL atIndex:0];
    
//    NSLog(@"images %@", imageArray);
    [imageArray enumerateObjectsUsingBlock:^(NSURL *imageURL, NSUInteger idx, BOOL *stop) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0. + (kScreenWidth - 32) * idx, 0., kScreenWidth - 32, kScreenWidth - 32)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = idx;
        imageView.userInteractionEnabled = YES;
//        if (IS_IPHONE_6P) {
//            NSURL * imageURL_800;
//            if ([imageURL.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
//                imageURL_800 = [NSURL URLWithString:[imageURL.absoluteString imageURLWithSize:800]];
//            } else {
//                imageURL_800 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
//            }
//            
//            [imageView sd_setImageWithURL:imageURL_800 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth -32, kScreenWidth -32)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
////            [self.scrollView addSubview:imageView];
//        } else {
            NSURL * imageURL_640;
            if ([imageURL.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
                imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString imageURLWithSize:640]];
            } else {
                imageURL_640 = [NSURL URLWithString:[imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
            }
        
            [imageView sd_setImageWithURL:imageURL_640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth -32, kScreenWidth -32)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL*imageURL) {}];
            
//        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
    }];
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat titleHeight = [self.titleLabel.text heightWithLineWidth:kScreenWidth - kEntityViewMarginLeft * 2.  Font:self.titleLabel.font LineHeight:7];
    
    self.scrollView.frame = CGRectMake(0., 0., kScreenWidth - 32., kScreenWidth - 32.);
    self.scrollView.deFrameLeft = 16.;
    self.scrollView.deFrameTop =  16.;
    self.titleLabel.frame = CGRectMake(kEntityViewMarginLeft, 16. + self.scrollView.deFrameBottom, kScreenWidth - kEntityViewMarginLeft * 2., titleHeight);
    
    if ([_entity.imageURLArray count] > 0) {
        self.pageCtr.numberOfPages = [_entity.imageURLArray count] + 1;
        self.pageCtr.center = CGPointMake(kScreenWidth / 2., self.scrollView.deFrameBottom -10);
        self.pageCtr.bounds = CGRectMake(0.0, 0.0, 32 * (_pageCtr.numberOfPages - 1) + 32, 32);
        self.pageCtr.hidden = NO;
    }
}

#pragma mark - button action
- (void)tapAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handelTapImageWithIndex:)])
    {
        [_delegate handelTapImageWithIndex:[(UIGestureRecognizer *)sender view].tag];
    }
}


#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageCtr.currentPage = index;
}

#pragma mark - class method
+ (CGFloat)headerViewHightWithEntity:(GKEntity *)entity
{
    CGFloat titleHeight = [entity.entityName heightWithLineWidth:kScreenWidth - kEntityViewMarginLeft * 2.  Font:[UIFont systemFontOfSize:16.f] LineHeight:7];
    if (titleHeight == 0 ) {
        titleHeight = 16.;
    }
    return kScreenWidth + titleHeight + 16.;
}

@end
