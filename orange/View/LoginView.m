//
//  LoginView.m
//  Blueberry
//
//  Created by huiter on 13-10-28.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "LoginView.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "GKAPI.h"
#import "GKTaobaoConfig.h"
#import "GKTaobaoOAuthViewController.h"
#import "SignView.h"

@interface LoginView () <UITextFieldDelegate, UIAlertViewDelegate,GKTaobaoOAuthViewControllerDelegate>
{
@private
    UILabel * tip;
    UIView * whiteBG;
}
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UIButton *sinaWeiboButton;
@property (nonatomic, strong) UIButton *taobaoButton;
@property (assign, nonatomic) BOOL flag;
@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:kAppDelegate.window.frame];
    if (self) {
        // Initialization code
        self.flag = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        whiteBG = [[UIView alloc]initWithFrame:CGRectMake(20, 80, self.frame.size.width-40, 300)];
        whiteBG.backgroundColor = [UIColor whiteColor];
        whiteBG.layer.cornerRadius = 0.0f;
        whiteBG.layer.masksToBounds = YES;
        [self addSubview:whiteBG];
        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:Tap];
        
        UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
        [whiteBG addGestureRecognizer:Tap2];
        
        tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, whiteBG.deFrameWidth, 30)];
        tip.textColor = UIColorFromRGB(0x777777);
        tip.font = [UIFont systemFontOfSize:20];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"欢迎回来";
        [whiteBG addSubview:tip];
        
        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.f, tip.deFrameBottom+32, whiteBG.deFrameWidth - 30, 45.f)];
        self.emailTextField.delegate = self;
        self.emailTextField.borderStyle = UITextBorderStyleNone;
        //self.emailTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.emailTextField.layer.borderWidth = 0.5;
        self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        if (iOS7) {
            [self.emailTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
        self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.emailTextField.placeholder = @"邮箱";
        self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.emailTextField.returnKeyType = UIReturnKeyNext;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [self.emailTextField setTextColor:UIColorFromRGB(0x666666)];
        self.emailTextField.backgroundColor = UIColorFromRGB(0xf4f4f4);
        
        [whiteBG addSubview:self.emailTextField];
        
        _forgotPasswordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 45)];
        [_forgotPasswordButton setImage:[UIImage imageNamed:@"button_icon_forgot.png"] forState:UIControlStateNormal];
        _forgotPasswordButton.backgroundColor = [UIColor clearColor];
        [self.forgotPasswordButton addTarget:self action:@selector(tapForgotPasswordButton) forControlEvents:UIControlEventTouchUpInside];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:self.emailTextField.frame];
        self.passwordTextField.delegate = self;
        self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10.f;
        self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextField.borderStyle = UITextBorderStyleNone;
        //self.passwordTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.passwordTextField.layer.borderWidth = 0.5;
        self.passwordTextField.secureTextEntry = YES;
        if (iOS7) {
            [self.passwordTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        self.passwordTextField.rightView = _forgotPasswordButton;
        self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.passwordTextField.placeholder = @"密码";
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordTextField.returnKeyType = UIReturnKeyGo;
        [self.passwordTextField setTextColor:UIColorFromRGB(0x666666)];
        self.passwordTextField.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [whiteBG addSubview:self.passwordTextField];
        
        UIButton *loginButton = [[UIButton alloc]init];
        loginButton.frame = CGRectMake(15.f, self.passwordTextField.deFrameBottom + 23, whiteBG.deFrameWidth - 30, 45.f);
        loginButton.layer.cornerRadius = 2;
        loginButton.layer.masksToBounds = YES;
        loginButton.backgroundColor = UIColorFromRGB(0x457ebd);
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:loginButton];
        

        
        _sinaWeiboButton = [[UIButton alloc] init];
        self.sinaWeiboButton.deFrameSize = CGSizeMake(44.f, 44.f);
        self.sinaWeiboButton.deFrameTop = loginButton.deFrameBottom+18;
        self.sinaWeiboButton.deFrameLeft = 15.f;
        self.sinaWeiboButton.backgroundColor = UIColorFromRGB(0xf4f4f4);
        self.sinaWeiboButton.layer.cornerRadius = 22;
        [self.sinaWeiboButton addTarget:self action:@selector(tapSinaWeiboButton) forControlEvents:UIControlEventTouchUpInside];
        [self.sinaWeiboButton setImage:[UIImage imageNamed:@"login_icon_weibo.png"] forState:UIControlStateNormal];
        [whiteBG addSubview:self.sinaWeiboButton];
        
        _taobaoButton = [[UIButton alloc] init];
        self.taobaoButton.deFrameSize = CGSizeMake(44.f, 44.f);
        self.taobaoButton.backgroundColor = UIColorFromRGB(0xf4f4f4);
        self.taobaoButton.layer.cornerRadius = 22;
        self.taobaoButton.deFrameTop = loginButton.deFrameBottom+18;
        self.taobaoButton.deFrameLeft = self.sinaWeiboButton.deFrameRight + 15.f;
        [self.taobaoButton addTarget:self action:@selector(tapTaobaoButton) forControlEvents:UIControlEventTouchUpInside];
        [self.taobaoButton setImage:[UIImage imageNamed:@"login_icon_taobao.png"] forState:UIControlStateNormal];
        [whiteBG addSubview:self.taobaoButton];
        
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.taobaoButton.deFrameRight + 15.f, loginButton.deFrameBottom+18, whiteBG.deFrameWidth-self.taobaoButton.deFrameRight -15 , 44.f)];
        _registerButton.backgroundColor = [UIColor clearColor];
        _registerButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_registerButton setTitle:@"注册帐号 >>" forState:UIControlStateNormal];
        [_registerButton setTitleColor:UIColorFromRGB(0xdcdcdc) forState:UIControlStateNormal];
        [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_registerButton addTarget:self action:@selector(tapRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:_registerButton];
        
        whiteBG.deFrameHeight = self.taobaoButton.deFrameBottom + 20;
        if(kScreenHeight >= 548)
        {
            whiteBG.deFrameTop = 140;
        }
        else
        {
            whiteBG.deFrameTop = 50;
        }

    }
    return self;
}

#pragma mark - Selector Method

- (void)tapLoginButton
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (!email || email.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入邮箱"];
        return;
    }
    
    if (![email isValidEmail]) {
        [SVProgressHUD showImage:nil status:@"请输入正确格式的邮箱"];
        return;
    }
    
    if (!password || password.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    
    [GKAPI loginWithEmail:email password:password success:^(GKUser *user, NSString *session) {
        if (self.successBlock) {
            self.successBlock();
        }
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"登录成功"]];
        [self dismiss];

    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        switch (stateCode) {
        case 500:
            {
                [SVProgressHUD showImage:nil status:@"服务器出错!"];
                break;
            }
            
        default:
                [SVProgressHUD dismiss];
                break;
        }
        
        if ([type isEqualToString:@"email"]) {
            [SVProgressHUD showImage:nil status:@"该邮箱不存在!"];
        } else if ([type isEqualToString:@"password"]) {
            [SVProgressHUD showImage:nil status:@"邮箱与密码不匹配!"];
        }
    }];
}

- (void)tapForgotPasswordButton
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"忘记密码" message:@"输入注册时的邮箱\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
    [alertView show];
}

- (void)tapSinaWeiboButton
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
    
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (!error) {
            [GKAPI loginWithSinaUserId:[object objectForKey:@"id"] sinaToken:[object objectForKey:@"access_token"] success:^(GKUser *user, NSString *session) {
                if (self.successBlock) {
                    self.successBlock();
                }
                [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"登录成功"]];
                [self dismiss];
            } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
                switch (stateCode) {
                    case 500:
                    {
                        [SVProgressHUD showImage:nil status:@"服务器出错!"];
                        break;
                    }
                        
                    default:
                        [SVProgressHUD dismiss];
                        break;
                }


            }];
        }
        else
        {
            [SVProgressHUD showImage:nil status:@"登录失败"];
        }
    } toPlatform:AVOSCloudSNSSinaWeibo];
}

- (void)tapTaobaoButton
{
//    UIViewController * controller = [[UIViewController alloc] init];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    
//    if(![[TaeSession sharedInstance] isLogin]){
//        [[TaeSDK sharedInstance] showLogin:nav  successCallback:^(TaeSession *session) {
//            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@, user id %@",[session getUser],[session getLoginTime], [session getUser].userId];
//            NSLog(@"%@", tip);
//        } failedCallback:^(NSError *error) {
//            
//            NSString *tip=[NSString stringWithFormat:@"登录失败:%@",error];
//            NSLog(@"%@", tip);
//            
//        }];
//    }else{
//        TaeSession *session=[TaeSession sharedInstance];
//        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@, user id %@",[session getUser],[session getLoginTime], [session getUser].userId];
//        NSLog(@"%@", tip);
//    }
    GKTaobaoOAuthViewController *vc = [[GKTaobaoOAuthViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeTaobaoView)];
    vc.navigationItem.leftBarButtonItem = closeButtonItem;
    
    [kAppDelegate.alertWindow makeKeyAndVisible];
    [kAppDelegate.alertWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)closeTaobaoView
{
    [kAppDelegate.alertWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        if(kScreenHeight >= 548)
        {
            whiteBG.deFrameTop = 60;
        }
    }];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.emailTextField) {
            [self.passwordTextField becomeFirstResponder];
        } else {
            [self tapLoginButton];
        }
    }
    return YES;
}

- (void)show
{
    self.alpha = 0;

    [kAppDelegate.window addSubview:self];
   
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)dismiss
{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)tapRegisterButton
{
    [whiteBG removeFromSuperview];
    SignView *view = [[SignView alloc] init];
    view.successBlock = self.successBlock;
    [view showFromLogin];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self removeFromSuperview];
    });
}

- (void)resignResponder
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *email = [alertView textFieldAtIndex:0].text;
        if (email && email.length > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [GKAPI forgetPasswordWithEmail:email success:^(BOOL success) {
                if (success) {
                    [SVProgressHUD showImage:nil status:@"请检查邮箱，重设密码。"];
                }
            } failure:^(NSInteger stateCode) {
                if (stateCode == 400) {
                    [SVProgressHUD showImage:nil status:@"该邮箱不存在!"];
                } else {
                    [SVProgressHUD showImage:nil status:@"请求失败!"];
                }
            }];
        } else {
            [SVProgressHUD showImage:nil status:@"请输入注册时使用的邮箱"];
        }
    }
}

#pragma mark - GKTaobaoOAuthViewControllerDelegate

- (void)TaoBaoGrantFinished
{
    if (self.flag == YES) {
        return;
    }
    self.flag = YES;
    
    NSDictionary *taobaoInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kTaobaoGrantInfo];
    
    NSString *taobaoUserId = taobaoInfo[@"taobao_id"];
    NSString *taobaoToken = taobaoInfo[@"access_token"];
    [Passport sharedInstance].screenName = taobaoInfo[@"screen_name"];
    [Passport sharedInstance].taobaoId = taobaoUserId;
    [Passport sharedInstance].taobaoToken = taobaoToken;
    [GKAPI loginWithTaobaoUserId:taobaoUserId taobaoToken:taobaoToken success:^(GKUser *user, NSString *session) {
        if (self.successBlock) {
            self.successBlock();
        }
        [self dismiss];
        [SVProgressHUD dismiss];
        [self closeTaobaoView];
        
    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        [SVProgressHUD dismiss];
        [self closeTaobaoView];
        [self tapRegisterButton];
    }];
}



@end
