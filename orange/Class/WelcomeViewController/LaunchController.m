//
//  LaunchController.m
//  orange
//
//  Created by 谢家欣 on 15/11/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "LaunchController.h"
#import "LaunchView.h"

@interface LaunchController () <LaunchViewDelegate>

@property (strong, nonatomic) GKLaunch * launch;
@property (strong, nonatomic) LaunchView * launchView;

@end

@implementation LaunchController

- (instancetype)initWithLaunch:(GKLaunch *)launch
{
    self = [super init];
    if (self) {
        self.launch = launch;
        
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.32];
//        self.view.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (LaunchView *)launchView
{
    if (!_launchView) {
        _launchView = [[LaunchView alloc] initWithFrame:CGRectMake((kScreenWidth - 290.) / 2, (kScreenHeight - 425.) / 2, 290., 425.)];
        _launchView.backgroundColor = UIColorFromRGB(0xffffff);
        _launchView.layer.cornerRadius = 4.;
        _launchView.delegate = self;
    }
    return _launchView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.launchView.launch = self.launch;
    [self.view addSubview:self.launchView];
}

#pragma mark - <LaunchViewDelegate>
- (void)TapActionBtn:(id)sender
{

}

@end
