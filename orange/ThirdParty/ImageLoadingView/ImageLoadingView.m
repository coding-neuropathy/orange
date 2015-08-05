//
//  GKRotateLoadingView.m
//  MMM
//
//  Created by huiter on 13-7-10.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "ImageLoadingView.h"

@implementation ImageLoadingView

@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize dotCount = _dotCount;
@synthesize duration = _duration;

- (void)setDefaultProperty
{
    _currentStep = 0;
    _dotCount = 9;
    _isAnimating = NO;
    _duration = 0.1f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultProperty];
        self.backgroundColor = [UIColor clearColor];
        _earth = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"loading-image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _earth.tintColor = [UIColor colorWithRed:((float)((0xdcdcdc & 0xFF0000) >> 16))/255.0 green:((float)((0xdcdcdc & 0xFF00) >> 8))/255.0 blue:((float)(0xdcdcdc & 0xFF))/255.0 alpha:1.0];
        _earth.frame = CGRectMake(0, 0, 24, 24);
        _earth.contentMode = UIViewContentModeScaleAspectFill;
        _earth.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

        [self addSubview:_earth];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 24, 24)];
    
    return self;
}

#pragma mark - public
- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    _currentStep = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration
                                              target:self
                                            selector:@selector(repeatAnimation)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self repeatAnimation];
    _isAnimating = YES;
    
    if (_hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _isAnimating = NO;
    
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

- (void)repeatAnimation
{
    _currentStep = ++_currentStep;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.earth.transform = CGAffineTransformMakeRotation(30*(_currentStep) * (M_PI / 180.0f));
    [UIView commitAnimations];
    
}

@end
