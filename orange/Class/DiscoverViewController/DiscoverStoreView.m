//
//  DiscoverStoreView.m
//  orange
//
//  Created by 谢家欣 on 2016/10/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "DiscoverStoreView.h"
#import <iCarousel/iCarousel.h>

@interface DiscoverStoreView () <iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) UILabel   *sectionLable;
@property (strong, nonatomic) iCarousel *storeView;

@end


@implementation DiscoverStoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor colorFromHexString:@"#ffffff"];
    }
    return self;
}

- (UILabel *)sectionLable
{
    if (!_sectionLable) {
        _sectionLable               = [[UILabel alloc] initWithFrame:CGRectZero];
        _sectionLable.deFrameSize   = CGSizeMake(self.deFrameWidth - 20., 20.);
        _sectionLable.textColor     = [UIColor colorFromHexString:@"#212121"];
        _sectionLable.font          = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _sectionLable.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_sectionLable];
    }
    return _sectionLable;
}

- (iCarousel *)storeView
{
    
    if (!_storeView) {
        _storeView                  = [[iCarousel alloc] initWithFrame:CGRectZero];
        _storeView.deFrameSize      = CGSizeMake(self.deFrameWidth, 80.);
        _storeView.type             = iCarouselTypeLinear;
        _storeView.delegate         = self;
        _storeView.dataSource       = self;
        _storeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _storeView.backgroundColor  = [UIColor redColor];
//        _storeView.pagingEnabled    = IS_IPAD ? NO : YES;
    //        _bannerView.autoscroll = IS_IPAD ? 0.0 : 0.3;
//    if (IS_IPHONE) [_bannerView enableAutoscroll];
        [self addSubview:_storeView];
    }
    
    return _storeView;
}

- (void)setStores:(NSArray *)stores
{
    _stores                 = stores;
    self.sectionLable.text  = NSLocalizedStringFromTable(@"guoku-shops", kLocalizedFile, nil);
    
    [self.storeView reloadData];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.sectionLable.deFrameTop    = 15.;
    self.sectionLable.deFrameLeft   = 10.;
    
    self.storeView.deFrameTop       = self.sectionLable.deFrameBottom + 16.;
    self.storeView.deFrameLeft      = 0.;
}

- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 0., 0.);
    CGContextAddLineToPoint(context, self.deFrameWidth, 0.);
    
    CGContextStrokePath(context);
    
}

#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.stores.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    GKOfflineStore * store = [self.stores objectAtIndex:index];
    
    if (!view) {
        view                        = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.deFrameSize            = CGSizeMake(self.deFrameWidth / 2., 80.);
        view.backgroundColor        = [UIColor colorFromHexString:@"#f6f6f6"];
        view.contentMode            = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius     = 4.;
        view.layer.masksToBounds    = YES;

        UIImageView *maskView       = [[UIImageView alloc] initWithFrame:view.frame];
        maskView.image              = [UIImage imageWithColor:[UIColor colorFromHexString:@"#000000"]
                                                      andSize:maskView.deFrameSize];
        maskView.alpha              = 0.5;
        
        [view addSubview:maskView];
        
//        [(UIImageView *)view setImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.] andSize:view.deFrameSize]];
        UILabel *storelable         = [[UILabel alloc] initWithFrame:CGRectZero];
        storelable.font             = [UIFont boldSystemFontOfSize:14.];
        storelable.text             = store.storeName;
        storelable.textColor        = [UIColor colorFromHexString:@"#ffffff"];
        storelable.deFrameSize      = CGSizeMake(self.deFrameWidth / 2., 20.);
        storelable.textAlignment    = NSTextAlignmentCenter;
        storelable.center           = view.center;
        
        [view addSubview:storelable];
//        view.layer.borderColor = [UIColor colorFromHexString:@"#ebebeb"].CGColor;
//        view.layer.borderWidth = 0.5;
    }
    
    DDLogInfo(@"store image url %@", store.storeImageURL_300);
    [((UIImageView *)view) sd_setImageWithURL:store.storeImageURL_300
                             placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:view.frame.size]];
    view.deFrameTop = 0.;
//    view.deFrameLeft = 0.;
    
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
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.storeView.type == iCarouselTypeCustom)
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
    GKOfflineStore  *store  = [self.stores objectAtIndex:index];
//    DDLogInfo(@"store url %@", store.storeLink);
    if (self.tapStoreImage) {
        self.tapStoreImage(store.storeLink);
    }
}


@end
