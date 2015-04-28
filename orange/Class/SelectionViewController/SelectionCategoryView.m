//
//  MakePhotoView.m
//  Blueberry
//
//  Created by huiter on 13-10-25.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SelectionCategoryView.h"
#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>
#define kSelectionCategoryStringArray [NSArray arrayWithObjects:@"所有",@"女装",@"男装",@"孩童", @"配饰",@"美容",@"科技",@"居家",@"户外",@"文化",@"美食",@"玩乐",nil]
@interface SelectionCategoryView () <UIGestureRecognizerDelegate>

@end

@implementation SelectionCategoryView
{
@private
    UIView * whiteBG;
    UILabel * tip;
}
- (id)initWithCateId:(NSUInteger)cateId           
{
    self = [super initWithFrame:kAppDelegate.window.frame];
    if (self) {
        self.cateId = cateId+20000;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        whiteBG = [[UIView alloc]initWithFrame:CGRectMake(0, -kScreenWidth, self.frame.size.width, kScreenWidth)];
        whiteBG.frame = CGRectMake(0, 0, whiteBG.frame.size.width, whiteBG.frame.size.height);
        whiteBG.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBG];
        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        Tap.delegate = self;
        [self addGestureRecognizer:Tap];
        
        tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, self.frame.size.width, 50)];
        tip.numberOfLines = 0;
        tip.textColor = UIColorFromRGB(0x777777);
//        tip.font = [UIFont appFontWithSize:20];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"选择分类";
        [whiteBG addSubview:tip];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [kSelectionCategoryStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [button setTitle:obj forState:UIControlStateNormal];
//        [button.titleLabel setFont:[UIFont appFontWithSize:14]];

        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        if (kScreenWidth == 320.) {
            [button setDeFrameOrigin:CGPointMake( 8+(idx%4)*78, 80+(idx/4)*78)];
            button.deFrameSize = CGSizeMake(72, 72);
        } else if (kScreenWidth == 375.) {
            [button setDeFrameOrigin:CGPointMake(8+(idx%4)*92, 94+(idx/4)*92)];
            button.deFrameSize = CGSizeMake(84, 84);
        } else {
            [button setDeFrameOrigin:CGPointMake(8+(idx%4)*102., 104 + (idx/4) * 102)];
            button.deFrameSize = CGSizeMake(94, 94);
        }
        button.tag = idx+20000;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:button];
    }];
    
    if ([self viewWithTag:self.cateId]) {
        if ([[self viewWithTag:self.cateId]isKindOfClass:[UIButton class]]) {
            [((UIButton *)[self viewWithTag:self.cateId]) setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
        }
    }
}

- (void)show
{
    self.alpha = 0;
    [kAppDelegate.window addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
       // whiteBG.frame = CGRectMake(0, 0, whiteBG.frame.size.width, whiteBG.frame.size.height);
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
//    DDLogInfo(@"cate %@", kSelectionCategoryStringArray[_cateId]);
    if (self.tapButtonBlock) {
        self.tapButtonBlock(index, catename);
    }
    [self dismiss];
}

@end
