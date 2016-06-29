//
//  GKNotificationHUB.m
//  orange
//
//  Created by huiter on 15/7/12.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "GKNotificationHUB.h"

@implementation GKNotificationHUB

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = IS_IPHONE ? CGRectMake(0, 0, kScreenWidth, 40) : CGRectMake(0, 0, kScreenWidth - kTabBarWidth, 40);
        self.backgroundColor = [UIColor colorWithRed:206/255.0 green:24/255.0 blue:65/255.0 alpha:0.8];
        
        if (!self.label) {
            self.label = [[UILabel alloc ]initWithFrame: IS_IPHONE ? CGRectMake(0, 0, kScreenWidth, 40) : CGRectMake(0, 0, kScreenWidth - kTabBarWidth, 40)];
        }
        self.label.text = @"";
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        self.label.textColor = UIColorFromRGB(0xffffff);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

- (void)show:(NSString *)title
{
    
    self.alpha = 0;
    self.deFrameBottom = -60;
    [kAppDelegate.activeVC.view addSubview:self];
    self.label.text = title;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1;
        self.deFrameTop = -60;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0;
            self.deFrameBottom = -60;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}



@end
