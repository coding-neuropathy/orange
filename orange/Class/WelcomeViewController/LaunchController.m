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
@property (strong, nonatomic) UIButton * closeBtn;

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
        _launchView = [[LaunchView alloc] initWithFrame:CGRectMake((kScreenWidth - 290.) / 2, -425., 290., 425.)];
        _launchView.backgroundColor = UIColorFromRGB(0xffffff);
        _launchView.layer.cornerRadius = 4.;
        _launchView.delegate = self;
    }
    return _launchView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *closeimage = [UIImage imageNamed:@"startClose"];
        _closeBtn.frame = CGRectMake(0., 0., closeimage.size.width, closeimage.size.height);

        [_closeBtn setImage:closeimage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.launchView.launch = self.launch;
    [self.view addSubview:self.launchView];
    
    
    self.closeBtn.deFrameRight =  CGRectGetMaxX(self.launchView.frame) + 12.;
    self.closeBtn.deFrameTop = CGRectGetMinY(self.launchView.frame) - 12.;
    
    [self.view insertSubview:self.closeBtn aboveSubview:self.launchView];
}

- (void)show
{
    [self fadeIn];
}

#pragma mark -

- (void)fadeIn
{
    [UIView animateWithDuration:0.35 animations:^{
        self.launchView.deFrameTop = (kScreenHeight - 425.) / 2.;
        self.closeBtn.deFrameRight =  CGRectGetMaxX(self.launchView.frame) + 12.;
        self.closeBtn.deFrameTop = CGRectGetMinY(self.launchView.frame) - 12.;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOutWithAction:(void (^)(void))action
{
    [UIView animateWithDuration:0.35 animations:^{
//        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.launchView.transform = CGAffineTransformMakeRotation(M_PI / -36.);

//        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished){

            [UIView animateWithDuration:0.35 animations:^{
                self.launchView.deFrameTop = kScreenHeight + 10.;
            } completion:^(BOOL finished) {
                if (finished) {
                    action();
                }
            }];
            
        }

    }];
}


#pragma mark - button aciotn 
- (void)closeBtnAction:(id)sender
{
    [self fadeOutWithAction:^{
        if (self.finished) {
            [self.view removeFromSuperview];
            self.closeAction();
        }
    }];
}

#pragma mark - <LaunchViewDelegate>
-(void)handleActionBtn:(id)sender
{
    [self fadeOutWithAction:^{
        if (self.finished) {
            [self.view removeFromSuperview];
            self.finished();
        }
    }];
}

@end
