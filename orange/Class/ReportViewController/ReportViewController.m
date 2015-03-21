//
//  ReportViewController.m
//  orange
//
//  Created by huiter on 15/2/2.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "ReportViewController.h"
#import "GKAPI.h"
#import "RadioButton.h"
#import "UIPlaceHolderTextView.h"

static CGFloat NormalKeyboardHeight = 216.0f;
static CGFloat LeftMargin = 16.;

@interface ReportViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
//@property (nonatomic, strong) UIView *inputBG;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel * radioTipLabel;
@property (nonatomic) NSInteger radioType;
//@property (nonatomic, strong) UIla

@end

@implementation ReportViewController


#pragma mark - Life Cycle

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        _scrollView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _scrollView;
}

- (UILabel *)radioTipLabel
{
    if (!_radioTipLabel) {
        _radioTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _radioTipLabel.font = [UIFont systemFontOfSize:16.];
        _radioTipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _radioTipLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:_radioTipLabel];
    }
    return _radioTipLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:16.];
        _tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIPlaceHolderTextView *)textView
{
    if (!_textView) {
        _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        [_textView setKeyboardType:UIKeyboardTypeDefault];
        [_textView setReturnKeyType:UIReturnKeyDefault];
        [_textView setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        [_textView setScrollEnabled:YES];
        [_textView setEditable:YES];
        //[_textView becomeFirstResponder];
        [_textView setContentOffset:CGPointMake(10, 10)];
        _textView.contentSize = CGSizeMake(kScreenWidth-30, _textView.deFrameSize.height-20);
//        self.textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = UIColorFromRGB(0x666666);
        [_textView setTintColor:UIColorFromRGB(0x6d9acb)];
        _textView.delegate = self;
        _textView.spellCheckingType = UITextSpellCheckingTypeNo;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (void)CreateReasonButtons
{
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:4];
    CGRect btnRect = CGRectMake(LeftMargin, 60., kScreenWidth - LeftMargin * 2, 50);
    for (NSString* optionTitle in @[@"商品下架", @"分类错误", @"垃圾或诈骗信息", @"不良内容"]) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        //        btn.backgroundColor = [UIColor redColor];
        btnRect.origin.y += 50;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.view addSubview:btn];
        [buttons addObject:btn];
    }
    [buttons[0] setGroupButtons:buttons];
    
    [buttons[0] setSelected:YES];
}

- (void)loadView
{
//    [super loadView];
    self.view = self.scrollView;
//    self.title = @"举报";
//    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self CreateReasonButtons];
    self.radioTipLabel.frame = CGRectMake(LeftMargin , 10, kScreenWidth - LeftMargin * 2, 50.);
    self.radioTipLabel.text = @"请选择举报原因:";
    
    self.tipLabel.frame = CGRectMake(LeftMargin, 270., kScreenWidth - LeftMargin* 2, 50.);
    self.tipLabel.text = @"补充说明:";
    
    self.textView.frame = CGRectMake(LeftMargin, 320., kScreenWidth-LeftMargin*2, kScreenHeight - NormalKeyboardHeight- 180 - 40);
    self.textView.placeholder = @"靠谱的举报原因";
    
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

//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length >0) {
//        self.tipLabel.hidden = YES;
//    }
//    else
//    {
//        self.tipLabel.hidden = NO;
//    }
//}


#pragma mark - Selector Method

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
        [GKAPI reportEntityId:self.entity.entityId type:self.radioType comment:comment success:^(BOOL success) {
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

#pragma mark - 
- (void)onRadioButtonValueChanged:(RadioButton*)sender
{
//    NSLog(@"button %@", sender);
    if(sender.selected) {
        if ([sender.titleLabel.text isEqualToString:@"商品下架"]) {
            self.radioType = 0;
        }
        NSLog(@"Selected color: %@", sender.titleLabel.text);
    }
}

@end
