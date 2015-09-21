//
//  tipView.m
//  orange
//
//  Created by huiter on 15/9/21.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "tipView.h"

@implementation tipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:kAppDelegate.window.frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIButton * mask = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight)];
        mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.38];
        [mask addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mask];
        
        UIButton * tip = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        tip.backgroundColor= UIColorFromRGB(0x6cabf0);
        [tip setTitle:@"在发现页查看「精选」分类" forState:UIControlStateNormal];
        [tip setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        tip.titleLabel.font = [UIFont systemFontOfSize:16];
        tip.enabled = NO;
        
        [mask addSubview:tip];
        tip.deFrameBottom = mask.deFrameHeight;
        
        UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_icon"]];
        icon.center = CGPointMake(3*kScreenWidth/8, 0);
        icon.deFrameTop = tip.deFrameBottom-2;
        [self addSubview:icon];
    }

    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

- (void)buttonAction
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchV4.10"];
        [[NSUserDefaults standardUserDefaults] synchronize];
          [self removeFromSuperview];
    }];

}

@end
