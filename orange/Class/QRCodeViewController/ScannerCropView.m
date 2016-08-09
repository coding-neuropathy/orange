//
//  ScannerCropView.m
//  orange
//
//  Created by 谢家欣 on 16/8/8.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ScannerCropView.h"

@interface ScannerCropView ()
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

@property (strong, nonatomic) UIImageView * scanningLine;

@end

@implementation ScannerCropView

- (void)setDefaultProperty
{
    _currentStep = 0;
    _dotCount = 3;
    _isAnimating = NO;
    _duration = .6f;
    _hidesWhenStopped = YES;
}

- (UIImageView *)scanningLine
{
    if (!_scanningLine) {
        _scanningLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage * lineImage = [UIImage imageNamed:@"scanning"];
        _scanningLine.frame = CGRectMake(0., 0., lineImage.size.width, lineImage.size.height);
        _scanningLine.image = lineImage;
        _scanningLine.hidden = YES;
        [self addSubview:_scanningLine];
    }
    return _scanningLine;
}

- (void)layoutSubviews
{
//    NSLog(@"%@", self.scanningLine);
    [super layoutSubviews];
}

#pragma mark - pubilc
- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    
    self.scanningLine.hidden = NO;
    [self repeatAnimation];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.
                                              target:self
                                            selector:@selector(repeatAnimation)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _isAnimating = YES;
}

- (void)stopAnimating
{
//    [UIView setAnimationsEnabled:NO];

    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    
    if (_hidesWhenStopped)
    {
        self.scanningLine.hidden = YES;
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

- (void)repeatAnimation
{
//        [UIView animateWithDuration:2. delay:0.1 options:UIViewAnimationOptionAutoreverse animations:^{
//            self.scanningLine.frame = CGRectMake(0, self.deFrameWidth,
//                                                self.scanningLine.deFrameWidth, self.scanningLine.deFrameHeight);
//        } completion:nil];
    self.scanningLine.frame = CGRectMake(0, 0,
                                         self.scanningLine.deFrameWidth, self.scanningLine.deFrameHeight);
    [UIView animateWithDuration:2. animations:^{
        self.scanningLine.frame = CGRectMake(0, self.deFrameWidth,
                                                self.scanningLine.deFrameWidth, self.scanningLine.deFrameHeight);

    }];
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
    CGContextSetLineWidth(ctx, 1.0);
    
//    CGContextMoveToPoint(ctx, 0.0, rect.size.height / 2.);
//    CGContextAddLineToPoint(ctx, 0. + rect.size.width, rect.size.height / 2.);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0., 20.);
    CGContextAddLineToPoint(ctx, 0., 0.);
    CGContextAddLineToPoint(ctx, 20., 0);
    
    CGContextMoveToPoint(ctx, rect.size.width - 20, 0.);
    CGContextAddLineToPoint(ctx, rect.size.width, 0.0);
    CGContextAddLineToPoint(ctx, rect.size.width, 20.);
    
    CGContextMoveToPoint(ctx, rect.size.width, rect.size.height - 20);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width - 20., rect.size.height);
    
    CGContextMoveToPoint(ctx, 0 + 20, rect.size.height);
    CGContextAddLineToPoint(ctx, 0, rect.size.height);
    CGContextAddLineToPoint(ctx, 0, rect.size.height - 20);
    
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x6192ff).CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextStrokePath(ctx);
}

@end
