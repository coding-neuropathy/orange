//
//  UINavigationController+statusbar.m
//  StatusBar
//
//  Created by Konstantinos Koronellos on 05/12/2014.
//  Copyright (c) 2014 mythodeia. All rights reserved.
//

#import "UINavigationController+statusbar.h"

@implementation UINavigationController (statusbar)

/**
 * This code will always return the UIStatusBarStyle of the topViewController inside the navigationController view stack.
   The viewController must override the method below in order to accomplish that.
 *
 *  @return UIStatusBarStyle
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end