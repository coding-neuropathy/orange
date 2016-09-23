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
@property (weak, nonatomic)   UIApplication * app;
@property (weak, nonatomic)   NSTimer   *timer;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger skipSeconds;

@end

@implementation LaunchController

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(skipAction:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (instancetype)initWithLaunch:(GKLaunch *)launch SkipSeconds:(NSInteger)seconds
{
    self = [super init];
    if (self) {
        self.launch         = launch;
        self.skipSeconds    = seconds;
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.32];
    }
    
    return self;
}

#pragma mark - init view
- (LaunchView *)launchView
{
    if (!_launchView) {
        _launchView = [[LaunchView alloc] initWithFrame:CGRectZero];
                _launchView.frame = CGRectMake(0., 0., kScreenWidth, kScreenHeight);

//        _launchView.deFrameTop = - (_launchView.deFrameHeight);
//        _launchView.deFrameLeft = (kScreenWidth - _launchView.deFrameWidth) / 2.;
        
        if (IS_IPAD) {
            _launchView.frame = CGRectMake(0., 0., 360., 480.);
            _launchView.deFrameTop = - ((kScreenHeight - _launchView.deFrameHeight) / 2. + _launchView.deFrameHeight);
            
            _launchView.deFrameLeft = (kScreenWidth - _launchView.deFrameWidth) / 2.;
                    _launchView.layer.cornerRadius = 4.;
        } else {
            _launchView.alpha       = 0.;
        }
        _launchView.backgroundColor = UIColorFromRGB(0xffffff);
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
    
    
    if (IS_IPAD) {
        self.closeBtn.deFrameRight =  CGRectGetMaxX(self.launchView.frame) + 12.;
        self.closeBtn.deFrameTop = CGRectGetMinY(self.launchView.frame) - 12.;
    
        [self.view insertSubview:self.closeBtn aboveSubview:self.launchView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"LaunchView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"LaunchView"];
    [super viewWillDisappear:animated];
}

- (void)show
{
    [self fadeIn];
}

#pragma mark -

- (void)fadeIn
{
    [UIView animateWithDuration:0.35 animations:^{
        if (IS_IPAD) {
            self.launchView.deFrameTop = (kScreenHeight - self.launchView.deFrameHeight) / 2.;
            self.closeBtn.deFrameRight =  CGRectGetMaxX(self.launchView.frame) + 12.;
            self.closeBtn.deFrameTop = CGRectGetMinY(self.launchView.frame) - 12.;
        } else  {
            self.launchView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if (IS_IPHONE) {
            self.count = 0;
            [self.timer fire];
        }
    }];
}

- (void)fadeOutWithAction:(void (^)(void))action
{
    [UIView animateWithDuration:0.35 animations:^{
        if (IS_IPAD) {
            self.launchView.transform = CGAffineTransformMakeTranslation(self.launchView.transform.tx, self.launchView.transform.ty + 600.);
            self.closeBtn.transform = CGAffineTransformMakeTranslation(self.closeBtn.transform.tx, self.closeBtn.transform.ty + 600.);
        } else {
            self.launchView.alpha = 0.;
        }
    } completion:^(BOOL finished) {
        if (finished){
            action();
        }

    }];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        self.launchView.deFrameTop      = (kScreenHeight - _launchView.deFrameHeight) / 2.;
        self.launchView.deFrameLeft     = (kScreenWidth - _launchView.deFrameWidth) / 2.;
        self.closeBtn.deFrameRight      = CGRectGetMaxX(self.launchView.frame) + 12.;
        self.closeBtn.deFrameTop        = CGRectGetMinY(self.launchView.frame) - 12.;
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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

#pragma mark - time
- (void)skipAction:(id)sender
{
//    DDLogInfo(@"cccc");
    if (self.count >= self.skipSeconds) {
        [self.timer invalidate];
        [self tapCloseBtn:nil];
    }
    [self.launchView.closeBtn setTitle:[NSString stringWithFormat:@"%@ %ld", NSLocalizedStringFromTable(@"skip", kLocalizedFile, nil), (long)self.skipSeconds--] forState:UIControlStateNormal];
    self.count++;
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

- (void)tapCloseBtn:(id)sender
{
    [self fadeOutWithAction:^{
        if (self.finished) {
            [self.view removeFromSuperview];
            self.closeAction();
        }
    }];
}

@end
