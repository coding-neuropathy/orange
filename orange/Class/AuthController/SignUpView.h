//
//  SignUpView.h
//  orange
//
//  Created by 谢家欣 on 16/8/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpViewDelegate <NSObject>

- (void)tapSignUpBtnWithNickname:(NSString *)nickname
                           Email:(NSString *)email
                            Passwd:(NSString *)passwd;

@optional
- (void)gotoAgreementWithURL:(NSURL *)url;

@end

@interface SignUpView : UIView

@property (weak, nonatomic) id<SignUpViewDelegate> delegate;

- (void)resignResponder;

@end
