//
//  iPadRootViewController.m
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "iPadRootViewController.h"
#import "MenuController.h"
#import "MainController.h"


@interface iPadRootViewController () <MenuControllerDelegate>

@property (nonatomic, strong) MenuController * menuController;
@property (nonatomic, strong) MainController * mainController;

@end

@implementation iPadRootViewController

#pragma mark - init menu view controller
- (MenuController *)menuController
{
    if (!_menuController) {
        _menuController = [[MenuController alloc] init];
        _menuController.delegate = self;
        [self.view addSubview:_menuController.view];
    }
    return _menuController;
}

#pragma mark - init main view controller
- (MainController *)mainController
{
    if (!_mainController) {
        _mainController = [[MainController alloc] init];
        _mainController.view.backgroundColor = [UIColor whiteColor];
        _mainController.view.frame = CGRectMake(84., 0., kScreenWidth - 84., kScreenHeight);
        _mainController.tabBar.hidden = YES;
        [self.view addSubview:_mainController.view];
    }
    return _mainController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.menuController];
    [self addChildViewController:self.mainController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //        DDLogInfo(@"OKOKOKOKO");
        self.menuController.view.frame = CGRectMake(0., 0., kTabBarWidth, kScreenHeight);
        // 竖屏 左边栏宽60.f
        //        CGFloat width = 60.f;
        //        self.horizontalSpace.constant = width - self.masterWidth.constant;
    } else {
        self.menuController.view.frame = CGRectMake(0., 0., kTabBarWidth, kScreenHeight);
        // 横屏
        //        self.horizontalSpace.constant = 0.f;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    //    DDLogInfo(@"OKOKOKO");
    if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        self.menuController.view.frame = CGRectMake(0., 20., kTabBarWidth, 1004);
    } else {
        self.menuController.view.frame = CGRectMake(0., 20., kTabBarWidth, 748);
    }
}

#pragma mark - <MasterViewControllerDelegate>
- (void)MenuController:(MenuController *)menucontroller didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
