//
//  UIScrollView+AutoScroll.h
//  basechemV2
//
//  Created by 谢家欣 on 13-12-20.
//  Copyright (c) 2013年 谢家欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (AutoScroll)

@property (nonatomic) CGFloat scrollPointsPerSecond;
@property (nonatomic, getter = isScrolling) BOOL scrolling;

- (void)startScrolling;
- (void)stopScrolling;

@end
