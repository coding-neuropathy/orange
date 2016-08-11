//
//  RegisterViewController.m
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "WXApi.h"

#import "SignUpView.h"

@interface RegisterViewController ()<UITextFieldDelegate, UIAlertViewDelegate, SignUpViewDelegate>

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *solgen;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UIButton *sinaWeiboButton;
@property (nonatomic, strong) UIButton *taobaoButton;
@property (nonatomic, strong) UIButton * weixinBtn;
@property (nonatomic, strong) UIButton * close;

@property (strong, nonatomic) SignUpView * signUpView;

@end

@implementation RegisterViewController

#pragma mark - lazy load view
- (SignUpView *)signUpView
{
    if (!_signUpView) {
        _signUpView = [[SignUpView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        _signUpView.delegate = self;
    }
    return _signUpView;
}

- (void)loadView
{
    self.view = self.signUpView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil);
    
//    self.view.backgroundColor = [UIColor clearColor];
//    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
//    effectview.frame = CGRectMake(0, 0, kScreenWidth ,kScreenHeight);
//    [self.view addSubview:effectview];
//    
//    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
//    [self.view addGestureRecognizer:tap];
//    
//    
//    [self.view addSubview:self.close];
//    [self.view addSubview:self.loginButton];
//    [self.view addSubview:self.logo];
//    [self.view addSubview:self.solgen];
//    
//    if(kScreenHeight >= 548)
//    {
//        self.logo.deFrameTop = 140;
//        self.solgen.deFrameTop = 180;
//    }
//    else
//    {
//        self.logo.deFrameTop = 80;
//        self.solgen.deFrameTop = 120;
//    }
//    
//    self.nicknameTextField.deFrameTop = self.solgen.deFrameBottom + 20;
//    [self.view addSubview:self.nicknameTextField];
//    
//    self.emailTextField.deFrameTop = self.nicknameTextField.deFrameBottom + 10;
//    [self.view addSubview:self.emailTextField];
//    
//    self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10;
//    [self.view addSubview:self.passwordTextField];
//    
//    
//    self.registerButton.center = CGPointMake(kScreenWidth/2, 20);
//    self.registerButton.deFrameTop = self.passwordTextField.deFrameBottom +30;
//    [self.view addSubview:self.registerButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"SignUpView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"SignUpView"];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (UIButton * )loginButton
{
    if (!_loginButton) {
        
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_loginButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"sign in", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont: [UIFont systemFontOfSize:14]];
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.deFrameTop = 30;
        _loginButton.deFrameRight = kScreenWidth - 26;
        _loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 40)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font =[UIFont fontWithName:kFontAwesomeFamilyName size:14];
            label.text = [NSString fontAwesomeIconStringForEnum:FAChevronRight];
            label.adjustsFontSizeToFitWidth = YES;
            label.deFrameRight = _loginButton.deFrameWidth;
            [_loginButton addSubview:label];
            
        }
        
    }
    return _loginButton;
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

- (UITextField *)nicknameTextField
{
    if (!_nicknameTextField) {
        _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(24.f,0, kScreenWidth - 48, 45.f)];
        _nicknameTextField.delegate = self;
        _nicknameTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _nicknameTextField.adjustsFontSizeToFitWidth = YES;
        _nicknameTextField.borderStyle = UITextBorderStyleNone;
        _nicknameTextField.font = [UIFont systemFontOfSize:14];
        _nicknameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nicknameTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _nicknameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        _nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nicknameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nicknameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _nicknameTextField.placeholder = @"";
        _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nicknameTextField.returnKeyType = UIReturnKeyNext;
        _nicknameTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _nicknameTextField.textColor = UIColorFromRGB(0xffffff);
        _nicknameTextField.backgroundColor = [UIColor clearColor];
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
            label.textColor = UIColorFromRGB(0xffffff);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = NSLocalizedStringFromTable(@"nickname", kLocalizedFile, nil);
            label.adjustsFontSizeToFitWidth = YES;
            _nicknameTextField.leftView = label;
        }
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, _nicknameTextField.deFrameWidth,0.5)];
            H.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
            H.center = CGPointMake(_nicknameTextField.deFrameWidth/2, _nicknameTextField.deFrameHeight);
            [_nicknameTextField addSubview:H];
        }
        
    }
    return _nicknameTextField;
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
        _passwordTextField.rightView = _forgotPasswordButton;
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
        
    }
    return _passwordTextField;
}

- (UIButton *)registerButton
{
    if(!_registerButton)
    {
        UIButton *registerButton = [[UIButton alloc]init];
        registerButton.frame = CGRectMake(0, 0,90, 40.f);
        registerButton.center = CGPointMake(kScreenWidth/2, 0);
        registerButton.layer.cornerRadius = 4;
        registerButton.layer.masksToBounds = YES;
        registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        registerButton.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.15];
        [registerButton setTitle:NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil) forState:UIControlStateNormal];
        [registerButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(tapRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        _registerButton = registerButton;
    }
    return _registerButton;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.nicknameTextField) {
            [self.emailTextField becomeFirstResponder];
        } else if (textField == self.emailTextField) {
            [self.passwordTextField becomeFirstResponder];
        } else {
            [self tapRegisterButton];
        }
    }
    return YES;
}


- (void)dismiss
{
    [self.authController dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)resignResponder
//{
//    [self.nicknameTextField resignFirstResponder];
//    [self.emailTextField resignFirstResponder];
//    [self.passwordTextField resignFirstResponder];
//}
//
//- (void)tapLoginButton
//{
//    [self.authController setSelectedWithType:@"login"];
//}

- (void)tapRegisterButton
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *nickname = self.nicknameTextField.text;
    
    if (!nickname || nickname.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入昵称"];
        return;
    }
    
    if (nickname.length < 3) {
        [SVProgressHUD showImage:nil status:@"昵称过短"];
        return;
    }
    
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
    
    if (password.length < 6) {
        [SVProgressHUD showImage:nil status:@"密码至少6位"];
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [API registerWithEmail:email password:password nickname:nickname imageData:nil sinaUserId:[Passport sharedInstance].sinaUserID sinaToken:[Passport sharedInstance].sinaToken                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    taobaoUserId:[Passport sharedInstance].taobaoId taobaoToken:[Passport sharedInstance].taobaoToken screenName:[Passport sharedInstance].screenName success:^(GKUser *user, NSString *session) {
        
        // analytics
//        [AVAnalytics event:@"sign up" label:@"success"];
        [MobClick event:@"sign up" label:@"success"];
        
        if (self.successBlock) {
            self.successBlock();
        }
        [self dismiss];
//        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"注册成功"]];
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        
        switch (stateCode) {
            case 409:
            {
                if ([type isEqualToString:@"email"]) {
                    [SVProgressHUD showImage:nil status:@"该邮箱已被占用!"];
                } else if ([type isEqualToString:@"nickname"]) {
                    [SVProgressHUD showImage:nil status:@"该昵称已被占用!"];
                } else if ([type isEqualToString:@"sina_id"]) {
                    [SVProgressHUD showImage:nil status:@"该新浪微博帐号已被占用!"];
                }
                break;
            }
                
            case 500:
            {
                [SVProgressHUD showImage:nil status:@"服务器出错!"];
                break;
            }
                
            default:
                [SVProgressHUD dismiss];
                break;
        }
        [MobClick event:@"sign up" label:@"failure"];
    }];
}

- (BOOL)checkInfoWithNickname:(NSString *)nickname Email:(NSString *)email Password:(NSString *)passwd
{
    if (!nickname || nickname.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入昵称"];
        return NO;
    }
    
    if (nickname.length < 3) {
        [SVProgressHUD showImage:nil status:@"昵称过短"];
        return NO;
    }
    
    if (!email || email.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入邮箱"];
        return NO;
    }
    
    if (![email isValidEmail]) {
        [SVProgressHUD showImage:nil status:@"请输入正确格式的邮箱"];
        return NO;
    }
    
    if (!passwd || passwd.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return NO;
    }
    
    if (passwd.length < 8) {
        [SVProgressHUD showImage:nil status:@"密码至少6位"];
        return NO;
    }
    
    return YES;
}


#pragma mark - <SignUpViewDelegate>
- (void)tapSignUpBtnWithNickname:(NSString *)nickname Email:(NSString *)email Passwd:(NSString *)passwd
{
#warning TODO signup
    if (![self checkInfoWithNickname:nickname Email:email Password:passwd])
        return;
    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [API registerWithEmail:email password:passwd nickname:nickname imageData:nil sinaUserId:[Passport sharedInstance].sinaUserID sinaToken:[Passport sharedInstance].sinaToken                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    taobaoUserId:[Passport sharedInstance].taobaoId taobaoToken:[Passport sharedInstance].taobaoToken screenName:[Passport sharedInstance].screenName success:^(GKUser *user, NSString *session) {

        
        if (self.signUpSuccessBlock) {
            self.signUpSuccessBlock(YES);
        }
        // analytics
        [MobClick event:@"sign up" label:@"success"];
        
//        if (self.successBlock) {
//            self.successBlock();
//        }

        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"sign-up-success", kLocalizedFile, nickname)];
    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        
        switch (stateCode) {
            case 409:
            {
                if ([type isEqualToString:@"email"]) {
                    [SVProgressHUD showImage:nil status:@"该邮箱已被占用!"];
                } else if ([type isEqualToString:@"nickname"]) {
                    [SVProgressHUD showImage:nil status:@"该昵称已被占用!"];
                } else if ([type isEqualToString:@"sina_id"]) {
                    [SVProgressHUD showImage:nil status:@"该新浪微博帐号已被占用!"];
                }
                break;
            }
                
            case 500:
            {
                [SVProgressHUD showImage:nil status:@"服务器出错!"];
                break;
            }
                
            default:
                [SVProgressHUD dismiss];
                break;
        }
        [MobClick event:@"sign up" label:@"failure"];
    }];

}

- (void)gotoAgreementWithURL:(NSURL *)url
{
    [[OpenCenter sharedOpenCenter] openWebWithURL:url];
}


@end
