//
//  AuthController.m
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "AuthController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "WebViewController.h"

#import "AuthView.h"

@interface AuthController () <AuthViewDelegate>

@property (weak, nonatomic) UIApplication * app;

@property (strong,nonatomic) LoginViewController * loginVC;
@property (strong,nonatomic) RegisterViewController * registerVC;

//@property (strong, nonatomic) UIPageViewController * thePageViewController;
//@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) AuthView * authView;

@end

@implementation AuthController

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy load view
- (AuthView *)authView
{
    if (!_authView) {
        _authView = [[AuthView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        _authView.delegate = self;
    }
    return _authView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadView
{
    self.view = self.authView;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
    /* Present 后，底层页面还隐藏。这里对屏幕截图进行效果拟补。*/
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), YES, 1);
//    [kAppDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView * v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    v.image = img;
//    [self.view addSubview:v];
//    [self.view sendSubviewToBack:v];
//}



//- (LoginViewController *)loginVC
//{
//    if (!_loginVC) {
//        _loginVC = [[LoginViewController alloc] init];
//        _loginVC.authController = self;
//    }
//    return _loginVC;
//}
//
//- (RegisterViewController *)registerVC
//{
//    if (!_registerVC) {
//        _registerVC = [[RegisterViewController alloc] init];
//        _registerVC.authController = self;
//    }
//    return _registerVC;
//}

//- (UIPageViewController *)thePageViewController
//{
//    if (!_thePageViewController) {
//        _thePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//        _thePageViewController.dataSource = self;
//        _thePageViewController.delegate = self;
//    }
//    return _thePageViewController;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
//         [self addChildViewController:self.thePageViewController];
//    
//    self.thePageViewController.view.frame = CGRectMake(0,0, kScreenWidth,  kScreenHeight);
//    
//    [self.thePageViewController setViewControllers:@[self.loginVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    [self.view addSubview:self.thePageViewController.view];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (IS_IPHONE)
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    /* Present 后，底层页面还隐藏。这里对屏幕截图进行效果拟补。*/
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), YES, 1);
    //    [kAppDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    UIImageView * v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //    v.image = img;
    //    [self.view addSubview:v];
    //    [self.view sendSubviewToBack:v];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
//    if (IS_IPHONE)
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         self.authView.deFrameSize = CGSizeMake(size.width, size.height);
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

#pragma mark - appear or disappear view
- (void)fadeIn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.authView.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.3 animations:^{
        //        self.tableView.frame = CGRectMake(0., HEIGHT, WIDTH, HEIGHT);
        //        self.blurView.blurRadius = 0;
        self.authView.alpha = 0;
        //        self.blurfilter.rangeReductionFactor = 0.;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showViewWithAnimation:(BOOL)animated
{
    if (animated) {
        [self fadeIn];
    } else {
        //        self.tableView.frame = CGRectMake(0., 0., WIDTH, HEIGHT);
    }
}

- (void)dismissViewWithAnimation:(BOOL)animated
{
    if (animated) {
        [self fadeOut];
    } else {
        //        self.tableView.frame = CGRectMake(0., HEIGHT, WIDTH, HEIGHT);
        //        self
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

#pragma mark - <AuthViewDelegate>
- (void)tapDismissButton
{
    if (IS_IPHONE)
        [self dismissViewControllerAnimated:YES completion:nil];
    else {
        [self dismissViewWithAnimation:YES];
    }
}

- (void)tapSignInButton:(id)sender
{
    LoginViewController * vc = [[LoginViewController alloc] init];
    vc.signInSuccessBlock = ^(BOOL finished) {
        if (finished) {
            if (IS_IPHONE) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.successBlock) {
                        self.successBlock();
                    }
//                [self dismissViewWithAnimation:YES];
                }];
            } else {
                if (self.successBlock) {
                    self.successBlock();
                }
                [self dismissViewWithAnimation:YES];
            }
            [SVProgressHUD dismiss];
        }
    };
    if (IS_IPHONE)
        [self.navigationController pushViewController:vc animated:YES];
    else {
        if (IS_IPHONE)
            [self.navigationController pushViewController:vc animated:YES];
        else {
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.preferredContentSize = CGSizeMake(375., 518.);
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)tapSignUpButton:(id)sender
{
    RegisterViewController * vc = [[RegisterViewController alloc] init];
    vc.signUpSuccessBlock = ^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.successBlock) {
                    self.successBlock();
                }
                
//                [self dismissViewWithAnimation:YES];
            }];
        }
    };
    if (IS_IPHONE)
        [self.navigationController pushViewController:vc animated:YES];
    else {
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.preferredContentSize = CGSizeMake(375., 518.);
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)gotoAgreementWithURL:(NSURL *)url
{
    if (IS_IPHONE) {
        [[OpenCenter sharedOpenCenter] openWebWithURL:url];
    }
}

@end
