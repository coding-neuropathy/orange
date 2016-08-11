//
//  ForgetPasswdController.m
//  orange
//
//  Created by 谢家欣 on 16/8/11.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ForgetPasswdController.h"

@interface FoundPasswdView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) UILabel * emailLabel;
@property (strong, nonatomic) UITextField * emailTextField;
@property (strong, nonatomic) UIButton * foundBtn;

@end

@interface ForgetPasswdController ()

@property (strong, nonatomic) FoundPasswdView * fpView;

@end

@implementation ForgetPasswdController

- (FoundPasswdView *)fpView
{
    if (!_fpView) {
        _fpView = [[FoundPasswdView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    }
    return _fpView;
}

- (void)loadView
{
    self.view = self.fpView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = NSLocalizedStringFromTable(@"found-password", kLocalizedFile, nil);
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

@end

#pragma mark - <FoundPasswdView>
@implementation FoundPasswdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)emailLabel
{
    if (!_emailLabel) {
        _emailLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _emailLabel.font            = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _emailLabel.text            = NSLocalizedStringFromTable(@"email", kLocalizedFile, nil);
        _emailLabel.textColor       = UIColorFromRGB(0x212121);
        _emailLabel.textAlignment   = NSTextAlignmentLeft;
        
        //        CGFloat width               = [_emailLabel.text widthWithLineWidth:0. Font:_emailLabel.font];
        _emailLabel.frame           = CGRectMake(0., 0., 80., 20.);
    }
    return _emailLabel;
}

- (UITextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField                         = [[UITextField alloc] initWithFrame:CGRectZero];
        _emailTextField.textColor               = UIColorFromRGB(0xbdbdbd);
        _emailTextField.font                    = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _emailTextField.leftView                = self.emailLabel;
        _emailTextField.leftViewMode            = UITextFieldViewModeAlways;
        _emailTextField.autocorrectionType      = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType  = UITextAutocapitalizationTypeNone;
        _emailTextField.placeholder             = @"example@guoku.com";
        _emailTextField.clearButtonMode         = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType           = UIReturnKeySend;
        _emailTextField.keyboardType            = UIKeyboardTypeEmailAddress;
        _emailTextField.textAlignment           = NSTextAlignmentLeft;
        _emailTextField.backgroundColor         = [UIColor clearColor];
        _emailTextField.delegate                = self;
        [self addSubview:_emailTextField];
    }
    return _emailTextField;
}

- (UIButton *)foundBtn
{
    if (!_foundBtn) {
        _foundBtn                               = [UIButton buttonWithType:UIButtonTypeCustom];
        _foundBtn.titleLabel.font               = [UIFont fontWithName:@"PingFangSC-Medium" size:18.];
        _foundBtn.titleLabel.textAlignment      = NSTextAlignmentCenter;
        _foundBtn.layer.borderColor             = UIColorFromRGB(0x5192ff).CGColor;
        _foundBtn.layer.borderWidth             = 0.5;
        
        [_foundBtn setTitle:NSLocalizedStringFromTable(@"found-password", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_foundBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        
        [_foundBtn addTarget:self action:@selector(foundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_foundBtn];
    }
    return _foundBtn;
}

#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.emailTextField.frame           = CGRectMake(0., 0., 290 * kScreeenScale, 46. * kScreeenScale);
    self.emailTextField.deFrameTop      = 33. + kNavigationBarHeight + kStatusBarHeight;
    self.emailTextField.deFrameLeft     = ( kScreenWidth - self.emailTextField.deFrameWidth ) / 2.;

    self.foundBtn.frame                 = CGRectMake(0., 0., 290. * kScreeenScale, 44. * kScreeenScale);
    self.foundBtn.center                = self.emailTextField.center;
    self.foundBtn.deFrameTop            = self.emailTextField.deFrameBottom + 22.;
    self.foundBtn.layer.cornerRadius    = self.foundBtn.deFrameHeight / 2.;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, self.emailTextField.deFrameLeft, self.emailTextField.deFrameBottom);
    CGContextAddLineToPoint(context, self.emailTextField.deFrameRight, self.emailTextField.deFrameBottom);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self foundBtnAction:nil];
    return YES;
}

#pragma mark - button action
- (void)foundBtnAction:(id)sender
{
    DDLogInfo(@"send send");
}

@end
