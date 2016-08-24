//
//  BannerCarousel.m
//  orange
//
//  Created by 谢家欣 on 16/8/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "BannerCarousel.h"

@implementation BannerCarousel


//- (void)setAutoscroll:(CGFloat)autoscroll
//{
//    _autoscroll = 0;
//    if (autoscroll != 0.0) [self startAnimation];
//    //    if (autoscroll != 0.) {
//    //        [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(autostep) userInfo:nil repeats:YES];
//    //    }
//}

- (void)enableAutoscroll
{
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(autostep) userInfo:nil repeats:YES];
}

- (void)disableAutoscroll
{
    [self.autoScrollTimer invalidate];
    //    self.autoScrollTimer = nil;
}

- (void)autostep
{
    [self scrollToItemAtIndex:self.currentItemIndex + 1 animated:YES];
}


@end
