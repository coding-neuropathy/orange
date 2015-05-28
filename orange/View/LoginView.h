//
//  LoginView.h
//  Blueberry
//
//  Created by huiter on 13-10-28.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, copy) void (^successBlock)();
//@property (nonatomic, strong) UIViewController * parentController;
@property (nonatomic, strong) UIWindow * window;

- (void)show;
- (void)dismiss;
- (void)showFromRegister;
@end
