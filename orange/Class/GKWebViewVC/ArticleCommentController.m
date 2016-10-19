//
//  CommentController.m
//  orange
//
//  Created by D_Collin on 16/7/21.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticleCommentController.h"

@interface ArticleCommentController ()<UITextViewDelegate>

//评论视窗
@property (nonatomic ,strong)UIView * PostNotebackgroundview;
//textView
@property (nonatomic ,strong)UITextView * textView;
//获取键盘动态高度
@property (nonatomic, assign)NSInteger height;
//关闭按钮
@property (nonatomic,strong)UIButton * closeBtn;
//发送按钮
@property (nonatomic,strong)UIButton *sendBtn;
//标题
@property (nonatomic,strong)UILabel * LbTitle;
@end

@implementation ArticleCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //键盘监听    当键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //键盘监听     当键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self createCommentView];
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _height = keyboardRect.size.height;
    
    //    NSLog(@"键盘高度是  %ld",_height);
    
    [UIView animateWithDuration:0.25 animations:^{
        _PostNotebackgroundview.frame = CGRectMake(10., 22., kScreenWidth - 20., 370);
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        _PostNotebackgroundview.frame = CGRectMake(10, -kScreenHeight, kScreenWidth - 20, 370);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createCommentView
{
    
    //后背景
    _PostNotebackgroundview = [[UIView alloc]initWithFrame:CGRectMake(10.,-kScreenHeight, kScreenWidth - 20., 320)];
    
    _PostNotebackgroundview.layer.masksToBounds = YES;
    _PostNotebackgroundview.layer.cornerRadius = 4.;
    
    _PostNotebackgroundview.backgroundColor = UIColorFromRGB(0xfafafa);
    
    [self.view addSubview:_PostNotebackgroundview];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0., 61., _PostNotebackgroundview.frame.size.width, 1.)];
    line.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    [_PostNotebackgroundview addSubview:line];
    
    //textView
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(16., 78., _PostNotebackgroundview.frame.size.width - 32., 290.)];
    
    _textView.keyboardType = UIKeyboardTypeDefault;
    
    _textView.returnKeyType = UIReturnKeyDefault;
    
    _textView.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    
    _textView.scrollEnabled = YES;
    
    _textView.editable = YES;
    
    _textView.contentOffset = CGPointMake(10, 10);
    
    _textView.contentSize = CGSizeMake(kScreenWidth - 20, _textView.deFrameSize.height - 20);
    
    _textView.backgroundColor = UIColorFromRGB(0xfafafa);
    
    _textView.textColor = UIColorFromRGB(0x212121);
    
    _textView.font = [UIFont systemFontOfSize:17];
    
    _textView.tintColor = UIColorFromRGB(0x6d9acb);
    
    _textView.delegate = self;
    
    _textView.spellCheckingType = UITextSpellCheckingTypeNo;
    
    _textView.autocorrectionType = UITextAutocapitalizationTypeNone;
    
    _textView.autocapitalizationType = UITextAutocorrectionTypeNo;
    
    [_textView becomeFirstResponder];
    
    [_PostNotebackgroundview addSubview:_textView];
    //关闭按钮
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _closeBtn.frame = CGRectMake(15, 22, 18, 18);
    
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
    
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_PostNotebackgroundview addSubview:_closeBtn];
    
    //发送按钮
    _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 10, 60, 44)];
    _sendBtn.enabled = NO;
    [_sendBtn setTitle:@"发布" forState:UIControlStateDisabled];
    [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:17.];
    [_sendBtn setTitleColor:[UIColor colorFromHexString:@"#5976c1"] forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor colorFromHexString:@"#9BADDA"] forState:UIControlStateDisabled];
//    _sendBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
    _sendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_sendBtn setTitle:[NSString fontAwesomeIconStringForEnum:FApaperPlane] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.backgroundColor = [UIColor clearColor];
    
    [_PostNotebackgroundview addSubview:_sendBtn];
    
    _LbTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 55, 24, 100, 16)];
    
    _LbTitle.text = @"添加评论";
    
    _LbTitle.textAlignment = NSTextAlignmentCenter;
    
    [_PostNotebackgroundview addSubview:_LbTitle];
    
    
    //占位label
//    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth, 15)];
//    //左距中
//    self.tipLabel.textAlignment = NSTextAlignmentLeft;
//    //背景色透明
//    self.tipLabel.backgroundColor = [UIColor clearColor];
//    //设置字体样式与大小
//    [self.tipLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
//    self.tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
//    self.tipLabel.text = @"撰写真实、有用、有趣的图文点评";
//    
//    [self.textView addSubview:self.tipLabel];
    
    
}

- (void)closeBtnClick:(UIButton *)button
{
    
    [_textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [_textView resignFirstResponder];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [AVAnalytics beginLogPageView:@"PostNoteView"];
//    [MobClick beginLogPageView:@"PostNoteView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [AVAnalytics endLogPageView:@"PostNoteView"];
//    [MobClick endLogPageView:@"PostNoteView"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString * content = self.textView.text;
    if (content.length == 0) {
        self.sendBtn.enabled = NO;
    }
    else
    {
        self.sendBtn.enabled = YES;
    }
}

//发送按钮
- (void)postButtonAction
{
    
    NSString * content = self.textView.text;
    
        [API postCommentForArticleWithArticleId:self.article.articleId Content:content success:^(GKArticleComment *comment) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"点评成功"];
            
            if (self.commentSuccessBlock) {
                self.commentSuccessBlock(comment);
            }
            
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }];
}

@end
