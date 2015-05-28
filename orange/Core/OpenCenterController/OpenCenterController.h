//
//  OpenCenterController.h
//  orange
//
//  Created by 谢 家欣 on 15/5/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenCenterController : NSObject

@property (strong, nonatomic) UIViewController * controller;

DEFINE_SINGLETON_FOR_HEADER(OpenCenterController);

- (void)openAccountViewControllerWithSuccessBlock:(void (^)())block;

@end
