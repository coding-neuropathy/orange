//
//  SignView.m
//  Blueberry
//
//  Created by huiter on 13-10-28.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SignView.h"
#import "GKAPI.h"
#import "LoginView.h"
#import "GKWebVC.h"
#import "RTLabel.h"

@interface SignView () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,RTLabelDelegate>
{
@private
    UILabel * tip;
    UIView * whiteBG;
    UIImageView *logo;
}
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UIButton * avatarButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) RTLabel *label;
@end

@implementation SignView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:kAppDelegate.window.frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        whiteBG = [[UIView alloc]initWithFrame:CGRectMake(20, 80, self.frame.size.width-40, 300)];
        
        whiteBG.backgroundColor = [UIColor whiteColor];
        whiteBG.layer.cornerRadius = 5.0f;
        whiteBG.layer.masksToBounds = YES;
        [self addSubview:whiteBG];
        
//        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        //[self addGestureRecognizer:Tap];
        
        UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
        [whiteBG addGestureRecognizer:Tap2];
        

        
        logo = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"login_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        logo.tintColor = UIColorFromRGB(0x9d9e9f);
        logo.center = CGPointMake(whiteBG.deFrameWidth/2, 80);
        [whiteBG addSubview:logo];
        
        tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, whiteBG.deFrameWidth, 30)];
        tip.textColor = UIColorFromRGB(0xcbcbcb);
        tip.font = [UIFont fontWithName:@"FultonsHand" size:16];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"Live Different";
        [whiteBG addSubview:tip];
        
        _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(24.f, tip.deFrameBottom+12, whiteBG.deFrameWidth - 48, 45.f)];
        self.nicknameTextField.delegate = self;
        self.nicknameTextField.returnKeyType = UIReturnKeyNext;
        self.nicknameTextField.borderStyle = UITextBorderStyleNone;
        if ([Passport sharedInstance].screenName) {
            self.nicknameTextField.text = [Passport sharedInstance].screenName;
        }
        //self.nicknameTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.nicknameTextField.layer.borderWidth = 0.5;

        if (iOS7) {
            [self.nicknameTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            label.textColor = UIColorFromRGB(0x414243);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"昵称";
            self.nicknameTextField.leftView = label;
        }
        self.nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
        self.nicknameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.nicknameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.nicknameTextField.placeholder = @"";
        self.nicknameTextField.delegate = self;
        self.nicknameTextField.font = [UIFont systemFontOfSize:14];
        self.nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.nicknameTextField setTextColor:UIColorFromRGB(0x9d9e9f)];
        self.nicknameTextField.backgroundColor = UIColorFromRGB(0xffffff);
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.nicknameTextField.deFrameWidth,0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            H.center = CGPointMake(self.nicknameTextField.deFrameWidth/2, self.nicknameTextField.deFrameHeight);
            [self.nicknameTextField addSubview:H];
        }

        [whiteBG addSubview:self.nicknameTextField];
        
        _emailTextField = [[UITextField alloc] initWithFrame:self.nicknameTextField.frame];
        self.emailTextField.delegate = self;
        self.emailTextField.returnKeyType = UIReturnKeyNext;
        self.emailTextField.borderStyle = UITextBorderStyleNone;
        self.emailTextField.delegate = self;
        self.emailTextField.deFrameTop = self.nicknameTextField.deFrameBottom + 10.f;
        //self.emailTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.emailTextField.layer.borderWidth = 0.5;
        self.emailTextField.font = [UIFont systemFontOfSize:14];
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        if (iOS7) {
            [self.emailTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            label.textColor = UIColorFromRGB(0x414243);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"邮箱";
            self.emailTextField.leftView = label;
        }
        self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
        self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.emailTextField.placeholder = @"";
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.emailTextField setTextColor:UIColorFromRGB(0x9d9e9f)];
        self.emailTextField.backgroundColor = UIColorFromRGB(0xffffff);
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.emailTextField.deFrameWidth,0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            H.center = CGPointMake(self.emailTextField.deFrameWidth/2, self.emailTextField.deFrameHeight);
            [self.emailTextField addSubview:H];
        }

        [whiteBG addSubview:self.emailTextField];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:self.emailTextField.frame];
        self.passwordTextField.delegate = self;
        self.passwordTextField.returnKeyType = UIReturnKeyGo;
        self.passwordTextField.font = [UIFont systemFontOfSize:14];
        self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10.f;
        self.passwordTextField.borderStyle = UITextBorderStyleNone;
        //self.passwordTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.passwordTextField.layer.borderWidth = 0.5;
        self.passwordTextField.secureTextEntry = YES;
        if (iOS7) {
            [self.passwordTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            label.textColor = UIColorFromRGB(0x414243);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"密码";
            self.passwordTextField.leftView = label;
        }
        self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.passwordTextField.placeholder = @"";
        self.passwordTextField.delegate = self;
        self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.passwordTextField setTextColor:UIColorFromRGB(0x666666)];
        self.passwordTextField.backgroundColor = UIColorFromRGB(0xffffff);
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.emailTextField.deFrameWidth,0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            H.center = CGPointMake(self.emailTextField.deFrameWidth/2, self.emailTextField.deFrameHeight);
            [self.passwordTextField addSubview:H];
        }
        [whiteBG addSubview:self.passwordTextField];
        
        

        
        UIButton *registerButton = [[UIButton alloc]init ];
        registerButton.frame = CGRectMake(0, self.passwordTextField.deFrameBottom + 23, 90, 40.f);
        registerButton.center = self.passwordTextField.center;
        registerButton.deFrameTop = self.passwordTextField.deFrameBottom+23;
        registerButton.layer.cornerRadius = 4;
        registerButton.layer.masksToBounds = YES;
        registerButton.backgroundColor = UIColorFromRGB(0x457ebd);
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        [registerButton addTarget:self action:@selector(tapRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:registerButton];
        
        UIButton * close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        close.backgroundColor = [UIColor clearColor];
        close.titleLabel.textAlignment = NSTextAlignmentLeft;
        close.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        [close setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        close.deFrameTop = 10;
        close.deFrameLeft = 16;
        [whiteBG addSubview:close];
        
        
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 , 40.f)];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_loginButton setTitle:[NSString stringWithFormat:@"登录 %@",[NSString fontAwesomeIconStringForEnum:FAChevronRight]] forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:14]];
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.deFrameTop = 10;
        _loginButton.deFrameRight = whiteBG.deFrameWidth - 16;
        [whiteBG addSubview:_loginButton];
        
        
        if(!self.label) {
            _label = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0,220, 20)];
            self.label.paragraphReplacement = @"";
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.lineSpacing = 7.0;
            //self.label.backgroundColor = UIColorFromRGB(0xff0000);
            self.label.delegate = self;
            [whiteBG addSubview:self.label];
        }
        self.label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^9d9e9f' size=14>使用果库，表示你已同意 <a href='http://www.guoku.com/agreement'>使用协议</a></font>"];
        self.label.center = CGPointMake(whiteBG.deFrameWidth/2, 0);
        self.label.deFrameTop = registerButton.deFrameBottom + 20;

        
        
        whiteBG.deFrameHeight = self.label.deFrameBottom + 10;
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



- (void)tapRegisterButton
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *nickname = self.nicknameTextField.text;
    
    if (!nickname || nickname.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入昵称"];
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
    
    [self endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [GKAPI registerWithEmail:email password:password nickname:nickname imageData:[_avatarButton.imageView.image imageData] sinaUserId:[Passport sharedInstance].sinaUserID sinaToken:[Passport sharedInstance].sinaToken                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    taobaoUserId:[Passport sharedInstance].taobaoId taobaoToken:[Passport sharedInstance].taobaoToken screenName:[Passport sharedInstance].screenName success:^(GKUser *user, NSString *session) {
        
        // analytics
        [AVAnalytics event:@"sign up" label:@"success"];
        [MobClick event:@"sign up" label:@"success"];
        
        if (self.successBlock) {
            self.successBlock();
        }
        [self dismiss];
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"注册成功"]];
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
        [AVAnalytics event:@"sign up" label:@"failure"];
        [MobClick event:@"sign up" label:@"failure"];
    }];
}

- (void)tapLoginButton
{
    [whiteBG removeFromSuperview];
    LoginView *view = [[LoginView alloc] init];
    view.successBlock = self.successBlock;
    [view showFromRegister];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self removeFromSuperview];
    });
}

#pragma mark - Private Method

- (void)showImagePickerFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.delegate = self;
        
        [kAppDelegate.alertWindow makeKeyAndVisible];
        [kAppDelegate.alertWindow.rootViewController presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)showImagePickerToTakePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerVC.delegate = self;
        [kAppDelegate.alertWindow makeKeyAndVisible];
        [kAppDelegate.alertWindow.rootViewController presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        if(kScreenHeight >= 548)
        {
            whiteBG.deFrameTop = 50;
        }
        else
        {
            whiteBG.deFrameTop = 20;
        }

    }];
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

- (void)show
{
    [AVAnalytics beginLogPageView:@"SignUpView"];
    [MobClick beginLogPageView:@"SignUpView"];
    
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

- (void)showFromLogin
{

    [kAppDelegate.window addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    whiteBG.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
   
    } completion:^(BOOL finished) {
        whiteBG.alpha = 1;

    }];
}
- (void)dismiss
{
    [AVAnalytics endLogPageView:@"SignUpView"];
    [MobClick endLogPageView:@"SignUpView"];
    
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)avatarButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
    [actionSheet showInView:self];
}

- (void)resignResponder
{
    if(kScreenHeight >= 548)
    {
        whiteBG.deFrameTop = 100;
    }
    else
    {
        whiteBG.deFrameTop = 50;
    }
    [self.nicknameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 修改头像
    switch (buttonIndex) {
        case 0:
        {
            // 拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self showImagePickerToTakePhoto];
            }
            break;
        }
            
        case 1:
        {
            // 照片库
            [self showImagePickerFromPhotoLibrary];
            break;
        }
    }
}

#pragma mark- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [kAppDelegate.alertWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
    }];
    
    [self.avatarButton setImage:image forState:UIControlStateNormal];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [kAppDelegate.alertWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
    }];
    
    if([info count] > 0) {
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.avatarButton setImage:editedImage forState:UIControlStateNormal];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [kAppDelegate.alertWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
    }];
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    [self dismiss];
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"http"])
    {
        GKWebVC * vc =  [GKWebVC linksWebViewControllerWithURL:url];
        vc.hidesBottomBarWhenPushed = YES;
        [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
    }
}
@end
