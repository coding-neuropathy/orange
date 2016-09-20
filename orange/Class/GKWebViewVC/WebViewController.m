//
//  WebViewController.m
//  orange
//
//  Created by 谢家欣 on 15/5/17.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "WebViewController.h"
#import <libWeChatSDK/WXApi.h>


#import "WebViewProgressView.h"
#import "EntityViewController.h"

//#import "ShareView.h"
#import "ShareController.h"


@interface WebViewController () 
{
    UIBarButtonItem *_more;
    UIBarButtonItem *_flex;
}
@property (strong, nonatomic) WebViewProgressView   *progressView;
@property (strong, nonatomic) UIImage               *image;
@property (strong, nonatomic) NSString              *shareTitle;
@property (strong, nonatomic) UIButton              *moreBtn;

@end

@implementation WebViewController


#pragma mark ----- UI -----
//更多按钮
- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.deFrameSize                = CGSizeMake(32., 44.);
        _moreBtn.titleLabel.textAlignment   = NSTextAlignmentCenter;
        
        [_moreBtn setImage:[UIImage imageNamed:@"more-1"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.backgroundColor = [UIColor clearColor];
        
    }
    return _moreBtn;
}

#pragma mark - init view
- (instancetype)initWithURL:(NSURL *)url
{
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
        
        // Create the user content controller and add the script to it
        WKUserContentController *userContentController = [WKUserContentController new];
        [userContentController addUserScript:script];
        
        // Create the configuration with the user content controller
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight - kStatusBarHeight) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - kStatusBarHeight) configuration:configuration];
        
        _webView.deFrameSize = IS_IPAD  ? CGSizeMake(kScreenWidth - kTabBarWidth, kScreenHeight)
                                        : CGSizeMake(kScreenWidth, kScreenHeight - kTabBarHeight - kStatusBarHeight);
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self creatBottomBar];
    
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];


    if (self.navigationController.viewControllers.count <= 1) {
        UIBarButtonItem * dismissBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissBtnAction:)];
        self.navigationItem.leftBarButtonItem = dismissBarItem;
        
    } else {
        UIBarButtonItem * moreBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
        self.navigationItem.rightBarButtonItem = moreBarItem;
    }
    
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
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    

    [MobClick beginLogPageView:@"webView"];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.progressView removeFromSuperview];
    
    [MobClick endLogPageView:@"webView"];
    [super viewWillDisappear:animated];
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.title = NSLocalizedStringFromTable(@"load", kLocalizedFile, nil);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    /**
     *  disable wkwebview zoom  
     */
//    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    
    [webView evaluateJavaScript:javascript completionHandler:nil];
}

//决定是否允许导航响应，如果不允许就不会跳转到该链接的页面
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"guoku"]) {
        NSURL *url = navigationAction.request.URL;
        
//        UIApplication *app = [UIApplication sharedApplication];
        if ([self.app canOpenURL:url]) {
            [self.app openURL:url];
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
        self.shareTitle = [result length] > 0 ? result : @"果库 - 精英消费指南";
        self.title = self.shareTitle;
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
//    ShareView * view = [[ShareView alloc] initWithTitle:self.shareTitle SubTitle:@"" Image:image URL:[self.webView.URL absoluteString]];
//    view.type = @"url";
//    view.tapRefreshButtonBlock = ^(){
//        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
//    };
//    [view show];
    ShareController * shareVC = [[ShareController alloc] initWithTitle:self.shareTitle URLString:self.webView.URL.absoluteString Image:image];
    shareVC.type    = URLShareType;
    shareVC.refreshBlock    = ^(){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    };
    [shareVC show];
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

- (void)dismissBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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


@end
