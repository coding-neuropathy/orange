//
//  MakePhotoView.m
//  Blueberry
//
//  Created by huiter on 13-10-25.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SelectionCategoryView.h"
#import "LoginView.h"
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>
#define kSelectionCategoryStringArray [NSArray arrayWithObjects:@"all", @"woman", @"man", @"kid", @"accessories",@"beauty",@"tech",@"living",@"outdoors",@"culture",@"food",@"fun",nil]
@interface SelectionCategoryView () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIView * mask;
@end

@implementation SelectionCategoryView
{
@private
    UIView * whiteBG;
//    UILabel * tip;
}
- (id)initWithCateId:(NSUInteger)cateId           
{
    self = [super initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    if (self) {
        self.cateId = cateId+20000;
        self.backgroundColor = [UIColor clearColor];
        
        whiteBG = [[UIView alloc] init];
        whiteBG.frame = CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreenWidth, 0.);
        whiteBG.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:whiteBG];

        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        Tap.delegate = self;
        [self addGestureRecognizer:Tap];
        
//        tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, self.frame.size.width, 50)];
//        tip.numberOfLines = 0;
//        tip.textColor = UIColorFromRGB(0x777777);
//        tip.font = [UIFont systemFontOfSize:20.];
//        tip.textAlignment = NSTextAlignmentCenter;
//        tip.text = @"选择分类";
        //[whiteBG addSubview:tip];
 
        _mask = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight + kNavigationBarHeight)];
        self.mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addSubview:self.mask];
        
    }
    return self;
}

- (UIView *)mask
{
    if(!_mask) {
        _mask = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight + kNavigationBarHeight)];
        _mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//        [self addSubview:_mask];
    }
    return _mask;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [kSelectionCategoryStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColorFromRGB(0xf8f8f8);
//        DDLogInfo(@"cate %@", obj);
        
        [button setTitle:NSLocalizedStringFromTable(obj, kLocalizedFile, nil) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.]];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;

        [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        if (kScreenWidth == 320.) {
            [button setDeFrameOrigin:CGPointMake( 8+(idx%4)*78, 8+(idx/4)*78)];
            button.deFrameSize = CGSizeMake(72, 72);
        } else if (kScreenWidth == 375.) {
            [button setDeFrameOrigin:CGPointMake(8+(idx%4)*92, 8+(idx/4)*92)];
            button.deFrameSize = CGSizeMake(84, 84);
        } else {
            [button setDeFrameOrigin:CGPointMake(8+(idx%4)*102., 8 + (idx/4) * 102)];
            button.deFrameSize = CGSizeMake(94, 94);
        }
        button.tag = idx+20000;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:button];
        whiteBG.deFrameHeight = button.deFrameBottom + 8;
    }];
    
    if ([self viewWithTag:self.cateId]) {
        if ([[self viewWithTag:self.cateId]isKindOfClass:[UIButton class]]) {
            [((UIButton *)[self viewWithTag:self.cateId]) setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
        }
    }
    
    [self insertSubview:self.mask atIndex:0];

}

- (void)show
{
    self.alpha = 0;
    [kAppDelegate.window addSubview:self];

    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
//        whiteBG.frame = CGRectMake(0, 64, whiteBG.frame.size.width, 400.);
    } completion:^(BOOL finished) {

    }];
}
- (void)dismiss
{
    for (UIView * view in whiteBG.subviews) {
        [view removeFromSuperview];
    }
    self.alpha = 1;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //whiteBG.frame = CGRectMake(0, -320, whiteBG.frame.size.width, whiteBG.frame.size.height);
        //whiteBG.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)buttonAction:(id)sender
{
    NSInteger i = ((UIButton *)sender).tag;
    NSInteger index = i - 20000;
    NSString * catename = kSelectionCategoryStringArray[index];
    DDLogInfo(@"cate %@", catename);
    if (self.tapButtonBlock) {
        self.tapButtonBlock(index, NSLocalizedStringFromTable(catename, kLocalizedFile, nil));
    }
    [self dismiss];
}

@end
