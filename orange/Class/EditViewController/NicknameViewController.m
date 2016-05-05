//
//  NicknameViewController.m
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "NicknameViewController.h"


@interface NicknameViewController ()

@property (nonatomic , strong)UIView * backView;

@property (nonatomic , strong)UITextField * textField;

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"nickname", kLocalizedFile, nil);
    
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    
    [self createSaveBtn];
    
    [self.view addSubview:self.backView];
    
    [self.view addSubview:self.textField];
    
    [self.textField resignFirstResponder];
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(20., 10., kScreenWidth - 20, 44.)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.text = [Passport sharedInstance].user.nickname;
        _textField.font = [UIFont systemFontOfSize:17.];
        _textField.adjustsFontSizeToFitWidth = YES;
        _textField.minimumFontSize = 18;
        _textField.placeholder = @"请设置您的昵称";
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0., 10., kScreenWidth, 44.)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (void)createSaveBtn
{
    
    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [Btn setTitle:@"保存" forState:UIControlStateNormal];
    [Btn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)rightBarButtonAction
{
    if (self.textField.text.length == 0 || self.textField.text.length <= 2) {
        [SVProgressHUD showImage:nil status:@"昵称不能为空且必须大于两个字符！"];
    }
    else
    {
        NSDictionary * dict = @{@"nickname": self.textField.text};
        [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
            [Passport sharedInstance].user = [Passport sharedInstance].user;
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (_delegate && [_delegate respondsToSelector:@selector(reloadData)]) {
                [_delegate reloadData];
            }
            [self.navigationController popViewControllerAnimated:YES];
             
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    kAppDelegate.activeVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
