//
//  ScanerCropView.m
//  orange
//
//  Created by 谢家欣 on 16/8/8.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ScanerCropView.h"

@interface ScanerCropView ()
{
    BOOL    _isAnimating;
    NSTimer * _timer;
    BOOL    _hidesWhenStopped;
    NSInteger _currentStep;
    NSInteger _dotCount;
    CGFloat   _duration;
}


@property (nonatomic, assign)BOOL hidesWhenStopped;
@property (nonatomic, assign)NSInteger dotCount;
@property (nonatomic, assign)CGFloat duration;

@end

@implementation ScanerCropView

- (void)setDefaultProperty
{
    _currentStep = 0;
    _dotCount = 3;
    _isAnimating = NO;
    _duration = .6f;
    _hidesWhenStopped = YES;
}

#pragma mark - pubilc
- (void)startAnimating
{
    
}

- (void)stopAnimating
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    
    if (_hidesWhenStopped)
    {
        self.hidden = YES;
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    CGContextMoveToPoint(ctx, 0.0, rect.size.height / 2.);
    CGContextAddLineToPoint(ctx, 0. + rect.size.width, rect.size.height / 2.);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0., 40.);
    CGContextAddLineToPoint(ctx, 0., 0.);
    CGContextAddLineToPoint(ctx, 40., 0);
    
    CGContextMoveToPoint(ctx, rect.size.width - 40, 0.);
    CGContextAddLineToPoint(ctx, rect.size.width, 0.0);
    CGContextAddLineToPoint(ctx, rect.size.width, 40.);
    
    CGContextMoveToPoint(ctx, rect.size.width, rect.size.height - 40);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width - 40., rect.size.height);
    
    CGContextMoveToPoint(ctx, 0 + 40, rect.size.height);
    CGContextAddLineToPoint(ctx, 0, rect.size.height);
    CGContextAddLineToPoint(ctx, 0, rect.size.height - 40);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextStrokePath(ctx);
}

@end
