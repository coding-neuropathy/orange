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
#import "API.h"
//#import "GKTaobaoConfig.h"
//#import "GKTaobaoOAuthViewController.h"
#import "SignView.h"
#import "WXApi.h"

@interface LoginView () <UITextFieldDelegate, UIAlertViewDelegate>
{
@private
    UILabel * tip;
    UIView * whiteBG;
    UIImageView *logo;
}
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UIButton *sinaWeiboButton;
@property (nonatomic, strong) UIButton *taobaoButton;
@property (nonatomic, strong) UIButton * weixinBtn;
@property (assign, nonatomic) BOOL flag;

@property(nonatomic, strong) id<ALBBLoginService> loginService;
@property(nonatomic, strong) loginSuccessCallback loginSuccessCallback;
@property(nonatomic, strong) loginFailedCallback loginFailedCallback;

@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:kAppDelegate.window.frame];
    if (self) {
        // Initialization code
        self.flag = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        effectview.frame = CGRectMake(0, 0, kScreenWidth ,kScreenHeight);
        [self addSubview:effectview];
        
        
        whiteBG = [[UIView alloc]initWithFrame:CGRectMake(20, 80, self.frame.size.width-40, 300)];
        whiteBG.backgroundColor = [UIColor clearColor];
        whiteBG.layer.cornerRadius = 5.0f;
        whiteBG.layer.masksToBounds = YES;
        [self addSubview:whiteBG];
        
//        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        //[self addGestureRecognizer:Tap];
        
        UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
        [whiteBG addGestureRecognizer:Tap2];
        
        
        
        logo = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"login_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        logo.tintColor = UIColorFromRGB(0xffffff);
        logo.center = CGPointMake(whiteBG.deFrameWidth/2, 80);
        [whiteBG addSubview:logo];
        
        tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, whiteBG.deFrameWidth, 30)];
        tip.textColor = UIColorFromRGB(0xffffff);
        tip.font = [UIFont fontWithName:@"FultonsHand" size:16];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"Live Different";
        [whiteBG addSubview:tip];
        
        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(24.f, tip.deFrameBottom+12, whiteBG.deFrameWidth - 48, 45.f)];
        self.emailTextField.delegate = self;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailTextField.adjustsFontSizeToFitWidth = YES;
//        self.emailTextField.uitex
        self.emailTextField.borderStyle = UITextBorderStyleNone;
        //self.emailTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.emailTextField.layer.borderWidth = 0.5;
        self.emailTextField.font = [UIFont systemFontOfSize:14];
        self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        if (iOS7) {
            [self.emailTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = NSLocalizedStringFromTable(@"email", kLocalizedFile, nil);
            label.adjustsFontSizeToFitWidth = YES;
            self.emailTextField.leftView = label;
        }
        self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.emailTextField.placeholder = @"";
        self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.emailTextField.returnKeyType = UIReturnKeyNext;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
//        [self.emailTextField setTextColor:UIColorFromRGB(0x9d9e9f)];
        self.emailTextField.textColor = UIColorFromRGB(0xffffff);
        self.emailTextField.backgroundColor = [UIColor clearColor];
        
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.emailTextField.deFrameWidth,0.5)];
            H.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
            H.center = CGPointMake(self.emailTextField.deFrameWidth/2, self.emailTextField.deFrameHeight);
            [self.emailTextField addSubview:H];
        }
        
        [whiteBG addSubview:self.emailTextField];
        
        _forgotPasswordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 45)];
        [_forgotPasswordButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
        [_forgotPasswordButton setTitle:[NSString fontAwesomeIconStringForEnum:FAQuestionCircle] forState:UIControlStateNormal];
        [_forgotPasswordButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _forgotPasswordButton.backgroundColor = [UIColor clearColor];
        [self.forgotPasswordButton addTarget:self action:@selector(tapForgotPasswordButton) forControlEvents:UIControlEventTouchUpInside];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:self.emailTextField.frame];
        self.passwordTextField.delegate = self;
        self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10.f;
        self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextField.borderStyle = UITextBorderStyleNone;
        self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //self.passwordTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.passwordTextField.layer.borderWidth = 0.5;
        self.passwordTextField.secureTextEntry = YES;
        if (iOS7) {
            [self.passwordTextField setTintColor:UIColorFromRGB(0xffffff)];
        }
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = NSLocalizedStringFromTable(@"password", kLocalizedFile, nil);
            label.adjustsFontSizeToFitWidth = YES;
            self.passwordTextField.leftView = label;
        }
        self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        self.passwordTextField.rightView = _forgotPasswordButton;
        self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.passwordTextField.placeholder = @"";
        self.passwordTextField.font = [UIFont systemFontOfSize:14];
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordTextField.returnKeyType = UIReturnKeyGo;
        [self.passwordTextField setTextColor:UIColorFromRGB(0xffffff)];
        self.passwordTextField.backgroundColor = [UIColor clearColor];
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.passwordTextField.deFrameWidth,0.5)];
            H.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
            H.center = CGPointMake(self.passwordTextField.deFrameWidth/2, self.passwordTextField.deFrameHeight);
            [self.passwordTextField addSubview:H];
        }
        [whiteBG addSubview:self.passwordTextField];
        
        UIButton *loginButton = [[UIButton alloc]init];
        loginButton.frame = CGRectMake(0, 0,90, 40.f);
        loginButton.center = self.passwordTextField.center;
        loginButton.deFrameTop = self.passwordTextField.deFrameBottom + 15.;
//        loginButton.deFrameRight = whiteBG.deFrameWidth - 16;
        loginButton.layer.cornerRadius = 4;
        loginButton.layer.masksToBounds = YES;
        loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        loginButton.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.15];
        [loginButton setTitle:NSLocalizedStringFromTable(@"sign in", kLocalizedFile, nil) forState:UIControlStateNormal];
        [loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:loginButton];
        
        [whiteBG addSubview:self.taobaoButton];
        self.taobaoButton.center = loginButton.center;
        self.taobaoButton.deFrameTop = loginButton.deFrameBottom + 28.;
//        self.taobaoButton.deFrameLeft = self.sinaWeiboButton.deFrameRight + 15.;
        
        [whiteBG addSubview:self.sinaWeiboButton];
        self.sinaWeiboButton.center = self.taobaoButton.center;
        self.sinaWeiboButton.deFrameRight = self.taobaoButton.deFrameLeft - 20.;

        self.weixinBtn.center = self.taobaoButton.center;
        self.weixinBtn.deFrameLeft = self.taobaoButton.deFrameRight + 20.;
        [whiteBG addSubview:self.weixinBtn];
        

        
        
        UIButton * close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        close.backgroundColor = [UIColor clearColor];
        close.titleLabel.textAlignment = NSTextAlignmentLeft;
        close.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        [close setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        close.deFrameTop = 10;
        close.deFrameLeft = 16;
        [whiteBG addSubview:close];
        
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        _registerButton.backgroundColor = [UIColor clearColor];
        _registerButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_registerButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_registerButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_registerButton.titleLabel setFont: [UIFont systemFontOfSize:14]];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_registerButton addTarget:self action:@selector(tapRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.deFrameTop = 10;
        _registerButton.deFrameRight = whiteBG.deFrameWidth - 16;
        _registerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 40)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font =[UIFont fontWithName:kFontAwesomeFamilyName size:14];
            label.text = [NSString fontAwesomeIconStringForEnum:FAChevronRight];
            label.adjustsFontSizeToFitWidth = YES;
            label.deFrameRight = _registerButton.deFrameWidth;
            [_registerButton addSubview:label];

        }
        [whiteBG addSubview:_registerButton];
        
        whiteBG.deFrameHeight = self.taobaoButton.deFrameBottom + 40;
        if(kScreenHeight >= 548)
        {
            whiteBG.deFrameTop = 100;
        }
        else
        {
            whiteBG.deFrameTop = 50;
        }
        
        _loginService = [[TaeSDK sharedInstance]getService:@protocol(ALBBLoginService)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWeChatCode:) name:@"WechatAuthResp" object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - button
- (UIButton *)sinaWeiboButton
{
    if (!_sinaWeiboButton)
    {
        _sinaWeiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sinaWeiboButton.deFrameSize = CGSizeMake(44.f, 44.f);
//        _sinaWeiboButton.deFrameTop = self.passwordTextField.deFrameBottom+28;
//        _sinaWeiboButton.deFrameLeft = 24.f;
        _sinaWeiboButton.backgroundColor = UIColorFromRGB(0xf4f4f4);
        _sinaWeiboButton.layer.cornerRadius = 22;
        [_sinaWeiboButton addTarget:self action:@selector(tapSinaWeiboButton) forControlEvents:UIControlEventTouchUpInside];
        [_sinaWeiboButton setImage:[UIImage imageNamed:@"login_icon_weibo.png"] forState:UIControlStateNormal];
    }
    return _sinaWeiboButton;
}

- (UIButton *)taobaoButton
{
    if (!_taobaoButton) {
        _taobaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _taobaoButton.deFrameSize = CGSizeMake(44., 44.);
        _taobaoButton.backgroundColor = UIColorFromRGB(0xf4f4f4);
        _taobaoButton.layer.cornerRadius = 22;
//        self.taobaoButton.deFrameTop = self.passwordTextField.deFrameBottom+28;
//        self.taobaoButton.deFrameLeft = self.sinaWeiboButton.deFrameRight + 15.f;
        [_taobaoButton addTarget:self action:@selector(tapTaobaoButton) forControlEvents:UIControlEventTouchUpInside];
        [_taobaoButton setImage:[UIImage imageNamed:@"login_icon_taobao.png"] forState:UIControlStateNormal];
    }
    return _taobaoButton;
}

- (UIButton *)weixinBtn
{
    if (!_weixinBtn) {
        _weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinBtn.backgroundColor = UIColorFromRGB(0xf4f4f4);
        _weixinBtn.deFrameSize = CGSizeMake(44., 44.);
        _weixinBtn.layer.cornerRadius = _weixinBtn.deFrameWidth / 2.;
        [_weixinBtn setImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateNormal];
        [_weixinBtn addTarget:self action:@selector(TapWeixinBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinBtn;
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
    
    [API loginWithEmail:email password:password success:^(GKUser *user, NSString *session) {
        if (self.successBlock) {
            self.successBlock();
        }
        
        // analytics
        [AVAnalytics event:@"sign in" label:@"success"];
        [MobClick event:@"sign in" label:@"success"];
        
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"登录成功"]];
        [self dismiss];

    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        [AVAnalytics event:@"sign in" label:@"failure"];
        [MobClick event:@"sign in" label:@"failure"];
        
        switch (stateCode) {
        case 500:
            {
                [SVProgressHUD showImage:nil status:@"服务器出错!"];
                break;
            }
        case 400:
//                [SVProgressHUD showErrorWithStatus:message];
//            break;
        default:
//            [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:message];
            break;
        }
        
//        if ([type isEqualToString:@"email"]) {
//            [SVProgressHUD showImage:nil status:@"该邮箱不存在!"];
//        } else if ([type isEqualToString:@"password"]) {
//            [SVProgressHUD showImage:nil status:@"邮箱与密码不匹配!"];
//        }
    }];
}

- (void)tapForgotPasswordButton
{
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"忘记密码" message:@"输入注册时的邮箱\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
    [alertView show];
}


- (void)tapRegisterButton
{
    [whiteBG removeFromSuperview];
    for(UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            [view removeFromSuperview];
        }
    }
    
    SignView *view = [[SignView alloc] init];
    view.successBlock = self.successBlock;
    [view showFromLogin];
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        view.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    });
}

#pragma mark - three part
- (void)tapSinaWeiboButton
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
    
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (!error) {
//            [Passport sharedInstance].screenName = [object objectForKey:@"username"];
            [API loginWithSinaUserId:[object objectForKey:@"id"] sinaToken:[object objectForKey:@"access_token"] ScreenName:object[@"username"] success:^(GKUser *user, NSString *session) {
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
                    case 409:
                    {
                        [Passport sharedInstance].sinaAvatarURL = [object objectForKey:@"avatar"];
                        [Passport sharedInstance].screenName = [object objectForKey:@"username"];
                        [Passport sharedInstance].sinaUserID = [object objectForKey:@"id"];
                        [Passport sharedInstance].sinaToken = [object objectForKey:@"access_token"];
                        [self tapRegisterButton];
                        [SVProgressHUD showImage:nil status:@"补全信息"];
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
    
    [self dismiss];
}

- (void)tapTaobaoButton
{
    if(![[TaeSession sharedInstance] isLogin]){
        __weak __typeof(&*self)weakSelf = self;
        _loginSuccessCallback = ^(TaeSession * session) {
            [weakSelf finishedBaichuanWithSession:session];
        };
        
        _loginFailedCallback = ^(NSError * error) {
//            [self closeTaobaoView];
            [kAppDelegate.window makeKeyAndVisible];
            kAppDelegate.alertWindow.hidden = YES;
        };
        
        [kAppDelegate.alertWindow makeKeyAndVisible];
        [_loginService showLogin:kAppDelegate.alertWindow.rootViewController successCallback:_loginSuccessCallback failedCallback:_loginFailedCallback];
    }else{
        TaeSession *session=[TaeSession sharedInstance];
        [self finishedBaichuanWithSession:session];
    }
}

- (void)finishedBaichuanWithSession:(TaeSession *)session
{
    [Passport sharedInstance].taobaoId = [session getUser].userId;
    [Passport sharedInstance].screenName = [session getUser].nick;
    [SVProgressHUD show];
    [API loginWithBaichuanUid:[session getUser].userId nick:[session getUser].nick  success:^(GKUser *user, NSString *session) {
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
        if (self.successBlock) {
            self.successBlock();
        }
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"登录成功"]];
        [self dismiss];

    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
        [SVProgressHUD dismiss];

    }];
}

- (void)TapWeixinBtn:(id)sender
{
    if([WXApi isWXAppInstalled])
    {
        SendAuthReq * req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        //    req.scope = @"snsapi_base";
        req.state = @"guoku_signin_wechat";
        [WXApi sendReq:req];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"don't install wechat", kLocalizedFile, nil)];
    }
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

- (void)resignResponder
{
    if(kScreenHeight >= 548)
    {
        whiteBG.deFrameTop = 100;
    }
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)show
{
    self.alpha = 0;
    
    [kAppDelegate.window addSubview:self];
    
    [UIView animateWithDuration:0.0 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.0 animations:^{
        } completion:^(BOOL finished) {
            
        }];
    }];
    [AVAnalytics beginLogPageView:@"SignInView"];
    [MobClick beginLogPageView:@"SignInView"];
}

- (void)dismiss
{
    self.alpha = 1;
    [UIView animateWithDuration:0.0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [AVAnalytics endLogPageView:@"SignInView"];
    [MobClick endLogPageView:@"SignInView"];
}

- (void)showFromRegister
{
    
    [kAppDelegate.window addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    whiteBG.alpha = 0;
    [UIView animateWithDuration:0.0 animations:^{
        
    } completion:^(BOOL finished) {
        whiteBG.alpha = 1;
        
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *email = [alertView textFieldAtIndex:0].text;
        if (email && email.length > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [API forgetPasswordWithEmail:email success:^(BOOL success) {
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

#pragma mark - Notification
- (void)postWeChatCode:(NSNotification *)notification
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    SendAuthResp *resp = [notification valueForKey:@"object"];
    
    NSDictionary * json = [API getWeChatAuthWithAppKey:kGK_WeixinShareKey Secret:KGK_WeixinSecret Code:resp.code];
    
    NSDictionary * userInfo = [API getWeChatUserInfoWithAccessToken:[json valueForKey:@"access_token"] OpenID:[json valueForKey:@"openid"]];
    
    DDLogInfo(@"user info %@", userInfo);
    
    [API loginWithWeChatWithUnionid:[userInfo valueForKey:@"unionid"] Nickname:[userInfo valueForKey:@"nickname"] HeaderImgURL:[userInfo valueForKey:@"headimgurl"] success:^(GKUser *user, NSString *session) {
        if (self.successBlock) {
            self.successBlock();
        }
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@", smile, @"登录成功"]];
        [self dismiss];
    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
    
}

@end
