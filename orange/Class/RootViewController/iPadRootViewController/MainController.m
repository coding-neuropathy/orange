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
    
    
    Class articlesClass = NSClassFromString(@"ArticlesController");
    UIViewController * articles = [[articlesClass alloc] init];
    BaseNavigationController * second = [[BaseNavigationController alloc] initWithRootViewController:articles];
    
    
    Class discoverClass = NSClassFromString(@"DiscoverController");
    UIViewController * discover = [[discoverClass alloc] init];
    BaseNavigationController * third = [[BaseNavigationController alloc] initWithRootViewController:discover];
    
    
    self.viewControllers = @[first, second, third];
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
