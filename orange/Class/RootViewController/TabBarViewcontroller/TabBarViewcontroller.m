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

#import "UserViewController.h"
#import "SettingViewController.h"
//#import "GTScrollNavigationBar.h"

#import <WZLBadge/WZLBadgeImport.h>

@interface TabBarViewcontroller ()<UITabBarControllerDelegate>

@property (assign, nonatomic) BOOL newSelection;

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelectionBadge) name:@"ShowSelectedBadge" object:nil];
    
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

/**
 *  check tabbarItem double click
 *
 *  @param viewController
 *
 *  @return BOOL
 */
- (BOOL)checkIsDoubleClick:(UIViewController *)viewController
{
    static UIViewController *lastViewController = nil;
    static NSTimeInterval lastClickTime = 0;
    
    if (lastViewController != viewController) {
        lastViewController = viewController;
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
        
        return NO;
    }
    
    NSTimeInterval clickTime = [NSDate timeIntervalSinceReferenceDate];
    if (clickTime - lastClickTime > 0.5 ) {
        lastClickTime = clickTime;
        return NO;
    }
    
    lastClickTime = clickTime;
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController * vc = ((UINavigationController *)viewController).viewControllers.firstObject;
    if ([vc isKindOfClass:[NotifyController class]]) {
        
        if (!(k_isLogin)) {
            DDLogInfo(@"need login");
            [[OpenCenter sharedOpenCenter] openAuthPage];
            return NO;
            //return NO;
        } else {

        }
    }
    
    if ([vc isKindOfClass:[SelectionController class]]) {
        if ([self checkIsDoubleClick:viewController]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDoubleClickTabItemNotification object:nil];
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
    
//    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[SelectionController class]]) {
//        //        self.selectionController
//        if (self.newSelection) {
//            [self cleanSelectionBadge];
//        }
//    }
}

#pragma mark - notification
- (void)addBadge
{
    UITabBarItem * messageItem      = [self.tabBar.items objectAtIndex:2];
    messageItem.badgeCenterOffset   = CGPointMake(-30, 10);
    messageItem.badgeBgColor        = [UIColor colorFromHexString:@"#f70866"];
    
    [messageItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeBreathe];
}

- (void)removeBadge
{
    UITabBarItem * messageItem = [self.tabBar.items objectAtIndex:2];
    [messageItem clearBadge];
}

//- (void)showSelectionBadge
//{
//    self.newSelection               = YES;
//    UITabBarItem * selectionItem    = [self.tabBar.items objectAtIndex:0];
//    selectionItem.badgeCenterOffset = CGPointMake(-30, 10);
//    
//    [selectionItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeBreathe];
//}
//
//- (void)cleanSelectionBadge
//{
//    self.newSelection               = NO;
//    UITabBarItem * selectionItem    = [self.tabBar.items objectAtIndex:0];
//    
//    [selectionItem clearBadge];
//}


/**
 *  account
 */
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
