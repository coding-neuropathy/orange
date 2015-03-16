//
//  TabBarViewcontroller.m
//  sitcoffee
//
//  Created by 回特 on 14-7-25.
//  Copyright (c) 2014年 huiter. All rights reserved.
//

#import "TabBarViewcontroller.h"
#import "SelectionViewController.h"
#import "DiscoverViewController.h"
#import "NotifactionViewController.h"
#import "MeViewController.h"
#import "SettingViewController.h"
#import "LoginView.h"
#import "GTScrollNavigationBar.h"

@interface TabBarViewcontroller ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewcontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tabBar.translucent = NO;
    self.delegate = self;
    [self.tabBar setItemPositioning:UITabBarItemPositioningAutomatic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"Logout" object:nil];
    UINavigationController * first = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                   toolbarClass:nil];
    [first setViewControllers:@[[[SelectionViewController alloc] init]] animated:NO];
    
    UINavigationController * second = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                    toolbarClass:nil];
    [second setViewControllers:@[[[DiscoverViewController alloc] init]] animated:NO];
    UINavigationController * third = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                   toolbarClass:nil];
    [third setViewControllers:@[[[NotifactionViewController alloc] init]] animated:NO];
    UINavigationController * fourth = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                    toolbarClass:nil];
    
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[MeViewController alloc] init]] animated:NO];
    }
    else
    {
        [fourth setViewControllers:@[[[SettingViewController alloc] init]] animated:NO];
    }

    
    //UINavigationController * first = [[UINavigationController alloc]initWithRootViewController:[[SelectionViewController alloc] init]];
    //UINavigationController * second = [[UINavigationController alloc]initWithRootViewController:[[DiscoverViewController alloc] init]];
    //UINavigationController * third = [[UINavigationController alloc]initWithRootViewController:[[NotifactionViewController alloc] init]];
    //UINavigationController * fourth = [[UINavigationController alloc]initWithRootViewController:[[MeViewController alloc] init]];
    self.viewControllers = @[first,second,third,fourth];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[NotifactionViewController class]]) {
        if (!k_isLogin) {
            LoginView * view = [[LoginView alloc]init];
            [view show];
            return NO;
        }
    }
    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[MeViewController class]]) {
        if (!k_isLogin) {
            LoginView * view = [[LoginView alloc]init];
            [view show];
            return NO;
        }
    }
    return YES;
}

- (void)addBadge
{
    [self removeBadge];
    [self tabBadge:YES];
}

- (void)removeBadge
{
    [self tabBadge:NO];
}

- (void)tabBadge:(BOOL)yes
{
    if (yes) {
        UILabel * badge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        badge.backgroundColor = UIColorFromRGB(0xff1b00);
        badge.tag = 100;
        badge.layer.cornerRadius = 4;
        badge.layer.masksToBounds = YES;
        badge.center = CGPointMake(kScreenWidth*5/8+20,10);
        [self.tabBar addSubview:badge];
    }
    else
    {
        [[self.tabBar viewWithTag:100]removeFromSuperview];
    }
}


- (void)login
{
    UINavigationController * fourth = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                    toolbarClass:nil];
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[MeViewController alloc] init]] animated:NO];
    }
    else
    {
        [fourth setViewControllers:@[[[SettingViewController alloc] init]] animated:NO];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.viewControllers];
    for (UINavigationController * nav in array) {
        if ([nav.viewControllers.firstObject isKindOfClass:[SettingViewController class]]) {
            [array removeObject:nav];
        }
    }
    [array addObject:fourth];
    self.viewControllers = array;
}

- (void)logout
{
    UINavigationController * first = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                   toolbarClass:nil];
    [first setViewControllers:@[[[SelectionViewController alloc] init]] animated:NO];
    
    UINavigationController * second = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                    toolbarClass:nil];
    [second setViewControllers:@[[[DiscoverViewController alloc] init]] animated:NO];
    UINavigationController * third = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                    toolbarClass:nil];
    [third setViewControllers:@[[[NotifactionViewController alloc] init]] animated:NO];
    UINavigationController * fourth = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                                                    toolbarClass:nil];
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[MeViewController alloc] init]] animated:NO];
    }
    else
    {
        [fourth setViewControllers:@[[[SettingViewController alloc] init]] animated:NO];
    }
    //UINavigationController * first = [[UINavigationController alloc]initWithRootViewController:[[SelectionViewController alloc] init]];
    //UINavigationController * second = [[UINavigationController alloc]initWithRootViewController:[[DiscoverViewController alloc] init]];
    //UINavigationController * third = [[UINavigationController alloc]initWithRootViewController:[[NotifactionViewController alloc] init]];
    //UINavigationController * fourth = [[UINavigationController alloc]initWithRootViewController:[[MeViewController alloc] init]];
    self.viewControllers = @[first,second,third,fourth];
    [self setSelectedIndex:0];
}



@end
