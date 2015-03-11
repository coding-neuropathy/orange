//
//  ReportViewController.m
//  orange
//
//  Created by huiter on 15/2/2.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "ReportViewController.h"
#import "GKAPI.h"
static CGFloat NormalKeyboardHeight = 216.0f;
@interface ReportViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *inputBG;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation ReportViewController


#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.title = @"举报";
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
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 15)];
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    self.tipLabel.backgroundColor = [UIColor clearColor];
    [self.tipLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    self.tipLabel.textColor = UIColorFromRGB(0x999999);
    self.tipLabel.text = @"举报原因";
    
    self.tipLabel.deFrameLeft = self.textView.deFrameLeft+10;
    self.tipLabel.deFrameTop = self.textView.deFrameTop+8;
    [self.view addSubview:self.tipLabel];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我要举报";
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
    
        if (self.textView.text.length >0) {
            self.tipLabel.hidden = YES;
        }
        else
        {
            self.tipLabel.hidden = NO;
        }

}

- (void)setNote:(GKNote *)note
{
    _note = note;
    self.type = @"note";
}
- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    self.type = @"entity";
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
    NSString *comment = self.textView.text;
    if (comment.length == 0) {
        [SVProgressHUD showImage:nil status:@"请填写举报原因"];
        return;
    }
    
    
    if (self.note) {
        [GKAPI reportNoteId:self.note.noteId comment:comment success:^(BOOL success) {
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showImage:nil status:@"举报成功"];
            }
            else
            {
                [SVProgressHUD showImage:nil status:@"举报失败"];
            }
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"举报失败"];
        }];
    }
    else if (self.entity) {
        [GKAPI reportEntityId:self.entity.entityId comment:comment success:^(BOOL success) {
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showImage:nil status:@"举报成功"];
            }
            else
            {
                [SVProgressHUD showImage:nil status:@"举报失败"];
            }
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"举报失败"];
        }];
    }
}

@end
