//
//  GKWebVC.h
//  Blueberry
//
//  Created by huiter on 13-10-16.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "BaseViewController.h"

@interface GKWebVC : BaseViewController
<UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSURL * link;
@property (nonatomic, strong) UIWebView *webView;
+ (GKWebVC *)linksWebViewControllerWithURL:(NSURL *)url;
@end
