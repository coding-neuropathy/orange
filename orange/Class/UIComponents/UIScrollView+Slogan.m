//
//  UIScrollView+Slogan.m
//  pomelo
//
//  Created by 谢家欣 on 15/6/1.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import "UIScrollView+Slogan.h"

@interface SloganView ()

@property (strong, nonatomic) UILabel * sloganLabel;
@property (strong, nonatomic) UIView * H;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL isObserving;

@end


@implementation SloganView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)sloganLabel
{
    if (!_sloganLabel) {
        _sloganLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sloganLabel.backgroundColor = UIColorFromRGB(0xffffff);
        
        if (IS_IPHONE) {
            _sloganLabel.font = [UIFont fontWithName:@"FultonsHand" size:14.];
        } else {
            _sloganLabel.font = [UIFont fontWithName:@"FultonsHand" size:20.];
        }

        _sloganLabel.textAlignment = NSTextAlignmentCenter;
        _sloganLabel.textColor = UIColorFromRGB(0xcbcbcb);
        _sloganLabel.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _sloganLabel.text = @"Live Different";
        [self addSubview:_sloganLabel];
    }
    return _sloganLabel;
}

- (UIView *)H
{
    if (!_H) {
        _H = [[UIView alloc] initWithFrame:CGRectZero];
        _H.backgroundColor = UIColorFromRGB(0xebebeb);
        [self addSubview:_H];
    }
    return _H;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.sloganLabel.frame = CGRectMake(100., 20., self.deFrameWidth - 200, 30.);
    self.sloganLabel.center = CGPointMake(self.deFrameWidth/2, 50);
    self.H.frame = CGRectMake(20,50, self.deFrameWidth-40, 0.5);
    self.H.center = self.sloganLabel.center;
    [self bringSubviewToFront:self.sloganLabel];

}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsInfiniteScrolling) {
            if (self.isObserving) {
//                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 16., 26.);
    CGContextAddLineToPoint(context, kScreenWidth - 16., 26.);
    
    CGContextStrokePath(context);
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if([keyPath isEqualToString:@"contentOffset"])
//        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
//    else
    if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, kScreenHeight);
    }
}

@end


#pragma mark - UIScrollView (Slogan)
#import <objc/runtime.h>

static char UISloganView;

@implementation UIScrollView (Slogan)

@dynamic sloganView;

- (void)addSloganView
{
    if (!self.sloganView) {
        SloganView * view = [[SloganView alloc] initWithFrame:CGRectMake(0., self.contentSize.height, self.deFrameWidth, kScreenHeight)];
//        view.backgroundColor = [UIColor redColor];
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.sloganView = view;
        self.showSloganView = YES;
    }
}


- (void)setSloganView:(SloganView *)sloganView
{
    [self willChangeValueForKey:@"UISloganView"];
    objc_setAssociatedObject(self, &UISloganView, sloganView, OBJC_ASSOCIATION_ASSIGN);
}

- (SloganView *)sloganView {
    return objc_getAssociatedObject(self, &UISloganView);
}

- (void)setShowSloganView:(BOOL)showSloganView
{
    self.sloganView.hidden = !showSloganView;
    
    if(!showSloganView) {
        [self removeObserver:self.sloganView forKeyPath:@"contentSize"];
        self.sloganView.isObserving = NO;
    } else {
        [self addObserver:self.sloganView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.sloganView.frame = CGRectMake(0, self.contentSize.height, self.sloganView.bounds.size.width, kScreenHeight);
        self.sloganView.isObserving = YES;
    }
}

- (BOOL)showSloganView
{
    return !self.sloganView.hidden;
}


@end

