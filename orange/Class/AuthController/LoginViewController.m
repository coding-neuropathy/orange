//
//  LoginViewController.m
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "LoginViewController.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "API.h"
#import "WXApi.h"

@interface LoginViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *solgen;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UIButton *sinaWeiboButton;
@property (nonatomic, strong) UIButton *taobaoButton;
@property (nonatomic, strong) UIButton * weixinBtn;
@property (nonatomic, strong) UIButton * close;

@property(nonatomic, strong) id<ALBBLoginService> loginService;
@property(nonatomic, strong) loginSuccessCallback loginSuccessCallback;
@property(nonatomic, strong) loginFailedCallback loginFailedCallback;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    effectview.frame = CGRectMake(0, 0, kScreenWidth ,kScreenHeight);
    [self.view addSubview:effectview];
    
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [self.view addGestureRecognizer:tap];
    
    _loginService = [[TaeSDK sharedInstance]getService:@protocol(ALBBLoginService)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWeChatCode:) name:@"WechatAuthResp" object:nil];
    
    
    [self.view addSubview:self.close];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.logo];
    [self.view addSubview:self.solgen];
    
    
    if(kScreenHeight >= 548)
    {
        self.logo.deFrameTop = 140;
        self.solgen.deFrameTop = 180;
    }
    else
    {
        self.logo.deFrameTop = 80;
        self.solgen.deFrameTop = 120;
    }
    

    
    self.emailTextField.deFrameTop = self.solgen.deFrameBottom + 20;
    [self.view addSubview:self.emailTextField];
    
    self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10;
    [self.view addSubview:self.passwordTextField];
    
    
    self.loginButton.center = CGPointMake(kScreenWidth/2, 20);
    self.loginButton.deFrameTop = self.passwordTextField.deFrameBottom +30;
    [self.view addSubview:self.loginButton];
    
    
    [self configSNS];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIButton *)close
{
    
    if (!_close) {
        UIButton * close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        close.backgroundColor = [UIColor clearColor];
        close.titleLabel.textAlignment = NSTextAlignmentLeft;
        close.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        [close setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        close.deFrameTop = 30;
        close.deFrameLeft = 26;
        _close = close;
    }
    return _close;
}

- (UIButton * )registerButton
{
    if (!_registerButton) {
        
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        _registerButton.backgroundColor = [UIColor clearColor];
        _registerButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_registerButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_registerButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_registerButton.titleLabel setFont: [UIFont systemFontOfSize:14]];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_registerButton addTarget:self action:@selector(tapRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.deFrameTop = 30;
        _registerButton.deFrameRight = kScreenWidth - 26;
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
        
    }
    return _registerButton;
}

- (UIImageView *)logo
{
    if (!_logo) {
        _logo = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"login_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _logo.tintColor = UIColorFromRGB(0xffffff);
        _logo.center = CGPointMake(kScreenWidth/2, 120);
    }
    return _logo;
}

- (UILabel *)solgen
{
    if (!_solgen) {
        _solgen = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 30)];
        _solgen.textColor = UIColorFromRGB(0xffffff);
        _solgen.font = [UIFont fontWithName:@"FultonsHand" size:16];
        _solgen.textAlignment = NSTextAlignmentCenter;
        _solgen.text = @"Live Different";
        _solgen.center = CGPointMake(kScreenWidth/2, 160);
    }
    return _solgen;
}

- (UITextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(24.f,0, kScreenWidth - 48, 45.f)];
        _emailTextField.delegate = self;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.adjustsFontSizeToFitWidth = YES;
        _emailTextField.borderStyle = UITextBorderStyleNone;
        _emailTextField.font = [UIFont systemFontOfSize:14];
        _emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        _emailTextField.leftViewMode = UITextFieldViewModeAlways;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.placeholder = @"";
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.textColor = UIColorFromRGB(0xffffff);
        _emailTextField.backgroundColor = [UIColor clearColor];
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = NSLocalizedStringFromTable(@"email", kLocalizedFile, nil);
            label.adjustsFontSizeToFitWidth = YES;
            _emailTextField.leftView = label;
        }
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, _emailTextField.deFrameWidth,0.5)];
            H.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
            H.center = CGPointMake(_emailTextField.deFrameWidth/2, _emailTextField.deFrameHeight);
            [_emailTextField addSubview:H];
        }

    }
    return _emailTextField;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:self.emailTextField.frame];
        _passwordTextField.delegate = self;
        _passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10.f;
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.placeholder = @"";
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        [_passwordTextField setTextColor:UIColorFromRGB(0xffffff)];
        _passwordTextField.backgroundColor = [UIColor clearColor];
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = NSLocalizedStringFromTable(@"password", kLocalizedFile, nil);
            label.adjustsFontSizeToFitWidth = YES;
            _passwordTextField.leftView = label;
        }
        
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, _passwordTextField.deFrameWidth,0.5)];
            H.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
            H.center = CGPointMake(_passwordTextField.deFrameWidth/2, _passwordTextField.deFrameHeight);
            [_passwordTextField addSubview:H];
        }
        
        _forgotPasswordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 45)];
        [_forgotPasswordButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
        [_forgotPasswordButton setTitle:[NSString fontAwesomeIconStringForEnum:FAQuestionCircle] forState:UIControlStateNormal];
        [_forgotPasswordButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _forgotPasswordButton.backgroundColor = [UIColor clearColor];
        [_forgotPasswordButton addTarget:self action:@selector(tapForgotPasswordButton) forControlEvents:UIControlEventTouchUpInside];
        _passwordTextField.rightView = _forgotPasswordButton;
        
    }
    return _passwordTextField;
}

- (UIButton *)loginButton
{
    if(!_loginButton)
    {
        _loginButton = [[UIButton alloc]init];
        _loginButton.frame = CGRectMake(0, 0,90, 40.f);
        _loginButton.center = CGPointMake(kScreenWidth/2, 0);
        _loginButton.layer.cornerRadius = 4;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.enabled = NO;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _loginButton.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.15];
        [_loginButton setTitle:NSLocalizedStringFromTable(@"sign in", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithRed:255.f green:255.f blue:255.f alpha:0.45] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
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



- (void)configSNS
{
    if([WXApi isWXAppInstalled] && [AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo]){
        [self.view addSubview:self.taobaoButton];
        self.taobaoButton.center = self.loginButton.center;
        self.taobaoButton.deFrameTop = self.loginButton.deFrameBottom + 40.;
        
        [self.view addSubview:self.sinaWeiboButton];
        self.sinaWeiboButton.center = self.taobaoButton.center;
        self.sinaWeiboButton.deFrameRight = self.taobaoButton.deFrameLeft - 20.;
        
        self.weixinBtn.center = self.taobaoButton.center;
        self.weixinBtn.deFrameLeft = self.taobaoButton.deFrameRight + 20.;
        [self.view addSubview:self.weixinBtn];
    } else if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo] && ![WXApi isWXAppInstalled]) {
        [self.view addSubview:self.taobaoButton];
        self.taobaoButton.center = self.loginButton.center;
        self.taobaoButton.deFrameTop = self.loginButton.deFrameBottom + 40.;
        self.taobaoButton.deFrameLeft = self.taobaoButton.deFrameLeft + 40.;
        
        [self.view addSubview:self.sinaWeiboButton];
        self.sinaWeiboButton.center = self.taobaoButton.center;
        self.sinaWeiboButton.deFrameRight = self.taobaoButton.deFrameLeft - 40.;
    } else if ([WXApi isWXAppInstalled] && ![AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo]) {
        [self.view addSubview:self.taobaoButton];
        self.taobaoButton.center = self.loginButton.center;
        self.taobaoButton.deFrameTop = self.loginButton.deFrameBottom + 40.;
        
//        [self.view addSubview:self.sinaWeiboButton];
//        self.sinaWeiboButton.center = self.taobaoButton.center;
//        self.sinaWeiboButton.deFrameRight = self.taobaoButton.deFrameLeft - 20.;
        
        self.weixinBtn.center = self.taobaoButton.center;
        self.weixinBtn.deFrameLeft = self.taobaoButton.deFrameRight + 40.;
        [self.view addSubview:self.weixinBtn];
        
    } else {
        [self.view addSubview:self.taobaoButton];
        self.taobaoButton.center = self.loginButton.center;
        self.taobaoButton.deFrameTop = self.loginButton.deFrameBottom + 40.;
//        self.taobaoButton.deFrameLeft = self.taobaoButton.deFrameLeft + 40.;
        
//        [self.view addSubview:self.sinaWeiboButton];
//        self.sinaWeiboButton.center = self.taobaoButton.center;
//        self.sinaWeiboButton.deFrameRight = self.taobaoButton.deFrameLeft - 40.;
    }
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismiss
{
    [self.authController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)resignResponder
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)tapRegisterButton
{
    [self.authController setSelectedWithType:@"register"];
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
        
//        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"登录成功"]];
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
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
            default:
                [SVProgressHUD showErrorWithStatus:message];
                break;
        }
        
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


#pragma mark - three part
- (void)tapSinaWeiboButton
{
    //    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
//    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (!error) {
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
    
//    [self dismiss];
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
        req.state = @"guoku_signin_wechat";
        [WXApi sendReq:req];
    } else {
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *email = [alertView textFieldAtIndex:0].text;
        if (email && email.length > 0) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
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
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
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
