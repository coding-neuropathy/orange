//
//  WebViewController.m
//  orange
//
//  Created by 谢家欣 on 15/5/17.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "WebViewController.h"
#import "WXApi.h"


#import "WebViewProgressView.h"
#import "SDWebImageDownloader.h"
#import "EntityViewController.h"

#import "ShareView.h"
#import "LoginView.h"

@interface WebViewController () 
{
    UIBarButtonItem *_more;
    UIBarButtonItem *_flex;
}
@property (strong, nonatomic) WebViewProgressView * progressView;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSString * shareTitle;

@property (strong, nonatomic) UIApplication * app;

@property (nonatomic , strong)UIButton * moreBtn;

@end

@implementation WebViewController


#pragma mark ----- UI -----
//更多按钮
//- (UIButton *)moreBtn
//{
//    if (!_moreBtn) {
//        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _moreBtn.frame = CGRectMake(0., 0., 32., 44.);
//        [_moreBtn setImage:[UIImage imageNamed:@"more-1"] forState:UIControlStateNormal];
//        _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        _moreBtn.backgroundColor = [UIColor clearColor];
//        
//    }
//    return _moreBtn;
//}

#pragma mark - init view
- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

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
        
        // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
        NSString *source = @"var style = document.createElement('style'); \
        style.type = 'text/css'; \
        style.innerText = '*:not(input):not(textarea) { -webkit-user-select: none; -webkit-touch-callout: none; }'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(style);";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
//        NSString *source = @"var meta = document.createElement('meta'); \
//        meta.name = 'viewport'; \
//        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
//        var head = document.getElementsByTagName('head')[0];\
//        head.appendChild(meta);";
//        WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        // Create the user content controller and add the script to it
        WKUserContentController *userContentController = [WKUserContentController new];
        [userContentController addUserScript:script];
        
        // Create the configuration with the user content controller
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight - kStatusBarHeight) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - kStatusBarHeight) configuration:configuration];
//        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        [_webView sizeToFit];
    
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (self.app.statusBarOrientation == UIInterfaceOrientationLandscapeRight ||
            self.app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
            _webView.center = CGPointMake((kScreenWidth - kTabBarWidth) / 2, kScreenHeight / 2);
        
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

//- (void)loadView
//{
//    
//    self.view = self.webView;
//    self.view.backgroundColor = UIColorFromRGB(0xffffff);
//    //    [self.view addSubview:self.activityIndicator];
//    
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self creatBottomBar];
    
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];

        _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
        [_moreBtn setImage:[UIImage imageNamed:@"more-1"] forState:UIControlStateNormal];
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * moreBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
        _more = moreBarItem;
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _flex = flexItem;
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem,flexItem,flexItem,flexItem,flexItem,moreBarItem,nil]];
    
    
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

//    [AVAnalytics beginLogPageView:@"webView"];
    [MobClick beginLogPageView:@"webView"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [MobClick endLogPageView:@"webView"];
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
   
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    /**
     *  disable wkwebview zoom  
     */
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    
    [webView evaluateJavaScript:javascript completionHandler:nil];
}

//决定是否允许导航响应，如果不允许就不会跳转到该链接的页面
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    NSLog(@"%@", navigationAction.request.URL.absoluteString);
//    DDLogInfo(@"%@",navigationAction.targetFrame.request.URL.absoluteString);
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"guoku"]) {
        NSURL *url = navigationAction.request.URL;
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }
    }
    //this is a 'new window action' (aka target="_blank") > open this URL externally. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of the iOS 8 Beta
    else if (!navigationAction.targetFrame) {
        [self.webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"document.getElementById('share_img').getElementsByTagName('img')[0].src" completionHandler:^(NSString * imageURL, NSError * error) {
        
        if (imageURL) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished) {
                    self.image = image;
                }
            }];
        }
        else{
            
            [webView evaluateJavaScript:@"document.getElementsByTagName('img')[1].src" completionHandler:^(NSString * imageURL, NSError * error) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (finished) {
                        self.image = image;
                    }
                }];
                
            }];
        }
        
    }];
    

    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *result, NSError *error) {
//        self.title = result;
        if (result) {
            self.shareTitle = result;
        }
        else
        {
            self.shareTitle = @"果库 - 精英消费指南";
        }
//        NSLog(@"%@",self.shareTitle);
    }];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
//         [self.collectionView performBatchUpdates:nil completion:nil];
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
//         self.webView.frame = CGRectMake((self.view.deFrameWidth - self.webView.deFrameWidth) /2, 0., 684., self.view.deFrameHeight);
         if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight || self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
             self.webView.frame = CGRectMake(128., 0., 684., kScreenHeight);
         else
             self.webView.frame = CGRectMake(0., 0., 684., kScreenHeight);
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

#pragma mark - button action
- (void)moreButtonAction:(id)sender
{
    UIImage * image = [UIImage imageNamed:@"wxshare"];
    if (self.image) {
        image = [UIImage imageWithData:[self.image imageDataLessThan_10K]];
    }
    
//    DDLogError(@"title %@", self.shareTitle);
    ShareView * view = [[ShareView alloc] initWithTitle:self.shareTitle SubTitle:@"" Image:image URL:[self.webView.URL absoluteString]];
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




#pragma mark - button action
- (void)backAction:(id)sender
{
    if([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark ---------- create Bottom Bar -------------

- (void)creatBottomBar
{
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
//    _moreButton = moreItem;
   
    
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    _flexItem = flexItem;
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem,flexItem,flexItem,flexItem,flexItem,moreItem,nil]];
}


@end
