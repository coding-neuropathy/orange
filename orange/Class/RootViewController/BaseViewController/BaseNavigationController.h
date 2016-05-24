//
//  BaseNavigationController.h
//  pomelo
//
//  Created by 谢家欣 on 15/4/8.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

@property (nonatomic, strong) UISwipeGestureRecognizer *backGesture;

@end
