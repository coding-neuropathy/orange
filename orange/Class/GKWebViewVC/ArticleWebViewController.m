//
//  ArticleWebViewController.m
//  orange
//
//  Created by D_Collin on 16/3/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticleWebViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewProgressView.h"
#import "ShareController.h"

#import "ArticleCommentController.h"

@interface ArticleWebViewController ()<WKNavigationDelegate , WKUIDelegate>
{
    UIBarButtonItem *_moreButton;
    UIBarButtonItem *_digButton;
    UIBarButtonItem *_flexItem;
//    UIBarButtonItem *_digLabelItem;
    UIBarButtonItem *_commentButton;
//    UIBarButtonItem *_commentLabelItem;
}

//是否是外链
@property (nonatomic , assign) int linkCount;

@property (nonatomic , strong) WebViewProgressView * progressView;
@property (nonatomic , strong) UIImage * image;
@property (nonatomic , strong) UIButton * digBtn;
@property (nonatomic , strong) UIButton * more;
@property (nonatomic , strong) UILabel * label;
@property (nonatomic , strong) UIButton * commentBtn;

@property (nonatomic , strong) UIButton * digLabel;
@property (nonatomic , strong) UIButton * commentLabel;

@property (nonatomic , strong) GKArticleComment * comment;

@end

@implementation ArticleWebViewController

- (instancetype)initWithArticle:(GKArticle *)article
{
    if (self) {
        self.article = article;
        self.url = self.article.articleURL;
        
//        DDLogInfo(@"creator %@", self.article.creator);
    }
    return self;
}

#pragma mark - UI
//点赞按钮
- (UIButton *)digBtn
{
    if (!_digBtn) {
        _digBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
//        _digBtn.frame                       = CGRectMake(0., 0., 64., 32.);
        _digBtn.deFrameSize                 = CGSizeMake(64., 32.);
        _digBtn.tintColor = UIColorFromRGB(0xffffff);
        

        [_digBtn setImage:[UIImage imageNamed:@"Poke"] forState:UIControlStateNormal];
        [_digBtn setImage:[UIImage imageNamed:@"Poked"] forState:UIControlStateSelected];
        
        if (self.article.dig_count > 0) {
            [_digBtn setTitle:[NSString stringWithFormat:@"%ld", self.article.dig_count] forState:UIControlStateNormal];
        }else {
            [_digBtn setTitle:NSLocalizedStringFromTable(@"poke", kLocalizedFile, nil) forState:UIControlStateNormal];
        }
        [_digBtn setTitleColor:[UIColor colorFromHexString:@"#757575"] forState:UIControlStateNormal];
        _digBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.];
        
        [_digBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 10)];
        [_digBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 5., 0., 0.)];
        
        [_digBtn addTarget:self action:@selector(digBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_digBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.)];
        _digBtn.backgroundColor = [UIColor clearColor];
        if (self.article.IsDig) {
            _digBtn.selected = YES;
        }
    }
    return _digBtn;
}

//评论按钮
- (UIButton *)commentBtn
{
    if (!_commentBtn) {
        _commentBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
//        _commentBtn.frame = CGRectMake(0., 0., 104., 44.);
        _commentBtn.deFrameSize             = CGSizeMake(104., 44.);
        if (self.article.commentCount > 0) {
            [_commentBtn setTitle:[NSString stringWithFormat:@"%ld", self.article.dig_count] forState:UIControlStateNormal];
        } else {
            [_commentBtn setTitle:NSLocalizedStringFromTable(@"comment", kLocalizedFile, nil) forState:UIControlStateNormal];
        }
        
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
//        [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0., -15, 0., 0.)];
                [_commentBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.];
        
        [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 10)];
        [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 5., 0., 0.)];
        
        [_commentBtn addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.backgroundColor = [UIColor clearColor];
    }
    return _commentBtn;
}


//更多按钮
- (UIButton *)more
{
    if (!_more) {
        _more = [UIButton buttonWithType:UIButtonTypeCustom];
        _more.frame = CGRectMake(0., 0., 32., 44.);
        [_more setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        _more.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_more addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _more.backgroundColor = [UIColor clearColor];
        
    }
    return _more;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self creatBottomBar];
    
    [self.webView addSubview:self.label];
    _linkCount = 1;
    
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[WebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [MobClick beginLogPageView:@"articleWebView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [self.progressView removeFromSuperview];
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
    
    [MobClick endLogPageView:@"articleWebView"];
    
    [super viewWillDisappear:animated];
}

- (void)setDigBtnIsShow:(BOOL)isShow{
    if (isShow) {
        self.toolbarItems = @[_digButton, _commentButton, _flexItem, _moreButton];
//        self.navigationItem.rightBarButtonItems = @[_moreButton,_digButton];
    }else{
        self.toolbarItems = @[_flexItem,_flexItem,_flexItem,_flexItem,_flexItem,_moreButton];
    }
}

#pragma mark - <WKNavigationDelegate>
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    self.title = NSLocalizedStringFromTable(@"load", kLocalizedFile, nil);
//}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    /**
     *  disable wkwebview zoom
     */
    
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    
    [webView evaluateJavaScript:javascript completionHandler:nil];
    
    
//    [webView evaluateJavaScript:javascript completionHandler:^(id _Nullable object, NSError * _Nullable error) {
//        
//    }];
}

//决定是否允许导航响应，如果不允许就不会跳转到该链接的页面
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"guoku://user/"]) {
        
        NSString *parten = @"^guoku://user/(\\d+)/?";
        NSError * error;
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten
                                                                             options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [reg firstMatchInString:navigationAction.request.URL.absoluteString options:0. range:NSMakeRange(0., [navigationAction.request.URL.absoluteString length])];
        if (match) {
        
            NSRange firstHalfRange = [match rangeAtIndex:1];
//            DDLogInfo(@"first %@", [self.text substringWithRange:firstHalfRange]);
            NSString * userId = [navigationAction.request.URL.absoluteString substringWithRange:firstHalfRange];
            if (self.article.creator.userId == [userId integerValue]) {
                [[OpenCenter sharedOpenCenter] openAuthUser:self.article.creator];
            } else {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            }
        }
    }
//    else if ([navigationAction.request.URL.absoluteString hasPrefix:@"guoku://article"]) {
//        
//    
//    }
    else if ([navigationAction.request.URL.absoluteString hasPrefix:@"guoku"]) {
        NSURL *url = navigationAction.request.URL;
        
        //        UIApplication *app = [UIApplication sharedApplication];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
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
    //    NSString * imageURL = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[1].src"];
    //    UIImageView * a = [[UIImageView alloc]init];
    //    [a sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        self.image = image;
    //    }];
    
    [webView evaluateJavaScript:@"document.getElementById('share_img').getElementsByTagName('img')[0].src" completionHandler:^(NSString * imageURL, NSError * error) {
   
        if (imageURL) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished) {
                    self.image = image;
                }
            }];
            
            [self showNavBarMessage];
        }
        else{
            
            [webView evaluateJavaScript:@"document.getElementsByTagName('img')[1].src" completionHandler:^(NSString * imageURL, NSError * error) {
                
                _linkCount ++;
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (finished) {
                        self.image = image;
                    }
                }];
                
                [self showNavBarMessage];
                
            }];
        }
    }];
  
}

- (void)showNavBarMessage{
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *result, NSError *error) {
        
        if (_linkCount == 1) {
            self.title = NSLocalizedStringFromTable(@"article", kLocalizedFile, nil);
            [self setDigBtnIsShow:YES];
        }else{
            self.title = result;
            [self setDigBtnIsShow:NO];
        }
    }];

}


#pragma mark - action
- (void)digAction
{
    [API digArticleWithArticleId:self.article.articleId isDig:!self.digBtn.selected success:^(BOOL IsDig) {
        
        self.article.dig_count = IsDig ? ++self.article.dig_count : --self.article.dig_count;
        self.digBtn.selected = IsDig;
        self.article.IsDig = IsDig;
        
        if (self.article.dig_count > 0) {
            [_digBtn setTitle:[NSString stringWithFormat:@"%ld", self.article.dig_count] forState:UIControlStateNormal];
        }else {
            [_digBtn setTitle:NSLocalizedStringFromTable(@"poke", kLocalizedFile, nil) forState:UIControlStateNormal];
        }
        
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"dig-failure", kLocalizedFile, nil)];
    }];
}

- (void)openArticleComment
{
    ArticleCommentController * vc = [[ArticleCommentController alloc] init];
    vc.article = self.article;
    vc.comment = self.comment;
    
    vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - button action
- (void)digBtnAction:(UIButton *)btn
{
    
    self.digBtn = btn;

    if(!k_isLogin)
    {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self digAction];
        }];
    }
    else
    {
        [self digAction];
    }
    [MobClick event:@"article_dig" attributes:@{@"article": self.article.title} counter:(int)self.article.dig_count];
}

//#pragma mark - button action
- (void)moreButtonAction:(id)sender
{
    UIImage * image = [UIImage imageNamed:@"wxshare"];
    if (self.image) {
        image = [UIImage imageWithData:[self.image imageDataLessThan_10K]];
    }
    
    ShareController *shareVC = [[ShareController alloc] initWithTitle:self.article.title URLString:self.webView.URL.absoluteString Image:image];
    shareVC.type    = ArticleType;
    shareVC.article = self.article;
    shareVC.refreshBlock    = ^(){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    };
    [shareVC show];
}

- (void)commentButtonAction:(id)sender
{
#warning open article comment
    if(!k_isLogin)
    {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self openArticleComment];
        }];
    }
    else
    {
        [self openArticleComment];
    }
}

- (void)backAction:(id)sender
{
    if([self.webView canGoBack]) {
        [self.webView goBack];
        _linkCount --;
        [self showNavBarMessage];
    } else {
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//  
//}

#pragma mark ---------- create Bottom Bar -------------

- (void)creatBottomBar
{
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:self.more];
    _moreButton = moreItem;
    
    UIBarButtonItem * digItem = [[UIBarButtonItem alloc]initWithCustomView:self.digBtn];
    _digButton = digItem;
    
//    UIBarButtonItem * digLabelItem = [[UIBarButtonItem alloc]initWithCustomView:self.digLabel];
//    _digLabelItem = digLabelItem;
    
    UIBarButtonItem * commentItem = [[UIBarButtonItem alloc]initWithCustomView:self.commentBtn];
    _commentButton = commentItem;

    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _flexItem = flexItem;
    
    self.toolbarItems   = @[digItem, commentItem, flexItem, moreItem];
}

@end
