//
//  SignInView.h
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInViewDelegate <NSObject>

- (void)tapSignBtnWithEmail:(NSString *)email Password:(NSString *)password;
- (void)tapForgetBtn:(id)sender;

@optional
- (void)tapWeiBoBtn:(id)sender;
- (void)tapTaobaoBtn:(id)sender;
- (void)tapWeChatBtn:(id)sender;

- (void)handleTapOnePassword:(id)sender;

@end

@interface SignInView : UIView

@property (strong, nonatomic) UITextField   *emailTextField;
@property (strong, nonatomic) UITextField   *passwordTextField;

@property (weak, nonatomic) id<SignInViewDelegate> delegate;

- (void)resignResponder;

@end
