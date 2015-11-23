//
//  LaunchController.m
//  orange
//
//  Created by 谢家欣 on 15/11/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "LaunchController.h"

@interface UIViewController ()

@property (strong, nonatomic) GKLaunch * launch;

@end

@implementation LaunchController

- (instancetype)initWithLaunch:(GKLaunch *)launch
{
    self = [super init];
    if (self) {
        self.launch = launch;
    }
    
    return self;
}

@end
