//
//  SignView.m
//  Blueberry
//
//  Created by huiter on 13-10-28.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SignView.h"
#import "GKAPI.h"

@interface SignView () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
@private
    UILabel * tip;
    UIView * whiteBG;
}
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UIButton * avatarButton;

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
        whiteBG.layer.cornerRadius = 0.0f;
        whiteBG.layer.masksToBounds = YES;
        [self addSubview:whiteBG];
        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:Tap];
        
        UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
        [whiteBG addGestureRecognizer:Tap2];
        

        
        tip = [[UILabel alloc]initWithFrame:CGRectMake(75, 38, whiteBG.deFrameWidth-90, 30)];
        tip.textColor = UIColorFromRGB(0x777777);
        tip.font = [UIFont systemFontOfSize:20];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.text = @"注册帐号";
        [whiteBG addSubview:tip];
        
        UIView * _avatarBG = [[UIView alloc]initWithFrame:CGRectMake(15, 30, 50, 50)];
        _avatarBG.backgroundColor =UIColorFromRGB(0xf4f4f4);
        
        UIImageView * _avatar_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        _avatar_icon.image =[UIImage imageNamed:@"login_icon_avatar.png"];
        _avatar_icon.backgroundColor =UIColorFromRGB(0xf4f4f4);
        [_avatarBG addSubview:_avatar_icon];
        
        [whiteBG addSubview:_avatarBG];
        
        _avatarButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 50, 50)];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_avatarButton setBackgroundColor:[UIColor clearColor]];
        _avatarButton.center = CGPointMake(_avatarButton.center.x, tip.center.y);
        if ([Passport sharedInstance].sinaAvatarURL) {
            [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:[Passport sharedInstance].sinaAvatarURL] forState:UIControlStateNormal];
        }
        else
        {
            [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:@"http://static.guoku.com/static/v4/aa96aeb233757e2bf80feaba816ba55f5164c054/images/manicon.jpg"] forState:UIControlStateNormal];
        }
        [whiteBG addSubview:_avatarButton];
        
        _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.f, tip.deFrameBottom+20, whiteBG.deFrameWidth - 30, 45.f)];
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
        self.nicknameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        self.nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
        self.nicknameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.nicknameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.nicknameTextField.placeholder = @"昵称";
        self.nicknameTextField.delegate = self;
        self.nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.nicknameTextField setTextColor:UIColorFromRGB(0x666666)];
        self.nicknameTextField.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [whiteBG addSubview:self.nicknameTextField];
        
        _emailTextField = [[UITextField alloc] initWithFrame:self.nicknameTextField.frame];
        self.emailTextField.delegate = self;
        self.emailTextField.returnKeyType = UIReturnKeyNext;
        self.emailTextField.borderStyle = UITextBorderStyleNone;
        self.emailTextField.delegate = self;
        self.emailTextField.deFrameTop = self.nicknameTextField.deFrameBottom + 10.f;
        //self.emailTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.emailTextField.layer.borderWidth = 0.5;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        if (iOS7) {
            [self.emailTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
        self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.emailTextField.placeholder = @"邮箱";
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.emailTextField setTextColor:UIColorFromRGB(0x666666)];
        self.emailTextField.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [whiteBG addSubview:self.emailTextField];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:self.emailTextField.frame];
        self.passwordTextField.delegate = self;
        self.passwordTextField.returnKeyType = UIReturnKeyGo;
        self.passwordTextField.deFrameTop = self.emailTextField.deFrameBottom + 10.f;
        self.passwordTextField.borderStyle = UITextBorderStyleNone;
        //self.passwordTextField.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        //self.passwordTextField.layer.borderWidth = 0.5;
        self.passwordTextField.secureTextEntry = YES;
        if (iOS7) {
            [self.passwordTextField setTintColor:UIColorFromRGB(0x6d9acb)];
        }
        self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16., 45.)];
        self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.passwordTextField.placeholder = @"密码";
        self.passwordTextField.delegate = self;
        self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.passwordTextField setTextColor:UIColorFromRGB(0x666666)];
        self.passwordTextField.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [whiteBG addSubview:self.passwordTextField];
        
        

        
        UIButton *registerButton = [[UIButton alloc]init ];
        registerButton.frame = CGRectMake(15.f, self.passwordTextField.deFrameBottom + 23, whiteBG.deFrameWidth - 30, 45.f);
        registerButton.layer.cornerRadius = 2;
        registerButton.layer.masksToBounds = YES;
        registerButton.backgroundColor = UIColorFromRGB(0x457ebd);
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        [registerButton addTarget:self action:@selector(tapRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        [whiteBG addSubview:registerButton];

        
        whiteBG.deFrameHeight = registerButton.deFrameBottom + 30;
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
        if (self.successBlock) {
            self.successBlock();
        }
        [self dismiss];
        [SVProgressHUD dismiss];
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
    }];
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

@end
