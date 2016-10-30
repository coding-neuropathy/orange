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

@property (strong, nonatomic) UIButton * backBtn;

@end

@implementation BaseViewController
#pragma mark - public method
- (void)setDefaultBackBtn
{
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
}

- (void)setWhiteBackBtn
{
    [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
}

#pragma mark -
- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.frame = CGRectMake(0., 0., 32., 32.);
    }
    return _backBtn;
}


#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (self.navigationItem && self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem * backBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
        self.navigationItem.leftBarButtonItem = backBarItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
//    DDLogInfo(@"view controller %@", self.navigationController.viewControllers.lastObject);
    
    if (self.navigationController.viewControllers.count <= 1
        && self.navigationController.viewControllers.lastObject != nil)
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
