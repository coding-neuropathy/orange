//
//  BaseNavigationController.m
//  pomelo
//
//  Created by 谢家欣 on 15/4/8.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import "BaseNavigationController.h"
//#im

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark - Private Method
- (void)setEffectNavBar
{
    [UIApplication sharedApplication].statusBarStyle    = UIStatusBarStyleLightContent;
    [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"top bar ggradient"] stretchableImageWithLeftCapWidth:1 topCapHeight:64] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage      = [UIImage new];
    self.navigationBar.translucent      = YES;
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName:[UIColor colorWithRed:33. / 255. green:33. / 255. blue:33. / 255. alpha:0.]
                                                 }];
}

- (void)setDefaultNavBar
{
    [UIApplication sharedApplication].statusBarStyle    = UIStatusBarStyleDefault;
    self.navigationBar.translucent                      = NO;
    
    [self.navigationBar setBackgroundImage:[[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(10, 10)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:kSeparateLineColor andSize:CGSizeMake(kScreenWidth, 1)]];
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName:[UIColor colorWithRed:33. / 255. green:33. / 255. blue:33. / 255. alpha:1]
                                                 }];
}

//- (void)backSwape
//{
//    self.backGesture.enabled = NO;
//    
//    [self popViewControllerAnimated:YES];
//}

#pragma mark - Override

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * vc =  [super popViewControllerAnimated:animated];
    
//    if (![vc isKindOfClass:[NSClassFromString(@"EntityViewController") class]]) {
//    DDLogInfo(@"nav controller %@ %@", vc, self.viewControllers.lastObject);
    if (IS_IPHONE) {
        if ([self.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"EntityViewController") class]]) {
            [self setEffectNavBar];
        } else {
            [self setDefaultNavBar];
        }
    }
    return vc;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    DDLogInfo(@"push nav controller %@", self.viewControllers.lastObject);
    
    [super pushViewController:viewController animated:animated];
    if (IS_IPHONE) {
        if ([viewController isKindOfClass:[NSClassFromString(@"EntityViewController") class]]) {
            [self setEffectNavBar];
        } else {
            [self setDefaultNavBar];
        }
    }
    
    
//    self.backGesture.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _backGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwape)];
//    self.backGesture.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:self.backGesture];
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
