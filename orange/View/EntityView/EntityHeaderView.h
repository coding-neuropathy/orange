//
//  EntityHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/3/12.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntityHeaderViewDelegate <NSObject>

- (void)TapLikeBtnAction:(id)sender;
- (void)TapBuyBtnAction:(id)sender;

@end

@interface EntityHeaderView : UIView

@property (nonatomic, strong) GKEntity *entity;
@property (weak, nonatomic) id<EntityHeaderViewDelegate> delegate;

@end
