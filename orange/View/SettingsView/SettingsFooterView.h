//
//  SettingsFooterView.h
//  orange
//
//  Created by 谢家欣 on 15/3/30.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsFooterViewDelegate <NSObject>

- (void)TapLoginBtnAction;
- (void)TapLogoutBtnAction;

@end

@interface SettingsFooterView : UIView

@property (assign, nonatomic) BOOL is_login;
@property (weak, nonatomic) id<SettingsFooterViewDelegate> delegate;

@end
