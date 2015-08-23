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
@property (copy, nonatomic) void (^tapLikeBtn)(UIButton * likeBtn);
@property (copy, nonatomic) void (^tapNoteBtn)(UIButton * noteBtn);
@property (copy, nonatomic) void (^tapBuyBtn)(UIButton * buyBtn);

- (void)showInWindowWithAnimated:(BOOL)animated;

@end
