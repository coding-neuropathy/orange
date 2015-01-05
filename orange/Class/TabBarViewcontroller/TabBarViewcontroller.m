//
//  TabBarViewcontroller.m
//  sitcoffee
//
//  Created by 回特 on 14-7-25.
//  Copyright (c) 2014年 huiter. All rights reserved.
//

#import "TabBarViewcontroller.h"

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
    [self.tabBar setItemPositioning:UITabBarItemPositioningFill];
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



@end
