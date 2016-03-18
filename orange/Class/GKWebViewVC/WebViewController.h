//
//  WebViewController.h
//  orange
//
//  Created by 谢家欣 on 15/5/17.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView * webView;
@property (strong, nonatomic) NSURL * url;

- (instancetype)initWithURL:(NSURL *)url;

@end
