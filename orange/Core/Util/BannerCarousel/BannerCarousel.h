//
//  BannerCarousel.h
//  orange
//
//  Created by 谢家欣 on 16/8/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <iCarousel/iCarousel.h>

@interface BannerCarousel : iCarousel

@property (strong, nonatomic) NSTimer * autoScrollTimer;
- (void)enableAutoscroll;
- (void)disableAutoscroll;

@end
