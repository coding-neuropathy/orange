//
//  GKTaobaoOAuthViewController.m
//  Catpower
//
//  Created by 梁 玮殷 on 3/12/12.
//  Copyright (c) 2012 QIN Network Technology Co., Ltd. All rights reserved.
//


#import "GKTaobaoOAuthViewController.h"

@interface GKTaobaoOAuthViewController (private)
- (void)loadWebPageWithString: (NSString *)urlString;
@end

@implementation GKTaobaoOAuthViewController

@synthesize webV = _webV;
@synthesize delegate = _delegate;
@synthesize activity = _activity;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)clearWebViewCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

+(void)clean
{
    /*
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"key"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"topsession"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nick"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"taobao_refresh_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"taobao_user_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"expires_in"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"re_expires_in"];
     */
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTaobaoGrantInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)taobaoOAuthViewController
{
    GKTaobaoOAuthViewController *vc = [[GKTaobaoOAuthViewController alloc] init];    
    return vc;
}


- (void)loadView
{
    [super loadView];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    
    self.webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    _webV.scalesPageToFit = YES;
    _webV.delegate = self;
    [self.view addSubview:_webV];
    
    _webV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    self.activity.center = self.view.center;
    [self.view addSubview:_activity];
    NSString *two = [NSString stringWithFormat:@"%@?response_type=token&client_id=%@&scope=item&view=wap", kGKTaoBaoOAuthUrl, kGKTaoBaoAppKey];
    [self loadWebPageWithString:two];
}

-(BOOL)bindSuccess:(UIWebView *)webview
{
    NSString *currentURL = [[[[webview request] URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[[[webview request] URL] path] isEqualToString:@"/oauth2"]) {
        NSString *queryString = [currentURL substringFromIndex:41];
        
        NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
        
        if (0 != [pairs count]) {
            NSMutableDictionary *kvPairs = [NSMutableDictionary dictionaryWithCapacity:1];
            
            for (NSString *pair in pairs) {
                NSArray *bits = [pair componentsSeparatedByString:@"="];
                NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                NSString *value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                
                [kvPairs setObject:value forKey:key];
            }
//            NSLog(@"tao tao %@", kvPairs);
            NSMutableDictionary * paramters = [NSMutableDictionary dictionaryWithCapacity:7];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([kvPairs valueForKeyPath:@"access_token"]) {
                [paramters setObject:[kvPairs valueForKeyPath:@"access_token"] forKey:@"access_token"];
            } else if ([kvPairs valueForKeyPath:@"#access_token"]) {
                [paramters setObject:[kvPairs valueForKeyPath:@"#access_token"] forKey:@"access_token"];
            }
            [paramters setObject:[kvPairs valueForKeyPath:@"taobao_user_nick"] forKey:@"screen_name"];
            [paramters setObject:[kvPairs valueForKeyPath:@"refresh_token"] forKey:@"refresh_token"];
//            [paramters setObject:[kvPairs valueForKeyPath:@"mobile_token"] forKey:@"sid"];
            [paramters setObject:[kvPairs valueForKeyPath:@"taobao_user_id"] forKey:@"taobao_id"];
            [paramters setObject:[kvPairs valueForKeyPath:@"expires_in"] forKey:@"expires_in"];
            [paramters setObject:[kvPairs valueForKeyPath:@"re_expires_in"] forKey:@"re_expires_in"];
            [userDefault setObject:paramters forKey:kTaobaoGrantInfo];
//            [userDefault setObject:[kvPairs valueForKeyPath:@"mobile_token"] forKey:@"sid"];
            
            [userDefault synchronize];
            
            return YES;
        }
    }
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activity stopAnimating];

    [webView stringByEvaluatingJavaScriptFromString:
            [NSString stringWithFormat:
                    @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
                    (int)webView.frame.size.width]];

    if([self bindSuccess:webView])
    {   
        if ([_delegate respondsToSelector:@selector(TaoBaoGrantFinished)])
            [_delegate TaoBaoGrantFinished];
    } else if ([[[[webView request] URL] path] isEqualToString:@"/authorize.do"])
    {
        
    }
}

- (void)loadWebPageWithString: (NSString *)urlString
{
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webV loadRequest:request];
}
- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
