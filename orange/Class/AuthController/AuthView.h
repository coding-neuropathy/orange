//
//  AuthView.h
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthViewDelegate <NSObject>

- (void)tapDismissButton;
- (void)tapSignInButton:(id)sender;
- (void)tapSignUpButton:(id)sender;

@optional
- (void)gotoAgreementWithURL:(NSURL *)url;

@end

@interface AuthView : UIView

@property (weak, nonatomic) id<AuthViewDelegate> delegate;

@end
