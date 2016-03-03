//
//  ArticlePreViewController.m
//  orange
//
//  Created by 谢家欣 on 16/2/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticlePreViewController.h"
#import <WebKit/WebKit.h>

#import "WXApi.h"

@interface ArticlePreViewController () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) GKArticle * article;
@property (strong, nonatomic) WKWebView * webView;
@property (strong, nonatomic) UIImage * image;

@end

@implementation ArticlePreViewController

- (id)initWithArticle:(GKArticle *)article
{
    self = [super init];
    if (self) {
        self.article = article;
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
        
        // Create the user content controller and add the script to it
        WKUserContentController *userContentController = [WKUserContentController new];
        [userContentController addUserScript:script];
        
        // Create the configuration with the user content controller
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) configuration:configuration];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView sizeToFit];
    }
    return _webView;
}

- (void)loadView
{
    self.view = self.webView;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.article.articleURL]];
}

- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to wechat", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self wxShare:0];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to moment", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self wxShare:1];
    }];

    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to weibo", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self weiboShare];
    }];
    
    return @[action, action2, action3];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //    NSLog(@"%@", navigationAction.request.URL.absoluteString);
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
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:self.article.coverURL options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            self.image = image;
        }
    }];
//    [webView evaluateJavaScript:@"document.getElementById('share_img').getElementsByTagName('img')[0].src" completionHandler:^(NSString * imageURL, NSError * error) {
//        
//        if (imageURL) {
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                if (finished) {
//                    self.image = image;
//                }
//            }];
//        }
//        else{
//            
//            [webView evaluateJavaScript:@"document.getElementsByTagName('img')[1].src" completionHandler:^(NSString * imageURL, NSError * error) {
//                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                    
//                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                    if (finished) {
//                        self.image = image;
//                    }
//                }];
//                
//            }];
//        }
//        
//    }];
    
    
    
//    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *result, NSError *error) {
//        self.title = result;
//    }];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - share to sns
-(void)weiboShare
{
    WBMessageObject *message = [WBMessageObject message];
    //    message.text = self.title;
    WBImageObject *image = [WBImageObject object];
    message.text = [NSString stringWithFormat:@"%@ %@?from=weibo", self.article.title, self.webView.URL];
    image.imageData = UIImageJPEGRepresentation(self.image, 1.0);
    message.imageObject = image;
    
    
    //    WBWebpageObject *webpage = [WBWebpageObject object];
    //    webpage.objectID = [self.title md5];
    //    webpage.title = self.title;
    ////    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
    ////    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
    //    webpage.thumbnailData = UIImageJPEGRepresentation(self.image, 0.5);
    //    webpage.webpageUrl = [self.url stringByAppendingString:@"?from=weibo"];
    //
    //    message.mediaObject = webpage;
    
    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kGK_WeiboRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];

//    if([AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo ])
//    {
//        [AVOSCloudSNS refreshToken:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
//            [AVOSCloudSNS shareText:self.article.title andLink:[self.webView.URL absoluteString] andImage:self.image toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
//
//            } andProgress:^(float percent) {
//                if (percent == 1) {
//                    [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
//                }
//            }];
//        }];
//    }
//    else
//    {
//        [AVOSCloudSNS shareText:self.article.title andLink:[self.webView.URL absoluteString] andImage:self.image toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
//
//        } andProgress:^(float percent) {
//            if (percent == 1) {
//                [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
//            }
//        }];
//    }
}

-(void)wxShare:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.article.title;
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
