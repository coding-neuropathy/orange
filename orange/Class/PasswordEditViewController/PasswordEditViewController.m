//
//  PasswordEditViewController.m
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "PasswordEditViewController.h"
#import "API.h"
//static CGFloat NormalKeyboardHeight = 216.0f;

@interface PasswordEditViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordTextFieldForNew;
@property (nonatomic, strong) UITextField *passwordTextFieldForSecond;
@end

@implementation PasswordEditViewController




#pragma mark - Life Cycle


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
        
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(40.f,30, kScreenWidth - 80, 45.f)];
    self.passwordTextField.delegate = self;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
    if (iOS7) {
        [self.passwordTextField setTintColor:UIColorFromRGB(0x414243)];
    }
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        label.textColor = UIColorFromRGB(0x9d9e9f);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"原密码";
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
    
    
    _passwordTextFieldForNew = [[UITextField alloc] initWithFrame:CGRectMake(40.f,80, kScreenWidth - 80, 45.f)];
    self.passwordTextFieldForNew.delegate = self;
    self.passwordTextFieldForNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextFieldForNew.borderStyle = UITextBorderStyleNone;
    self.passwordTextFieldForNew.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextFieldForNew.secureTextEntry = YES;
    if (iOS7) {
        [self.passwordTextFieldForNew setTintColor:UIColorFromRGB(0x414243)];
    }
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        label.textColor = UIColorFromRGB(0x9d9e9f);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"新密码";
        label.adjustsFontSizeToFitWidth = YES;
        self.passwordTextFieldForNew.leftView = label;
    }
    self.passwordTextFieldForNew.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextFieldForNew.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextFieldForNew.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextFieldForNew.placeholder = @"";
    self.passwordTextFieldForNew.font = [UIFont systemFontOfSize:14];
    self.passwordTextFieldForNew.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextFieldForNew.returnKeyType = UIReturnKeyGo;
    [self.passwordTextFieldForNew setTextColor:UIColorFromRGB(0x414243)];
    self.passwordTextFieldForNew.backgroundColor = [UIColor clearColor];
    {
        UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.passwordTextFieldForNew.deFrameWidth,0.5)];
        H.backgroundColor = UIColorFromRGB(0xebebeb);
        H.center = CGPointMake(self.passwordTextFieldForNew.deFrameWidth/2, self.passwordTextFieldForNew.deFrameHeight);
        [self.passwordTextFieldForNew addSubview:H];
    }
    [self.view addSubview:self.passwordTextFieldForNew];
    
    _passwordTextFieldForSecond = [[UITextField alloc] initWithFrame:CGRectMake(40.f,130, kScreenWidth - 80, 45.f)];
    self.passwordTextFieldForSecond.delegate = self;
    self.passwordTextFieldForSecond.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextFieldForSecond.borderStyle = UITextBorderStyleNone;
    self.passwordTextFieldForSecond.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextFieldForSecond.secureTextEntry = YES;
    if (iOS7) {
        [self.passwordTextFieldForSecond setTintColor:UIColorFromRGB(0x414243)];
    }
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        label.textColor = UIColorFromRGB(0x9d9e9f);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"确认密码";
        label.adjustsFontSizeToFitWidth = YES;
        self.passwordTextFieldForSecond.leftView = label;
    }
    self.passwordTextFieldForSecond.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextFieldForSecond.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTextFieldForSecond.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextFieldForSecond.placeholder = @"";
    self.passwordTextFieldForSecond.font = [UIFont systemFontOfSize:14];
    self.passwordTextFieldForSecond.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextFieldForSecond.returnKeyType = UIReturnKeyGo;
    [self.passwordTextFieldForSecond setTextColor:UIColorFromRGB(0x414243)];
    self.passwordTextFieldForSecond.backgroundColor = [UIColor clearColor];
    {
        UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.passwordTextFieldForSecond.deFrameWidth,0.5)];
        H.backgroundColor = UIColorFromRGB(0xebebeb);
        H.center = CGPointMake(self.passwordTextFieldForSecond.deFrameWidth/2, self.passwordTextFieldForSecond.deFrameHeight);
        [self.passwordTextFieldForSecond addSubview:H];
    }
    [self.view addSubview:self.passwordTextFieldForSecond];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";

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
    [AVAnalytics beginLogPageView:@"PasswordEditView"];
    [MobClick beginLogPageView:@"PasswordEditView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"PasswordEditView"];
    [MobClick endLogPageView:@"PasswordEditView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector Methdo

- (void)postButtonAction
{
    NSString *password = self.passwordTextField.text;
    NSString *passwordnew = self.passwordTextFieldForNew.text;
    NSString *passwordsecond = self.passwordTextFieldForSecond.text;
    
    if (!password || password.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    
    if (!passwordnew || passwordnew.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入新密码"];
        return;
    }
    
    if (!passwordsecond || passwordsecond.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码"];
        return;
    }
    
    if (![passwordsecond isEqualToString:passwordnew])
    {
        [SVProgressHUD showImage:nil status:@"两次密码不一致"];
        return;
    }
    
    UITextField *tf= self.passwordTextFieldForNew;
    if (tf.text.length < 8) {
        [SVProgressHUD showImage:nil status:@"密码不能小于8位"];
    } else {
        NSDictionary *dict = @{@"password":password, @"new_password":passwordnew, @"confirm_password":passwordsecond};
        
        [API resetPasswordWithParameters:dict success:^(GKUser *user) {
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
        } failure:^(NSInteger stateCode, NSString *errorMsg) {
            if(stateCode == 400) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(errorMsg, kLocalizedFile, nil)];
            }
        }];
//        [API updateaccountWithParameters:dict success:^(GKUser *user) {
//            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
//        } failure:^(NSInteger stateCode) {
//            [SVProgressHUD showImage:nil status:@"修改失败"];
//        }];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.passwordTextField) {
            [self.passwordTextFieldForNew becomeFirstResponder];
        }
        else if (textField == self.passwordTextFieldForNew) {
            [self.passwordTextFieldForSecond becomeFirstResponder];
        }
        else {
            [self postButtonAction];
        }
    }
    return YES;
}


@end
