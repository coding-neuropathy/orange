//
//  EntityPopView.h
//  orange
//
//  Created by 谢家欣 on 15/8/23.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityPopView : UIView

@property (strong, nonatomic) GKEntity * entity;

- (void)showInWindowWithAnimated:(BOOL)animated;

@end
