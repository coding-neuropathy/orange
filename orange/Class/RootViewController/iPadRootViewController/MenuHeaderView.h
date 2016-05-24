//
//  MenuHeaderView.h
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuHeaderViewDelegate <NSObject>

- (void)TapAvatarBtn;

@end

@interface MenuHeaderView : UIView

@property (weak, nonatomic) id<MenuHeaderViewDelegate> delegate;

@end
