//
//  RegisterViewController.m
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebViewController.h"
//#import "WXApi.h"

#import "SignUpView.h"

@interface RegisterViewController ()<UIAlertViewDelegate, SignUpViewDelegate>

@property (strong, nonatomic) SignUpView * signUpView;

@property (strong, nonatomic) UIButton * dismissBtn;

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

- (UIButton *)dismissBtn
{
    if (!_dismissBtn) {
        _dismissBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissBtn.deFrameSize     = CGSizeMake(32., 44.);
        
        [_dismissBtn setImage:[UIImage imageNamed:@"back-1"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (void)loadView
{
    self.view = self.signUpView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedStringFromTable(@"sign up", kLocalizedFile, nil);
    
    
    if (IS_IPAD) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dismissBtn];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder:)];
    [self.signUpView addGestureRecognizer:tap];

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

#pragma mark -
- (void)resignResponder:(id)sender
{
    [self.signUpView resignResponder];
}

#pragma mark -
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
        [SVProgressHUD showImage:nil status:@"密码至少8位"];
        return NO;
    }
    
    return YES;
}


#pragma mark - <SignUpViewDelegate>
- (void)dismissBtnAction:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapSignUpBtnWithNickname:(NSString *)nickname Email:(NSString *)email Passwd:(NSString *)passwd
{
//    DDLogInfo(@"account %@ %@ %@", nickname, email, passwd);
#warning TODO signup
    if (![self checkInfoWithNickname:nickname Email:email Password:passwd])
        return;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"loading", kLocalizedFile, nil)];
    [API registerWithEmail:email password:passwd nickname:nickname imageData:nil sinaUserId:[Passport sharedInstance].sinaUserID sinaToken:[Passport sharedInstance].sinaToken                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    taobaoUserId:[Passport sharedInstance].taobaoId taobaoToken:[Passport sharedInstance].taobaoToken screenName:[Passport sharedInstance].screenName success:^(GKUser *user, NSString *session) {

        
        // analytics
        [MobClick event:@"sign up" label:@"success"];
        
        if (IS_IPAD) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.signUpSuccessBlock) {
                    self.signUpSuccessBlock(YES);
                }
            }];
        } else {
            if (self.signUpSuccessBlock) {
                self.signUpSuccessBlock(YES);
            }
        }

//        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"sign-up-success", kLocalizedFile, nickname)];
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
//    [[OpenCenter sharedOpenCenter] openWebWithURL:url];
    if (IS_IPHONE) {
        //        [[OpenCenter sharedOpenCenter] openWebWithURL:url];
        WebViewController * webVC = [[WebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}


@end
