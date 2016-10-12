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

//#pragma mark - Private Method

//- (void)backSwape
//{
//    self.backGesture.enabled = NO;
//    
//    [self popViewControllerAnimated:YES];
//}

#pragma mark - Override

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationBar setBackgroundImage:[[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(10, 10)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#ebebeb"] andSize:CGSizeMake(kScreenWidth, 1)]];
    [self.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor colorWithRed:33. / 255. green:33. / 255. blue:33. / 255. alpha:1]
                                                                      }];
    
//    [self.moreBtn setImage:[UIImage imageNamed:@"more dark"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];

    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[NSClassFromString(@"EntityViewController") class]]) {
        [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"top bar ggradient"] stretchableImageWithLeftCapWidth:1 topCapHeight:64] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage     = [UIImage new];
        [self.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName:[UIColor colorWithRed:33. / 255. green:33. / 255. blue:33. / 255. alpha:0.]
                                                                          }];
    }
    [super pushViewController:viewController animated:animated];
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
