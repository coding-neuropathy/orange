//
//  ShareController.m
//  orange
//
//  Created by 谢家欣 on 16/9/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ShareController.h"
#import "ShareView.h"
#import "ShareViewCell.h"

#import "ThreePartHandler.h"
#import "ReportViewController.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface ShareController () <ShareViewDelegate, ShareViewDataSource, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString                      *shareTitle;
@property (strong, nonatomic) UIImage                       *shareImage;
@property (strong, nonatomic) NSString                      *urlString;

@property (strong, nonatomic) NSMutableArray                *dataArray;

@property (strong, nonatomic) MFMailComposeViewController   *composer;

@property (strong, nonatomic) UIVisualEffectView            *effectview;
@property (strong, nonatomic) ShareView                     *shareView;


@end

@implementation ShareController

- (instancetype)initWithTitle:(NSString *)title URLString:(NSString *)urlString Image:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.shareTitle     = title;
        self.shareImage     = image;
        self.urlString      = urlString;
    }
    return self;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray  = [[NSMutableArray alloc] initWithCapacity:0];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"share to moment", kLocalizedFile, nil),
                                @"image"    : @"share_moment",
                                }];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"share to wechat", kLocalizedFile, nil),
                                @"image"    : @"share_wechat",
                                }];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"weibo", kLocalizedFile, nil),
                                @"image"    : @"share_weibo",
                                }];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"open in safari", kLocalizedFile, nil),
                                @"image"    : @"share_safari",
                                }];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"mail", kLocalizedFile, nil),
                                @"image"    : @"share_mail",
                                }];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"refresh", kLocalizedFile, nil),
                                @"image"    : @"share_refresh",
                                }];
    
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"copy-link", kLocalizedFile, nil),
                                @"image"    : @"share_copy",
                                }];
        
        [_dataArray addObject:@{
                                @"title"    : NSLocalizedStringFromTable(@"tip off", kLocalizedFile, nil),
                                @"image"    : @"share_report",
                                }];
    }
    return _dataArray;
}

#pragma mark - lazy load 
- (UIVisualEffectView *)effectview
{
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.deFrameSize = CGSizeMake(kScreenWidth ,kScreenHeight);
        _effectview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _effectview.alpha = 0.8;
    }
    return _effectview;
}

- (ShareView *)shareView
{
    if (!_shareView) {
        _shareView                  = [[ShareView alloc] initWithFrame:CGRectZero];
        _shareView.backgroundColor  = [UIColor colorFromHexString:@"#f4f4f4"];
        _shareView.deFrameSize      = CGSizeMake(kScreenWidth, 358);
        _shareView.deFrameTop       = kScreenHeight;
        
        _shareView.delegate         = self;
        _shareView.datasource       = self;

        
//        [_shareView reloadData];
    }
    return _shareView;
}


- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.effectview];
    [self.view addSubview:self.shareView];
    
    [self.shareView registerClass:[ShareViewCell class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (location.y > self.shareView.deFrameTop) return;

    [self dismiss];
}

#pragma mark - 
- (void)fadeIn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.deFrameTop   = kScreenHeight - self.shareView.deFrameHeight;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOutWithCompletion:(void (^)())completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.deFrameTop   = kScreenHeight;
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if (completion) {
            completion();
        }
    }];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:self];
    [self fadeIn];
}

- (void)dismissWithCompletion:(void (^ __nullable)())completion
{
    [self fadeOutWithCompletion:completion];
}


- (void)dismiss
{
    [self dismissWithCompletion:nil];
}

#pragma mark - 
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         self.shareView.deFrameWidth    = size.width;
         self.shareView.deFrameBottom   = self.view.deFrameBottom;
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

#pragma mark - <ShareViewDataSource>
- (NSInteger)numberOfcellInShareView:(UIView *)shareview
{
    return self.dataArray.count;
}

- (CGFloat)shareViewMargin
{
    return 15.;
}

- (CGFloat)itemSpaceInShareView
{
    return 12.;
}

- (CGSize)shareView:(ShareView *)shareview sizeForItemAtIndex:(NSInteger)index
{
    return CGSizeMake(60., 90.);
}

- (UIView *)shareView:(ShareView *)shareview viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{

    ShareViewCell * cell = (ShareViewCell *)view;
    if (!cell) {
        cell = (ShareViewCell *)[shareview dequeueItemViewIndex:index];
    }
   
    NSDictionary * row = [self.dataArray objectAtIndex:index];
    [cell setIconWithImage:[UIImage imageNamed:[row objectForKey:@"image"]]
                     Title:[row objectForKey:@"title"]];

    return cell;
}

#pragma mark - <ShareViewDelegate>
- (void)handleCancelBtnAction:(id)sender
{
    [self dismiss];
}

- (void)handleShareOnMomentsAction:(id)sender
{
    [self dismissWithCompletion:^{
        [[ThreePartHandler sharedThreePartHandler] wxShare:1
                                                ShareImage:self.shareImage
                                                     Title:self.shareTitle
                                                       URL:self.urlString];
    }];
}

- (void)handleShareToWeChat:(id)sender
{
    [self dismissWithCompletion:^{
        [[ThreePartHandler sharedThreePartHandler] wxShare:0
                                                ShareImage:self.shareImage
                                                     Title:self.shareTitle
                                                       URL:self.urlString];
    }];
}

- (void)handleShareToWeibo:(id)sender
{
    [self dismissWithCompletion:^{
        [[ThreePartHandler sharedThreePartHandler] weiboShareWithTitle:self.shareTitle
                                                            ShareImage:self.shareImage
                                                             URLString:self.urlString];
    }];
}

- (void)handleOpenInSafari:(id)sender
{
    [self dismissWithCompletion:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
    }];
}

- (void)handleSendMail:(id)sender
{
        if ([MFMailComposeViewController canSendMail]) {
            self.composer = [[MFMailComposeViewController alloc] init];
            self.composer.mailComposeDelegate = self;
            [self.composer setSubject:@"果库 - 精英消费指南"];
            if (self.type == ArticleType) {
                [self.composer setMessageBody:self.article.content isHTML:YES];
            } else {
                [self.composer setMessageBody:[self.shareTitle stringByAppendingString:[NSString stringWithFormat:@"<br><a href='%@' target='_blank'>购买链接</a>", self.urlString]] isHTML:YES];
            }
            /*
            if (self.image) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                UIImage *ui = self.image;
                pasteboard.image = ui;
                NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(ui)];
                [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@" "];
            }
             */
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self.shareImage)];
            [self.composer addAttachmentData:imageData mimeType:@"image/png" fileName:@"attach.png"];
            
            if (self.composer) {
                UIViewController * controller =  [UIApplication sharedApplication].keyWindow.rootViewController;
                self.view.hidden = YES;
                [controller presentViewController:self.composer animated:YES completion:^{
                    
                }];
            }
        }else
        {
            [SVProgressHUD showImage:nil status:@"当前设备没有设置邮箱"];
        }
}

- (void)handlePageRefreshRequest:(id)sender
{
    if (self.refreshBlock) {
        [self dismissWithCompletion:self.refreshBlock];
    }
}

- (void)handlerCopyURL:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.urlString;
    [SVProgressHUD showImage:nil status:@"已复制"];
    [self dismiss];
}

- (void)handlerTipOff:(id)sender
{
    [self dismissWithCompletion:^{
        ReportViewController * VC = [[ReportViewController alloc] init];
        VC.entity = self.entity;
        if(!k_isLogin)
        {
            [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
                [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
            }];
        } else {
            [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
        }
    }];
}

#pragma mark - <MFMailComposeViewControllerDelegate>
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"send-success", kLocalizedFile, nil)];
            
            break;
        case MFMailComposeResultFailed:
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"send-failure", kLocalizedFile, nil)];
            break;
        default:
            break;
    }
    self.view.hidden    = NO;
    [controller dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [self dismiss];
        }
    }];
}


@end
