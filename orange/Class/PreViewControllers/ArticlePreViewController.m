//
//  ArticlePreViewController.m
//  orange
//
//  Created by 谢家欣 on 16/2/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticlePreViewController.h"
#import <WebKit/WebKit.h>

@interface ArticlePreViewController ()

@property (strong, nonatomic) GKArticle * article;
@property (strong, nonatomic) WKWebView * webView;
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
//        _webView.UIDelegate = self;
//        _webView.navigationDelegate = self;
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

    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to moment", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];

    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to weibo", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    return @[action, action2, action3];
}

@end
