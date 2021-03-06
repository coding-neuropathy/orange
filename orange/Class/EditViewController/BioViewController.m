//
//  BioViewController.m
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "BioViewController.h"

@interface BioViewController ()<UITextViewDelegate>

@property (nonatomic , strong)UIView * backView;

@property (nonatomic , strong)UITextView * textView;

//占位文字
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation BioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"bio", kLocalizedFile, nil);
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    
    [self createSaveBtn];
    
    [self.view addSubview:self.backView];
    
    [self.view addSubview:self.textView];
    
    [self.textView resignFirstResponder];
    
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:IS_IPHONE ? CGRectMake(0. , 10., kScreenWidth, 200) : CGRectMake(0. , 10., kScreenWidth - kTabBarWidth, 200)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:IS_IPHONE ? CGRectMake(15., 10., kScreenWidth - 15., 200) : CGRectMake(15., 10., kScreenWidth - kTabBarWidth - 15., 200)];
        _textView.keyboardType = UIKeyboardTypeDefault;
        
        _textView.returnKeyType = UIReturnKeyDefault;
        
        _textView.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        
        _textView.scrollEnabled = YES;
        
        _textView.editable = YES;
        
        _textView.contentOffset = CGPointMake(10, 10);
        
        _textView.contentSize = CGSizeMake(kScreenWidth - 20, _textView.deFrameSize.height - 20);
        
        _textView.backgroundColor = [UIColor whiteColor];
        
        _textView.textColor = [UIColor blackColor];
        
        _textView.font = [UIFont systemFontOfSize:17];
        
        _textView.tintColor = UIColorFromRGB(0x6d9acb);
        
        _textView.text = [Passport sharedInstance].user.bio;
        
        _textView.delegate = self;
        
        _textView.spellCheckingType = UITextSpellCheckingTypeNo;
        
        _textView.autocorrectionType = UITextAutocapitalizationTypeNone;
        
        _textView.autocapitalizationType = UITextAutocorrectionTypeNo;
        
        [_textView becomeFirstResponder];
        
    }
    
    return _textView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        //占位label
        _tipLabel = [[UILabel alloc]initWithFrame:IS_IPHONE ? CGRectMake(10, 10, kScreenWidth, 15) : CGRectMake(10, 10, kScreenWidth - kTabBarWidth, 15)];
        //左距中
        self.tipLabel.textAlignment = NSTextAlignmentLeft;
        //背景色透明
        self.tipLabel.backgroundColor = [UIColor clearColor];
        //设置字体样式与大小
        [self.tipLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        self.tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        self.tipLabel.text = @"请填写您的个人简介";
        
        [self.textView addSubview:self.tipLabel];
    }
    return _tipLabel;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >0) {
        self.tipLabel.hidden = YES;
    }
    else
    {
        self.tipLabel.hidden = NO;
    }
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
    if (self.textView.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"不能为空"];
    }
    else
    {
        NSDictionary * dict = @{@"bio": self.textView.text};
        [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
            [Passport sharedInstance].user.bio = user.bio;
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         self.backView.frame = CGRectMake(0. , 10., kScreenWidth - kTabBarWidth, 200);
         self.textView.frame = CGRectMake(15., 10., kScreenWidth - kTabBarWidth - 15., 200);
         
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    kAppDelegate.activeVC = self;
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
