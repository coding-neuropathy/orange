//
//  MainController.m
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MainController.h"
#import "BaseNavigationController.h"


@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Class selectionClass = NSClassFromString(@"SelectionViewController");
    UIViewController * selected = [[selectionClass alloc] init];
    BaseNavigationController * first = [[BaseNavigationController alloc] initWithRootViewController:selected];
    
    Class ArticleClass = NSClassFromString(@"ArticlesController");
    UIViewController * articles = [[ArticleClass alloc] init];
    BaseNavigationController * second = [[BaseNavigationController alloc] initWithRootViewController:articles];
    
    Class DiscoverClass = NSClassFromString(@"DiscoverController");
    UIViewController * discover = [[DiscoverClass alloc] init];
    BaseNavigationController * third = [[BaseNavigationController alloc] initWithRootViewController:discover];
    
    Class ActiveClass = NSClassFromString(@"ActiveController");
    UIViewController * active = [[ActiveClass alloc] init];
    BaseNavigationController * fourth = [[BaseNavigationController alloc] initWithRootViewController:active];
    
    Class MessageClass = NSClassFromString(@"MessageController");
    UIViewController * message = [[MessageClass alloc] init];
    BaseNavigationController * fifth = [[BaseNavigationController alloc] initWithRootViewController:message];
    
    Class SettingClass = NSClassFromString(@"SettingViewController");
    UIViewController * setting = [[SettingClass alloc] init];
    BaseNavigationController * sixth = [[BaseNavigationController alloc] initWithRootViewController:setting];
    
    self.userVC = [[UserViewController alloc] initWithUser:[Passport sharedInstance].user];
    BaseNavigationController * UserNav = [[BaseNavigationController alloc] initWithRootViewController:self.userVC];
    
    self.viewControllers = @[first, second, third, fourth, fifth, sixth, UserNav];
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
