//
//  GKWebVC.m
//  Blueberry
//
//  Created by huiter on 13-10-16.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "GKWebVC.h"

@interface GKWebVC ()

- (void)initViews;
- (void)closeWebView;
- (void)goBack;
- (void)goForward;
- (void)reload;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation GKWebVC

@synthesize data = _data;
@synthesize link = _link;
@synthesize webView = _webView;


- (void)initViews
{


    //[self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];

    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreenHeight -kNavigationBarHeight-kStatusBarHeight)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bouncesZoom = NO;
    [self.view addSubview:_webView];
}

- (void)closeWebView
{
    self.webView.delegate = nil;
    if ([_webView isLoading]) {
        [_webView stopLoading];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)goBack
{
    [_webView goBack];
}

- (void)goForward
{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (void)reload
{
    [_webView reload];
}

#pragma mark - Class Method

+ (GKWebVC *)linksWebViewControllerWithURL:(NSURL *)url
{
    GKWebVC * _webVC = [[GKWebVC alloc] init];
    _webVC.link = url;
    return _webVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *titleView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        [titleView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        [label setText:@"宝贝详情"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:20];
        label.textColor = UIColorFromRGB(0x555555);
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        
        titleView.deFrameWidth = label.deFrameWidth +10;
        [titleView addSubview:label];
        
        label.center = CGPointMake(titleView.frame.size.width/2, titleView.frame.size.height/2);
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.activityIndicator.color = UIColorFromRGB(0x427ec0);
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicator];
        
        self.navigationItem.titleView = titleView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self initViews];
    
    NSURLRequest * _request;
    _request = [NSURLRequest requestWithURL:_link];
    [_webView loadRequest:_request];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.activityIndicator stopAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[SVProgressHUD show];
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self.activityIndicator stopAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [self.activityIndicator stopAnimating];
    switch (error.code) {
        case -999:
        case 101:
        case -1003:
            break;
        default:
        {
            [SVProgressHUD showImage:nil status:@"加载失败"];
        }
            break;
    }
    
    
}

@end
