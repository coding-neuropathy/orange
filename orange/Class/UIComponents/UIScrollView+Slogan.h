//
//  UIScrollView+Slogan.h
//  pomelo
//
//  Created by 谢家欣 on 15/6/1.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SloganView;

@interface UIScrollView (Slogan)

@property (strong, nonatomic, readonly) SloganView * sloganView;
@property (assign, nonatomic) BOOL showSloganView;
- (void)addSloganView;

@end


@interface SloganView : UIView



@end