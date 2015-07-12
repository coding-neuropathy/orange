//
//  WebViewController.m
//  orange
//
//  Created by 谢家欣 on 15/5/17.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "WebViewController.h"
#import "WXApi.h"

#import <WebKit/WebKit.h>
#import "WebViewProgressView.h"
#import "SDWebImageDownloader.h"
//#import "WebViewProgress.h"
#import "ShareView.h"

@interface WebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) NSURL * url;
@property (strong, nonatomic) WKWebView * webView;

//@property (strong, nonatomic) WebViewProgress * progressProxy;
@property (strong, nonatomic) WebViewProgressView * progressView;
@property (strong, nonatomic) UIImage * image;
//@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation WebViewController

- (instancetype)initWithURL:(NSURL *)url
{
    if (self) {
        self.url = url;
//        self.progressProxy = [[WebViewProgress alloc] init];
//        self.progressProxy.webViewProxyDelegate = self;
//        self.progressProxy.progressDelegate = self;
    }
    return self;
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView sizeToFit];
    }
    return _webView;
}
//
//- (UIActivityIndicatorView *)activityIndicator
//{
//    if (!_activityIndicator) {
//        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        _activityIndicator.color = [UIColor grayColor];
//        _activityIndicator.center = CGPointMake(kScreenWidth / 2., kScreenHeight / 2. - 100.);
//        
//    }
//    return _activityIndicator;
//}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)loadView
{
    self.view = self.webView;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
//    [self.view addSubview:self.activityIndicator];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
    button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
    [button setTitle:[NSString fontAwesomeIconStringForEnum:FAEllipsisH] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    UIBarButtonItem * moreBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = moreBarItem;
    
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[WebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];

    [AVAnalytics beginLogPageView:@"webView"];
    [MobClick beginLogPageView:@"webView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    //    [SVProgressHUD dismiss];
    //    [self.activityIndicator stopAnimating];
    [AVAnalytics endLogPageView:@"webView"];
    [MobClick endLogPageView:@"webView"];
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    NSString * imageURL = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[1].src"];
//    UIImageView * a = [[UIImageView alloc]init];
//    [a sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.image = image;
//    }];
    [webView evaluateJavaScript:@"document.getElementsByTagName('img')[1].src" completionHandler:^(NSString * imageURL, NSError * error) {
//        NSString * imageURL = imageURL;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (finished) {
                self.image = image;
            }
        }];
        
    }];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *result, NSError *error) {
        self.title = result;
    }];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - button action
- (void)moreButtonAction:(id)sender
{
    UIImage * image = [UIImage imageNamed:@"wxshare"];
    if (self.image) {
        image = [UIImage imageWithData:[self.image imageDataLessThan_10K]];
    }
    
    
    ShareView * view = [[ShareView alloc]initWithTitle:self.title SubTitle:@"" Image:image URL:[self.webView.URL absoluteString]];
    view.type = @"url";
    view.tapRefreshButtonBlock = ^(){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    };
    [view show];
    /*
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    UIAlertAction * shareWeiboAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"share to weibo", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self weiboShare];
    }];
    
    UIAlertAction * shareWechatAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"share to wechat", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self wxShare:0];
    }];
    
    UIAlertAction * shareMomentAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"share to moment", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self wxShare:1];
    }];
    
    UIAlertAction * openInSafariAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"open in safari", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication]openURL:self.webView.URL];
    }];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:shareWeiboAction];
    [alertController addAction:shareWechatAction];
    [alertController addAction:shareMomentAction];
    [alertController addAction:openInSafariAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
     */
}

#pragma mark - webview kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - share to sns
-(void)weiboShare
{
    if([AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo ])
    {
        [AVOSCloudSNS refreshToken:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            [AVOSCloudSNS shareText:self.title andLink:[self.webView.URL absoluteString] andImage:[UIImage imageNamed:@"wxshare"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
                
            } andProgress:^(float percent) {
                if (percent == 1) {
                    [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
                }
            }];
        }];
    }
    else
    {
        [AVOSCloudSNS shareText:self.title andLink:[self.webView.URL absoluteString] andImage:[UIImage imageNamed:@"wxshare"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            
        } andProgress:^(float percent) {
            if (percent == 1) {
                [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
            }
        }];
    }
}

-(void)wxShare:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description= @"";
    if (self.image) {
        [message setThumbImage:[UIImage imageWithData:[self.image imageDataLessThan_10K]]];
    }
    else
    {
        [message setThumbImage:[UIImage imageNamed:@"wxshare"]];
    }
    
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.url = [self.webView.URL absoluteString];
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

@end
