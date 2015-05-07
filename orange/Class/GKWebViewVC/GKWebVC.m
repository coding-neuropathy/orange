//
//  GKWebVC.m
//  Blueberry
//
//  Created by huiter on 13-10-16.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "GKWebVC.h"
#import "WXApi.h"

@interface GKWebVC ()<UIActionSheetDelegate,UIScrollViewDelegate>

- (void)initViews;
- (void)closeWebView;
- (void)goBack;
- (void)goForward;
- (void)reload;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImage * image;
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
    _webView.scrollView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bouncesZoom = NO;
    [self.view addSubview:_webView];
    
    NSMutableArray * array = [NSMutableArray array];
    
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
        button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [button setTitle:[NSString fontAwesomeIconStringForEnum:FAEllipsisH] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
        [array addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems = array;
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
        self.title = @"网页浏览";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self initViews];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.activityIndicator.color = [UIColor grayColor];
    self.activityIndicator.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-100);
    [self.view addSubview:self.activityIndicator];

    
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
    [AVAnalytics beginLogPageView:@"webView"];
    [MobClick beginLogPageView:@"webView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.activityIndicator stopAnimating];
    [AVAnalytics endLogPageView:@"webView"];
    [MobClick endLogPageView:@"webView"];
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
    NSString * imageURL = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[1].src"];
    UIImageView * a = [[UIImageView alloc]init];
    [a sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
    }];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
        }
            break;
    }
}

- (void)moreButtonAction
{
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:@"分享到微博"];
    [array addObject:@"分享到微信"];
    [array addObject:@"分享到朋友圈"];

    if ([[self.webView.request.URL absoluteString]containsString:@"400000_12313170"]) {
        [array addObject:@"在淘宝客户端中打开"];
    }
    [array addObject:@"在 Safari 中打开"];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for (NSString * string in array) {
        [actionSheet addButtonWithTitle:string];
    }
    
    
    [actionSheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"在淘宝客户端中打开"]) {
       NSString * url =  [[self.webView.request.URL absoluteString]stringByReplacingOccurrencesOfString:@"http://" withString:@"taobao://"];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }else if ([buttonTitle isEqualToString:@"分享到微博"]) {
        [self weiboShare];
    }else if ([buttonTitle isEqualToString:@"分享到微信"]) {
        [self wxShare:0];
    }else if ([buttonTitle isEqualToString:@"分享到朋友圈"]) {
        [self wxShare:1];
    }else if ([buttonTitle isEqualToString:@"在 Safari 中打开"]) {
        [[UIApplication sharedApplication]openURL:self.webView.request.URL];
    }
}
#pragma mark - WX&Weibo
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
    ext.url = [self.webView.request.URL absoluteString];
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}
-(void)weiboShare
{
    if([AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo ])
    {
        [AVOSCloudSNS refreshToken:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            [AVOSCloudSNS shareText:self.title andLink:[self.webView.request.URL absoluteString] andImage:[UIImage imageNamed:@"wxshare"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
                
            } andProgress:^(float percent) {
                if (percent == 1) {
                    [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
                }
            }];
        }];
    }
    else
    {
        [AVOSCloudSNS shareText:self.title andLink:[self.webView.request.URL absoluteString] andImage:[UIImage imageNamed:@"wxshare"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            
        } andProgress:^(float percent) {
            if (percent == 1) {
                [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
            }
        }];
    }
}

- (void)configTitleView
{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    [label setText:self.title];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textColor = UIColorFromRGB(0x414243);
    label.adjustsFontSizeToFitWidth = YES;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = label;
}

@end
