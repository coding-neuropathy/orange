//
//  BaseNavigationController.m
//  pomelo
//
//  Created by 谢家欣 on 15/4/8.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark - Private Method

- (void)backSwape
{
    self.backGesture.enabled = NO;
    
    [self popViewControllerAnimated:YES];
}

#pragma mark - Override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    self.backGesture.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwape)];
    self.backGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.backGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.backGesture.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
