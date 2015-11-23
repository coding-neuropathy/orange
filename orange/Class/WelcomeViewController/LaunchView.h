//
//  LaunchView.h
//  orange
//
//  Created by 谢家欣 on 15/11/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LaunchViewDelegate <NSObject>

- (void)TapActionBtn:(id)sender;

@end

@interface LaunchView : UIView

@property (strong, nonatomic) GKLaunch * launch;
@property (weak, nonatomic) id<LaunchViewDelegate> delegate;

@end
