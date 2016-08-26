//
//  PNoteViewController.m
//  orange
//
//  Created by D_Collin on 15/12/21.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "PNoteViewController.h"
#import "API.h"
@interface PNoteViewController ()<UITextViewDelegate>

//评论视窗
@property (nonatomic ,strong)UIView * PostNotebackgroundview;
//textView
@property (nonatomic ,strong)UITextView * textView;
//占位文字
@property (nonatomic, strong) UILabel *tipLabel;
//获取键盘动态高度
@property (nonatomic, assign)NSInteger height;
//关闭按钮
@property (nonatomic,strong)UIButton * closeBtn;
//发送按钮
@property (nonatomic,strong)UIButton *sendBtn;
//标题
@property (nonatomic,strong)UILabel * LbTitle;
@end

@implementation PNoteViewController

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
    
    [self PostNote];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [AVAnalytics beginLogPageView:@"PostNoteView"];
    [MobClick beginLogPageView:@"PostNoteView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [AVAnalytics endLogPageView:@"PostNoteView"];
    [MobClick endLogPageView:@"PostNoteView"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _height = keyboardRect.size.height;
    
//    NSLog(@"键盘高度是  %ld",_height);
    
    [UIView animateWithDuration:0.25 animations:^{
        _PostNotebackgroundview.frame = CGRectMake(0, kScreenHeight - 200 - _height, kScreenWidth, 200);
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        _PostNotebackgroundview.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//评论视图创建
- (void)PostNote
{
    
    //后背景
    _PostNotebackgroundview = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    
    _PostNotebackgroundview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_PostNotebackgroundview];
    
    //textView
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 42, _PostNotebackgroundview.frame.size.width - 20, 148)];
    
    _textView.keyboardType = UIKeyboardTypeDefault;
    
    _textView.returnKeyType = UIReturnKeyDefault;
    
    _textView.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    
    _textView.scrollEnabled = YES;
    
    _textView.editable = YES;
    
    _textView.contentOffset = CGPointMake(10, 10);
    
    _textView.contentSize = CGSizeMake(kScreenWidth - 20, _textView.deFrameSize.height - 20);
    
    _textView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    
    _textView.textColor = UIColorFromRGB(0x666666);
    
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
    
    _closeBtn.frame = CGRectMake(10, 12, 18, 18);
    
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
    
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_PostNotebackgroundview addSubview:_closeBtn];
    
    //发送按钮
    _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 10 - 32, 0, 32, 44)];
    _sendBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    _sendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_sendBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
    [_sendBtn setTitle:[NSString fontAwesomeIconStringForEnum:FApaperPlane] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.backgroundColor = [UIColor clearColor];
    
    [_PostNotebackgroundview addSubview:_sendBtn];
    
    _LbTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 50, 14, 100, 16)];
    
    _LbTitle.text = @"撰写点评";
    
    _LbTitle.textAlignment = NSTextAlignmentCenter;
    
    [_PostNotebackgroundview addSubview:_LbTitle];
    
    
    //占位label
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth, 15)];
    //左距中
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    //背景色透明
    self.tipLabel.backgroundColor = [UIColor clearColor];
    //设置字体样式与大小
    [self.tipLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    self.tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.tipLabel.text = @"撰写真实、有用、有趣的商品点评";
    
    [self.textView addSubview:self.tipLabel];
    
    
}

- (void)closeBtnClick:(UIButton *)button
{
    
    [_textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

//发送按钮
- (void)postButtonAction
{
    NSInteger score = 0;
    //获取输入的文字内容
    NSString *content = self.textView.text;
    
    if (content.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入点评内容"];
        return;
    }
    
    if (self.note) {
        //修改点评
        [API updateNoteWithNoteId:self.note.noteId content:content score:score imageData:nil success:^(GKNote *note) {
            
          [self dismissViewControllerAnimated:YES completion:nil];
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (self.successBlock) {
                self.successBlock(note);
            }
            /**
             *  统计功能    AVAnalytics
             *
             *  稳定实时的数据统计分析服务，从用户量，用户行为，渠道效果，自定义事件等多个维度，帮助您更清楚的了解用户习惯，提高用户黏性和活跃度
             */               //event:自定义的事件Id   label:分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
//            [AVAnalytics event:@"update note" label:@"success"];
            [MobClick event:@"update note" label:@"success"];
        } failure:^(NSInteger stateCode) {
            
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
//            [AVAnalytics event:@"update note" label:@"failure"];
            [MobClick event:@"update note" label:@"failure"];
        }];
    } else {
        [API postNoteWithEntityId:self.entity.entityId content:content score:score imageData:nil success:^(GKNote *note) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            //用户点评数+1
            [Passport sharedInstance].user.noteCount += 1;
            if (self.successBlock) {
                self.successBlock(note);
            }
            
//            [AVAnalytics event:@"post note" label:@"success"];
            [MobClick event:@"post note" label:@"success"];
        } failure:^(NSInteger stateCode) {
            
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
//            [AVAnalytics event:@"post note" label:@"failure"];
            [MobClick event:@"post note" label:@"failure"];
        }];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.PostNotebackgroundview.frame =CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    self.textView.frame = CGRectMake(10, 42, _PostNotebackgroundview.frame.size.width - 20, 148);
    self.closeBtn.frame = CGRectMake(10, 12, 18, 18);
    self.sendBtn.frame = CGRectMake(kScreenWidth - 10 - 32, 0, 32, 44);
    self.LbTitle.frame= CGRectMake(kScreenWidth/2 - 50, 14, 100, 16);
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
