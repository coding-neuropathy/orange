//
//  VerifyEmailViewController.m
//  orange
//
//  Created by 谢家欣 on 15/12/12.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "VerifyEmailViewController.h"
#import "EmailEditViewController.h"

@protocol VerifyEmailViewDelegate <NSObject>

- (void)TapVerifyEmail:(id)sender;
- (void)TapUpdateEmail;

@end

@interface VerifyEmailView : UIView

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * tipLabel;
@property (strong, nonatomic) UILabel * emailLabel;
@property (strong, nonatomic) UIButton * verifyBtn;
@property (strong, nonatomic) UIButton * updateBtn;

@property (weak, nonatomic) id <VerifyEmailViewDelegate> delegate;

@end

@interface VerifyEmailViewController () <VerifyEmailViewDelegate>

@property (strong, nonatomic) VerifyEmailView * VerifyView;

@end

@implementation VerifyEmailViewController

- (VerifyEmailView *)VerifyView
{
    if (!_VerifyView) {
        _VerifyView = [[VerifyEmailView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        _VerifyView.delegate = self;
        _VerifyView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _VerifyView;
}


- (void)loadView
{
    self.view = self.VerifyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"verify email", kLocalizedFile, nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - verify delegate
- (void)TapVerifyEmail:(id)sender
{
    UIButton * verifiedBtn = (UIButton *)sender;
    

    
    if(verifiedBtn.enabled) {
        [API verifiedEmailWithParameters:[NSDictionary dictionary] success:^(NSInteger stateCode) {
            if (stateCode == 0) {
                [verifiedBtn setBackgroundColor:UIColorFromRGB(0x9d9e9f)];
                [verifiedBtn setTitle:NSLocalizedStringFromTable(@"resend", kLocalizedFile, nil) forState:UIControlStateDisabled];
                verifiedBtn.enabled = NO;
            }
        
        } failure:^(NSInteger stateCode, NSString *errorMsg) {
            
        }];
    }
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                verifiedBtn.enabled = YES;
                [verifiedBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
//                verifiedBtn.userInteractionEnabled = YES;
//                verifiedBtn.enabled = YES;
            });
        } else {
//            int seconds = timeout % 60;

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                verifiedBtn.enabled = NO;
                verifiedBtn.backgroundColor = UIColorFromRGB(0x9d9e9f);
                [verifiedBtn setTitle:[NSString stringWithFormat:@"%@ 秒后重新发送",strTime] forState:UIControlStateNormal];
//                verifiedBtn.userInteractionEnabled = NO;
//                verifiedBtn.enabled = NO;
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    

}

- (void)TapUpdateEmail
{
    EmailEditViewController * vc = [[EmailEditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


#pragma mark - verify email view
@implementation VerifyEmailView

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;

        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:14.];
        _tipLabel.textColor = UIColorFromRGB(0x414243);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)emailLabel
{
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _emailLabel.font = [UIFont systemFontOfSize:14.];
        _emailLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _emailLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_emailLabel];
    }
    return _emailLabel;
}

- (UIButton *)verifyBtn
{
    if (!_verifyBtn) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.layer.cornerRadius = 4.;
        _verifyBtn.layer.masksToBounds = YES;

        [_verifyBtn setTitle:NSLocalizedStringFromTable(@"send mail for verify", kLocalizedFile, nil) forState:UIControlStateNormal];
        
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        _verifyBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
        
        [_verifyBtn addTarget:self action:@selector(verifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_verifyBtn];
    }
    return _verifyBtn;
}

- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.layer.cornerRadius = 4.;
        _updateBtn.layer.masksToBounds = YES;
        _updateBtn.backgroundColor = UIColorFromRGB(0x427ec0);
        [_updateBtn setTitle:NSLocalizedStringFromTable(@"update email", kLocalizedFile, nil) forState:UIControlStateNormal];
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        _updateBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
        
        [_updateBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_updateBtn];
    }
    return _updateBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.text = @"为保证更好使用果库的各项功能，请进入邮箱查看验证邮件，并点击邮件中的链接完成验证。";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7.];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleLabel.text length])];
    self.titleLabel.attributedText = attributedString;
    
    self.titleLabel.frame = CGRectMake(16., 20., kScreenWidth - 32., 50.);
    
    self.tipLabel.frame = CGRectMake(16., 0., kScreenWidth - 32., 20.);
    self.tipLabel.deFrameTop = self.titleLabel.deFrameBottom + 20.;
    self.tipLabel.text = @"发送至当前邮箱：";
    
    self.emailLabel.frame = CGRectMake(16., 0., kScreenWidth - 32, 20.);
    self.emailLabel.deFrameTop = self.tipLabel.deFrameBottom + 5.;
    self.emailLabel.text = [[Passport sharedInstance].user email];
    
    self.verifyBtn.frame = CGRectMake(0., 0., 150., 50.);
    self.verifyBtn.deFrameTop = self.emailLabel.deFrameBottom + 20.;
    self.verifyBtn.deFrameLeft = (kScreenWidth - 150 * 2) / 3.;
    
    if ([[Passport sharedInstance].user mail_verified]) {
        [_verifyBtn setTitle:NSLocalizedStringFromTable(@"verified", kLocalizedFile, nil) forState:UIControlStateDisabled];
        self.verifyBtn.enabled = NO;
        self.verifyBtn.backgroundColor = UIColorFromRGB(0x9d9e9f);
    } else {
        self.verifyBtn.enabled = YES;
        self.verifyBtn.backgroundColor = UIColorFromRGB(0x427ec0);
    }
    
    self.updateBtn.frame = CGRectMake(0., 0., 150., 50.);
    self.updateBtn.center = self.verifyBtn.center;
    self.updateBtn.deFrameLeft = (kScreenWidth - 150 * 2) / 3. + self.verifyBtn.deFrameRight;
    
}

#pragma mark - button action
- (void)verifyBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapVerifyEmail:)]) {
        [_delegate TapVerifyEmail:sender];
    }
}

- (void)updateBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapUpdateEmail)]) {
        [_delegate TapUpdateEmail];
    }
}

@end

