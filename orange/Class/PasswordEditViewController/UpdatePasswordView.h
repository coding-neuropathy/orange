//
//  UpdatePasswordView.h
//  orange
//
//  Created by 谢家欣 on 16/9/28.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdatePasswordViewDelegate <NSObject>

- (void)handleOnePassword:(id)sender;

@end

@interface UpdatePasswordView : UIView

@property (nonatomic, strong) UITextField   *passwordTextField;
@property (nonatomic, strong) UITextField   *refreshPasswordTextField;
@property (nonatomic, strong) UITextField   *confirmPasswordTextField;

@property (nonatomic, weak) id<UpdatePasswordViewDelegate> delegate;

@end
