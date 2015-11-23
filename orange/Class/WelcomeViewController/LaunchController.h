//
//  LaunchController.h
//  orange
//
//  Created by 谢家欣 on 15/11/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchController : UIViewController

@property (nonatomic, copy) void (^finished)();
@property (nonatomic, copy) void (^closeAction)();

- (instancetype)initWithLaunch:(GKLaunch *)launch;

- (void)show;

@end
