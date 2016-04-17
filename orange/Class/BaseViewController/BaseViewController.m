//
//  BaseViewController.m
//  orange
//
//  Created by huiter on 15/1/27.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "BaseViewController.h"
#import "GTScrollNavigationBar.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationItem) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0., 0., 32., 44.);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0., 0., 0., 20.);
        UIBarButtonItem * backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBarItem;
    }

   
    
    // Do any additional setup after loading the view.
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    kAppDelegate.activeVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.navigationController.scrollNavigationBar respondsToSelector:@selector(setScrollView:)])
    {
        self.navigationController.scrollNavigationBar.scrollView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
