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

//#import "MeViewController.h"
#import "UserViewController.h"
#import "SettingViewController.h"
//#import "LoginView.h"
#import "GTScrollNavigationBar.h"

#import <WZLBadge/WZLBadgeImport.h>

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowBadge" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowSelectedBadge" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadge) name:@"ShowBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelectionBadge) name:@"ShowSelectedBadge" object:nil];
    
//    self.tabBar.translucent = YES;
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
//    third.tabBarItem.t
//    third.tabBarItem.badgeCenterOffset = CGPointMake(0, 0);
//    [third.tabBarItem showBadgeWithStyle:WBadgeStyleNew value:0 animationType:WBadgeAnimTypeShake];
    
    UINavigationController * fourth = [[UINavigationController alloc] init];
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[UserViewController alloc] initWithUser:[Passport sharedInstance].user]] animated:NO];
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
    [[SDImageCache sharedImageCache] clearMemory];
    [super didReceiveMemoryWarning];
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[NotifyController class]]) {
        if (!k_isLogin) {
//            LoginView * view = [[LoginView alloc]init];
//            [view show];
            [[OpenCenter sharedOpenCenter] openAuthPage];
            return NO;
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"%@", viewController);
    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[NotifyController class]]) {
//        self.selectionController
        [self removeBadge];
    }
}

#pragma mark - notification
- (void)addBadge
{
    UITabBarItem * messageItem = [self.tabBar.items objectAtIndex:2];
    messageItem.badgeCenterOffset = CGPointMake(-30, 10);
    [messageItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeBreathe];
}

- (void)showSelectionBadge
{
    UITabBarItem * selectionItem = [self.tabBar.items objectAtIndex:0];
    selectionItem.badgeCenterOffset = CGPointMake(-30, 10);
    [selectionItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeBreathe];
}

- (void)removeBadge
{
    UITabBarItem * messageItem = [self.tabBar.items objectAtIndex:2];
    [messageItem clearBadge];
}


- (void)login
{
    UINavigationController * fourth = [[UINavigationController alloc] init];
    if(k_isLogin)
    {
        [fourth setViewControllers:@[[[UserViewController alloc] initWithUser:[Passport sharedInstance].user]] animated:NO];
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
        if ([nav.viewControllers.firstObject isKindOfClass:[UserViewController class]]) {
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
        [fourth setViewControllers:@[[[UserViewController alloc] initWithUser:[Passport sharedInstance].user]] animated:NO];
    }
    else
    {
        [fourth setViewControllers:@[[[SettingViewController alloc] init]] animated:NO];
    }

    self.viewControllers = @[first,second,third,fourth];
    [self setSelectedIndex:0];
}



@end
