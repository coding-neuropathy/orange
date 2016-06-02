//
//  DiscoverBannerView.m
//  orange
//
//  Created by 谢家欣 on 15/7/27.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverBannerView.h"
#import "UIScrollView+AutoScroll.h"
#import "iCarousel.h"
//@interface DiscoverBannerView () <UIScrollViewDelegate>
//
//@property (strong, nonatomic) UIScrollView * bannerScrollView;
//
//@end

@interface DiscoverBannerView ()<iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) iCarousel * bannerView;

@end

@implementation DiscoverBannerView

- (iCarousel *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[iCarousel alloc] initWithFrame:CGRectZero];
        _bannerView.type = iCarouselTypeLinear;
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bannerView.pagingEnabled = IS_IPAD ? NO : YES;
        _bannerView.autoscroll = IS_IPAD ? 0.0 : 0.3;
        [self addSubview:_bannerView];
    }
    
    return _bannerView;
}


- (void)setBannerArray:(NSMutableArray *)bannerArray
{
    _bannerArray = bannerArray;
    [self.bannerView reloadData];
    [self setNeedsLayout];
}

#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.bannerArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = UIColorFromRGB(0xF6F6F6);
        view.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    if (IS_IPAD) {
        view.frame = CGRectMake(0.f, 0.f, 630.f/1.37, 280.f/1.37);
    } else {
        view.frame = CGRectMake(0., 0., self.deFrameWidth, 145 * self.deFrameWidth / 320);
    }
    
    NSURL *imageURL = self.bannerArray[index][@"img"];
    [((UIImageView *)view) sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:view.frame.size]];
    
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return IS_IPAD ? value * 1.03f : value;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.bannerView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark - <iCarouselDelegate>
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    DDLogInfo(@"%@", [self.bannerArray objectAtIndex:index]);
    NSDictionary * dict = [self.bannerArray objectAtIndex:index];
    NSString *urlString = [dict valueForKey:@"url"];
    if ([urlString hasPrefix:@"http://"]) {
        //        if (k_isLogin) {
        //            NSRange range = [url rangeOfString:@"?"];
        //            if (range.location != NSNotFound) {
        //                url = [url stringByAppendingString:[NSString stringWithFormat:@"&session=%@",[Passport sharedInstance].session]];
        //            }
        //            else
        //            {
        //                url = [url stringByAppendingString:[NSString stringWithFormat:@"?session=%@",[Passport sharedInstance].session]];
        //            }
        //        }
        NSRange range = [urlString rangeOfString:@"out_link"];
        if (range.location == NSNotFound) {
            [[OpenCenter sharedOpenCenter] openWebWithURL:[NSURL URLWithString:urlString]];
            return;
        }
    } else if ([urlString hasPrefix:@"guoku://entity/"]) {
        NSString *entityId = [urlString substringFromIndex:15];
        GKEntity *entity = [GKEntity modelFromDictionary:@{@"entityId":entityId}];
        [[OpenCenter sharedOpenCenter] openEntity:entity];
    }
}

#pragma mark - Life Cycle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPAD) {
    
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
            self.bannerView.frame = CGRectMake(0, 10., kScreenWidth - kTabBarWidth, 205.);
        } else {
            self.bannerView.frame = CGRectMake(0., 10., kScreenWidth - kTabBarWidth, 205.);
        }
    } else {
        self.bannerView.frame = CGRectMake(0., 0., self.deFrameWidth, 145 * self.deFrameWidth / 320);
    }
}

//- (UIScrollView *)bannerScrollView
//{
//    if (!_bannerScrollView) {
//        _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//        _bannerScrollView.backgroundColor = [UIColor whiteColor];
//        _bannerScrollView.showsHorizontalScrollIndicator = NO;
//        _bannerScrollView.pagingEnabled = YES;
//        _bannerScrollView.scrollsToTop = NO;
//        _bannerScrollView.delegate = self;
//        [self addSubview:_bannerScrollView];
//    }
//    return _bannerScrollView;
//}
//
//- (void)addImageWithObj:(NSDictionary *)dict atPosition:(NSInteger)position
//{
//    NSURL *imageURL = [NSURL URLWithString:[dict valueForKey:@"img"]];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//
//    imageView.frame = CGRectMake(position * (self.deFrameWidth), 0, self.deFrameWidth, 145 * self.deFrameWidth / 320);
//    
//    //    BCMAd * ad = [_ADList objectAtIndex:position];
//    imageView.userInteractionEnabled = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.backgroundColor = UIColorFromRGB(0xf1f1f1);
//    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [imageView addGestureRecognizer:singleTap];
//    //    [imageView setContentMode:UIViewContentModeScaleAspectFit];
//    imageView.tag = position;
//    [imageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed];
//    //    [imageView setImageWithURL:ad.thumb_filename];
//    [self.bannerScrollView addSubview:imageView];
//}
//
//
//- (void)setBannerArray:(NSArray *)bannerArray
//{
//    _bannerArray = bannerArray;
//    
//    for (UIView *view in self.bannerScrollView.subviews) {
//        if ([view isKindOfClass:[UIImageView class]] && view.tag == 100) {
//            [view removeFromSuperview];
//        }
//    }
//    
//    self.bannerScrollView.backgroundColor = UIColorFromRGB(0xf1f1f1);
//    NSDictionary *banner_last = [bannerArray objectAtIndex:_bannerArray.count - 1];
//    [self addImageWithObj:banner_last atPosition:0];
//    [self.bannerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary *dict = (NSDictionary *)obj;
//        [self addImageWithObj:dict atPosition:idx +1];
//    }];
//    NSDictionary *banner_first = [bannerArray objectAtIndex:0];
//    [self addImageWithObj:banner_first atPosition:_bannerArray.count + 1];
//    
//    
//    self.bannerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bannerScrollView.frame) * (self.bannerArray.count + 2.), CGRectGetHeight(self.bannerScrollView.frame));
//    [self setNeedsLayout];
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    //    self.bannerScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-32);
//    self.bannerScrollView.frame = CGRectMake(0., 0., self.deFrameWidth, 145 * self.deFrameWidth / 320);
//    [self.bannerScrollView scrollRectToVisible:CGRectMake(self.bannerScrollView.frame.size.width, 0, self.bannerScrollView.frame.size.width, self.bannerScrollView.frame.size.width) animated:NO];
//    [self.bannerScrollView startScrolling];
//}
//
//#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    [scrollView stopScrolling];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    //    NSLog(@"scrollview %@", scrollView);
//    // The key is repositioning without animation
//    if (scrollView.contentOffset.x == 0) {
//        // user is scrolling to the left from image 1 to image 4
//        // reposition offset to show image 4 that is on the right in the scroll view
//        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width * [self.bannerArray count], 0, scrollView.frame.size.width, scrollView.frame.size.width) animated:NO];
//    }
//    else if (scrollView.contentOffset.x == scrollView.frame.size.width * ([self.bannerArray count] + 1) ) {
//        // user is scrolling to the right from image 4 to image 1
//        // reposition offset to show image 1 that is on the left in the scroll view
//        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
//    }
//    
//    
//    [scrollView startScrolling];
//}
//
//#pragma mark - tap banner action
//- (void)handleTap:(id)sender
//{
//    [self.bannerScrollView stopScrolling];
//    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
//    NSInteger index = [singleTap view].tag;
//    if (index == 0) {
//        index = self.bannerArray.count - 1;
//    } else if (index == self.bannerArray.count + 1) {
//        index = 0;
//    } else {
//        index -= 1;
//    }
//    //    NSLog(@"index index %lu", index);
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(TapBannerImageAction:)]) {
//        [_delegate TapBannerImageAction:[self.bannerArray objectAtIndex:index]];
//    }
//    
//}

@end
