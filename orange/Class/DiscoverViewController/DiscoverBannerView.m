//
//  DiscoverBannerView.m
//  orange
//
//  Created by 谢家欣 on 15/7/27.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "DiscoverBannerView.h"
#import "UIScrollView+AutoScroll.h"
//#import "iCarousel.h"
#import "BannerCarousel.h"


@interface DiscoverBannerView ()<iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) BannerCarousel * bannerView;

@end

@implementation DiscoverBannerView

- (void)dealloc
{
    if (IS_IPHONE) [self.bannerView disableAutoscroll];
}

- (iCarousel *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[BannerCarousel alloc] initWithFrame:CGRectZero];
        _bannerView.type = iCarouselTypeLinear;
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bannerView.pagingEnabled = IS_IPAD ? NO : YES;
//        _bannerView.autoscroll = IS_IPAD ? 0.0 : 0.3;
        if (IS_IPHONE) [_bannerView enableAutoscroll];
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
    [((UIImageView *)view) sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:view.frame.size]];
    
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
    
   
    [MobClick event:@"banner" attributes:@{@"url": urlString}];
    
    if ([dict objectForKey:@"article"]) {
        GKArticle * article = [GKArticle modelFromDictionary:dict[@"article"]];
        [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
        return;
    }
    
    if ([urlString hasPrefix:@"http://"]) {
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

@end
