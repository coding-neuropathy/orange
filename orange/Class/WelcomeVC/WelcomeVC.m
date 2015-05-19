//
//  WelcomeVC.m
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "WelcomeVC.h"
#import "AppDelegate.h"
#import "IntruductionVC.h"

@interface WelcomeVC ()
@property (nonatomic , strong) UIImageView * logo;
@end

@implementation WelcomeVC

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
    self.view.backgroundColor = [UIColor whiteColor];
    _logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 130, 89)];
    _logo.image = [UIImage imageNamed:@"splash.png"];
    _logo.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 40);
    _logo.alpha = 0;
    [self.view addSubview:_logo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [super viewWillAppear:animated];
    [self performSelector:@selector(showEverything) withObject:nil afterDelay:0.0];
}

- (void)showEverything
{
        [UIView animateWithDuration:0.8 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{

            _logo.alpha = 1;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }];
}
- (void)dismiss
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchV4"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        IntruductionVC * vc = [[IntruductionVC alloc]init];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:^{
            [delegate.window.rootViewController presentViewController:vc animated:YES completion:^{
                kAppDelegate.window.rootViewController.view.hidden = NO;
            }];
        }];
    }
    else
    {
        kAppDelegate.window.rootViewController.view.hidden = NO;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:^{
 
        }];
    }

}
@end
