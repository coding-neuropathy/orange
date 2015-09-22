//
//  TabBarViewcontroller.m
//  sitcoffee
//
//  Created by 回特 on 14-7-25.
//  Copyright (c) 2014年 huiter. All rights reserved.
//

#import "TabBarViewcontroller.h"
#import "SelectionController.h"
#import "DiscoverController.h"
#import "NotifyController.h"

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

//- (SelectionController *)selectionController
//{
//    if (!_selectionController) {
//        _selectionController  = [[SelectionController alloc] init]
//    }
//    return _selectionController;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadge) name:@"ShowBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBadge) name:@"HideBadge" object:nil];
    
    self.tabBar.translucent = NO;
    self.delegate = self;
    [self.tabBar setItemPositioning:UITabBarItemPositioningAutomatic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"Logout" object:nil];
    
    UINavigationController * first = [[UINavigationController alloc] init];
    self.selectionController = [[SelectionController alloc] init];
    [first setViewControllers:@[self.selectionController] animated:NO];
    
    UINavigationController * second = [[UINavigationController alloc] init];
    [second setViewControllers:@[[[DiscoverController alloc] init]] animated:NO];
    UINavigationController * third = [[UINavigationController alloc] init];
    [third setViewControllers:@[[[NotifyController alloc] init]] animated:NO];
    UINavigationController * fourth = [[UINavigationController alloc] init];
    
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[MeViewController alloc] init]] animated:NO];
    }
    else
    {
        [fourth setViewControllers:@[[[SettingViewController alloc] init]] animated:NO];
    }

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
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[NotifyController class]]) {
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
        UILabel * badge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
        badge.backgroundColor = UIColorFromRGB(0xFF1F77);
        badge.tag = 100;
        badge.layer.cornerRadius = 3;
        badge.layer.masksToBounds = YES;
        badge.center = CGPointMake(kScreenWidth*5/8+15,10);
        [self.tabBar addSubview:badge];
    }
    else
    {
        [[self.tabBar viewWithTag:100]removeFromSuperview];
    }
}


- (void)login
{
    UINavigationController * fourth = [[UINavigationController alloc] init];
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
        if ([nav.viewControllers.firstObject isKindOfClass:[MeViewController class]]) {
            return;
        }
    }
    [array addObject:fourth];
    self.viewControllers = array;
}

- (void)logout
{
    UINavigationController * first = [[UINavigationController alloc] init];
    self.selectionController = [[SelectionController alloc] init];
    [first setViewControllers:@[self.selectionController] animated:NO];
//    [first setViewControllers:@[[[SelectionController alloc] init]] animated:NO];
    
    UINavigationController * second = [[UINavigationController alloc] init];
    [second setViewControllers:@[[[DiscoverController alloc] init]] animated:NO];
    UINavigationController * third = [[UINavigationController alloc] init];
    [third setViewControllers:@[[[NotifyController alloc] init]] animated:NO];
    UINavigationController * fourth = [[UINavigationController alloc] init];
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[MeViewController alloc] init]] animated:NO];
    }
    else
    {
        [fourth setViewControllers:@[[[SettingViewController alloc] init]] animated:NO];
    }

    self.viewControllers = @[first,second,third,fourth];
    [self setSelectedIndex:0];
}



@end
