//
//  BaseViewController.m
//  orange
//
//  Created by huiter on 15/1/27.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "BaseViewController.h"
//#import "GTScrollNavigationBar.h"
//#import <GTScrollNavigationBar/GTScrollNavigationBar.h>

@interface BaseViewController ()<UIGestureRecognizerDelegate>


@end

@implementation BaseViewController

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (self.navigationItem && self.navigationController.viewControllers.count > 1) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0., 0., 32., 44.);
        UIBarButtonItem * backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBarItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    kAppDelegate.activeVC = self;
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
//    if([self.navigationController.scrollNavigationBar respondsToSelector:@selector(setScrollView:)])
//    {
//        self.navigationController.scrollNavigationBar.scrollView = nil;
//    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
