//
//  NotePostViewController.m
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NotePostViewController.h"
#import "API.h"
static CGFloat NormalKeyboardHeight = 216.0f;

@interface NotePostViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *inputBG;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation NotePostViewController




#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _inputBG = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight - NormalKeyboardHeight- 180 - 40 + 15.f)];
    self.inputBG.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self.view addSubview:_inputBG];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-30, kScreenHeight - NormalKeyboardHeight- 180 - 40)];
    [self.textView setKeyboardType:UIKeyboardTypeDefault];
    [self.textView setReturnKeyType:UIReturnKeyDefault];
    [self.textView setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [self.textView setScrollEnabled:YES];
    [self.textView setEditable:YES];
    [self.textView becomeFirstResponder];
    [self.textView setContentOffset:CGPointMake(10, 10)];
    self.textView.contentSize = CGSizeMake(kScreenWidth-30, _textView.deFrameSize.height-20);
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = UIColorFromRGB(0x666666);
    [self.textView setTintColor:UIColorFromRGB(0x6d9acb)];
    self.textView.delegate = self;
    self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self.view addSubview:self.textView];
    
    
    if(_inputBG.deFrameHeight < 120)
    {
        self.inputBG.deFrameHeight = 120;
    }
    
    if(self.textView.deFrameHeight < 105)
    {
        self.textView.deFrameHeight = 105;
    }
    
    
    //    _addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(self.inputBG.deFrameRight-70, _inputBG.deFrameTop+10, 60, 60)];
    //    [self.addPhotoButton setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
    //    [self.addPhotoButton addTarget:self action:@selector(tapAddPhotoButton) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.addPhotoButton];
    /*
     _H = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - NormalKeyboardHeight- 100, kScreenWidth, 1)];
     _H.backgroundColor = UIColorFromRGB(0xeaeaea);
     [self.view addSubview:_H];
     
     _shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _H.deFrameBottom+10, 72, 15)];
     self.shareLabel.textAlignment = NSTextAlignmentLeft;
     self.shareLabel.backgroundColor = [UIColor clearColor];
     [self.shareLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
     self.shareLabel.textColor = UIColorFromRGB(0x666666);
     self.shareLabel.text = @"同时分享到：";
     [self.view addSubview:self.shareLabel];
     
     _sinaShareButton = [[UIButton alloc]initWithFrame:CGRectMake(_shareLabel.deFrameRight, _H.deFrameBottom+8, 30, 20)];
     [self.sinaShareButton setImage:[UIImage imageNamed:@"icon_sina.png"] forState:UIControlStateNormal];
     [self.view addSubview:self.sinaShareButton];
     
     _weixinShareButton = [[UIButton alloc]initWithFrame:CGRectMake(_sinaShareButton.deFrameRight, _H.deFrameBottom+8, 30, 20)];
     [self.weixinShareButton setImage:[UIImage imageNamed:@"icon_weixin.png"] forState:UIControlStateNormal];
     [self.view addSubview:self.weixinShareButton];
     */
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    self.tipLabel.backgroundColor = [UIColor clearColor];
    [self.tipLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    self.tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.tipLabel.text = @"撰写真实、有用、有趣的商品点评";
    
    self.tipLabel.deFrameLeft = self.textView.deFrameLeft+10;
    self.tipLabel.deFrameTop = self.textView.deFrameTop+8;
    [self.view addSubview:self.tipLabel];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"撰写点评";
    NSMutableArray * array = [NSMutableArray array];
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
        button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [button setTitle:[NSString fontAwesomeIconStringForEnum:FApaperPlane] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
        [array addObject:item];
    }
    self.navigationItem.rightBarButtonItems = array;
    
    if (self.note) {
        self.textView.text = self.note.text;
        if (self.textView.text.length >0) {
            self.tipLabel.hidden = YES;
        }
        else
        {
            self.tipLabel.hidden = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"PostNoteView"];
    [MobClick beginLogPageView:@"PostNoteView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"PostNoteView"];
    [MobClick endLogPageView:@"PostNoteView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Selector Methdo

- (void)postButtonAction
{
    NSInteger score = 0;
    NSString *content = self.textView.text;
    
    if (content.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入点评内容"];
        return;
    }
    
    if (self.note) {
        [API updateNoteWithNoteId:self.note.noteId content:content score:score imageData:nil success:^(GKNote *note) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showImage:nil status:@"修改成功"];
            if (self.successBlock) {
                self.successBlock(note);
            }
            [AVAnalytics event:@"update note" label:@"success"];
            [MobClick event:@"update note" label:@"success"];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"修改失败"];
            [AVAnalytics event:@"update note" label:@"failure"];
            [MobClick event:@"update note" label:@"failure"];
        }];
    } else {
        [API postNoteWithEntityId:self.entity.entityId content:content score:score imageData:nil success:^(GKNote *note) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showImage:nil status:@"发布成功"];
            [Passport sharedInstance].user.noteCount += 1;
            if (self.successBlock) {
                self.successBlock(note);
            }
            
            [AVAnalytics event:@"post note" label:@"success"];
            [AVAnalytics event:@"post note" label:@"success"];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"发布失败"];
            [AVAnalytics event:@"post note" label:@"failure"];
            [MobClick event:@"post note" label:@"failure"];
        }];
    }
}

@end
