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

//@property (assign, nonatomic) BOOL forceTouch;



- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url showHTMLTitle:(BOOL)is_show;

@end
