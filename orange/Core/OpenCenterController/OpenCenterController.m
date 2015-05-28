//
//  OpenCenterController.m
//  orange
//
//  Created by 谢 家欣 on 15/5/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "OpenCenterController.h"
#import "SignInViewController.h"

@implementation OpenCenterController

DEFINE_SINGLETON_FOR_CLASS(OpenCenterController);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _controller = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    return self;
}


- (void)openAccountViewControllerWithSuccessBlock:(void (^)())block
{
    //    Class AccountVC = NSClassFromString(@"AccountViewController");
    SignInViewController * vc = [[SignInViewController alloc] initWithSuccessBlock:block];
    [self.controller addChildViewController:vc];
    [self.controller.view addSubview:vc.view];
    [vc showViewWithAnimation:YES];
    
    //    [kAppDelegate.activeVC ]
    //    [self.controller presentViewController:vc animated:YES completion:nil];
    
}

@end
