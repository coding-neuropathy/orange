//
//  UIScrollView+AutoScroll.m
//  basechemV2
//
//  Created by 谢家欣 on 13-12-20.
//  Copyright (c) 2013年 谢家欣. All rights reserved.
//

#import "UIScrollView+AutoScroll.h"
#import <objc/runtime.h>

static CGFloat UIScrollViewDefaultScrollPointsPerSecond = 15.0f;
static char UIScrollViewScrollPointsPerSecondNumber;
static char UIScrollViewAutoScrollTimer;

@interface UIScrollView (AutoScroll_Internal)

@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation UIScrollView (AutoScroll)


- (void)startScrolling
{
    [self stopScrolling];
    
//    CGFloat scale = (self.window ? self.window.screen.scale : [UIScreen mainScreen].scale);
//    CGFloat animationDuration = (1.0f / (self.scrollPointsPerSecond * scale));
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.
                                                            target:self
                                                          selector:@selector(scrollTick)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void)stopScrolling
{
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (void)scrollTick
{
//    DDLogInfo(@"%f", self.contentOffset.x);
    if (self.window == nil) {
        [self stopScrolling];
    }
    
//    CGFloat animationDuration = self.autoScrollTimer.timeInterval;
//    CGFloat pointChange = self.scrollPointsPerSecond * animationDuration;
    CGPoint newOffset = (CGPoint) {
        .x = self.contentOffset.x + self.frame.size.width,
        .y = self.contentOffset.y
    };
    
    CGFloat maximumXOffset = self.contentSize.width - self.bounds.size.width;
    if (newOffset.x > maximumXOffset) {
//        [self stopScrolling];
//        [self setContentOffset: animated:<#(BOOL)#>]
        [self scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];

    } else {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.contentOffset = newOffset;
                         } completion:nil];
    }
}


- (void)setScrolling:(BOOL)scrolling
{
    if (scrolling) {
        [self startScrolling];
    } else {
        [self stopScrolling];
    }
}

- (BOOL)isScrolling
{
    return (self.autoScrollTimer != nil);
}

- (CGFloat)scrollPointsPerSecond
{
    NSNumber *scrollPointsPerSecondNumber = objc_getAssociatedObject(self, &UIScrollViewScrollPointsPerSecondNumber);
    if (scrollPointsPerSecondNumber) {
        return [scrollPointsPerSecondNumber floatValue];
    } else {
        return UIScrollViewDefaultScrollPointsPerSecond;
    }
}

- (void)setScrollPointsPerSecond:(CGFloat)scrollPointsPerSecond
{
    [self willChangeValueForKey:@"scrollPointsPerSecond"];
    objc_setAssociatedObject(self,
                             &UIScrollViewScrollPointsPerSecondNumber,
                             [NSNumber numberWithFloat:scrollPointsPerSecond],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"scrollPointsPerSecond"];
}

- (NSTimer *)autoScrollTimer
{
    return objc_getAssociatedObject(self, &UIScrollViewAutoScrollTimer);
}

- (void)setAutoScrollTimer:(NSTimer *)autoScrollTimer
{
    [self willChangeValueForKey:@"autoScrollTimer"];
    objc_setAssociatedObject(self,
                             &UIScrollViewAutoScrollTimer,
                             autoScrollTimer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"autoScrollTimer"];
}

@end
