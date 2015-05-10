//
//  EmailEditViewController.m
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EmailEditViewController.h"
#import "GKAPI.h"
#import "NSString+Helper.h"
static CGFloat NormalKeyboardHeight = 216.0f;

@interface EmailEditViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@end

@implementation EmailEditViewController


#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, kScreenWidth-40, 20)];
        label.textColor = UIColorFromRGB(0x414243);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"当前邮箱：";
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
    }
    
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, kScreenWidth-40, 20)];
        label.textColor = UIColorFromRGB(0x9d9e9f);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = [Passport sharedInstance].user.email;
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
    }
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(40.f,70, kScreenWidth - 80, 45.f)];
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
        [self.emailTextField setTintColor:UIColorFromRGB(0x414243)];
    }
    self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.textColor = UIColorFromRGB(0x9d9e9f);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"新邮箱";
        label.adjustsFontSizeToFitWidth = YES;
        self.emailTextField.leftView = label;
    }
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.placeholder = @"";
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.textColor = UIColorFromRGB(0x414243);
    self.emailTextField.backgroundColor = [UIColor clearColor];
    
    
    {
        UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.emailTextField.deFrameWidth,0.5)];
        H.backgroundColor = UIColorFromRGB(0xebebeb);
        H.center = CGPointMake(self.emailTextField.deFrameWidth/2, self.emailTextField.deFrameHeight);
        [self.emailTextField addSubview:H];
    }
    
    [self.view addSubview:self.emailTextField];
    
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40, self.emailTextField.deFrameBottom + 20, kScreenWidth-40, 20)];
        label.textColor = UIColorFromRGB(0x414243);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"为保证帐号安全，请输入密码：";
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
    }
    
    _passwordTextField = [[UITextField alloc] initWithFrame:self.emailTextField.frame];
    self.passwordTextField.delegate = self;
    self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 40.f;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
    if (iOS7) {
        [self.passwordTextField setTintColor:UIColorFromRGB(0x414243)];
    }
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        label.textColor = UIColorFromRGB(0x9d9e9f);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedStringFromTable(@"password", kLocalizedFile, nil);
        label.adjustsFontSizeToFitWidth = YES;
        self.passwordTextField.leftView = label;
    }
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.placeholder = @"";
    self.passwordTextField.font = [UIFont systemFontOfSize:14];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    [self.passwordTextField setTextColor:UIColorFromRGB(0x414243)];
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    {
        UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.passwordTextField.deFrameWidth,0.5)];
        H.backgroundColor = UIColorFromRGB(0xebebeb);
        H.center = CGPointMake(self.passwordTextField.deFrameWidth/2, self.passwordTextField.deFrameHeight);
        [self.passwordTextField addSubview:H];
    }
    [self.view addSubview:self.passwordTextField];

    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改邮箱";
    NSMutableArray * array = [NSMutableArray array];
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
        [array addObject:item];
    }
    self.navigationItem.rightBarButtonItems = array;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"EmailEditView"];
    [MobClick beginLogPageView:@"EmailEditView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"EmailEditView"];
    [MobClick endLogPageView:@"EmailEditView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Selector Methdo
- (void)postButtonAction
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
    
    UITextField *tf=self.emailTextField;
    if ([tf.text validateEmail]) {
        NSDictionary *dict = @{@"email": tf.text,@"password":self.passwordTextField.text};
        [GKAPI updateaccountWithParameters:dict success:^(GKUser *user) {
            [Passport sharedInstance].user.email = user.email;
            [Passport sharedInstance].user = [Passport sharedInstance].user;
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger stateCode) {
            if(stateCode == 500)
            {
               [SVProgressHUD showImage:nil status:@"此邮箱已被使用"];
            }
            else if(stateCode == 400)
            {
                [SVProgressHUD showImage:nil status:@"密码错误"];
            }
            else {
                [SVProgressHUD showImage:nil status:@"修改失败"];
            }
        }];
    } else {
        [SVProgressHUD showImage:nil status:@"邮箱格式错误"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.emailTextField) {
            [self.passwordTextField becomeFirstResponder];
        } else {
            [self postButtonAction];
        }
    }
    return YES;
}

@end
