//
//  ArticleWebViewController.m
//  orange
//
//  Created by D_Collin on 16/3/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticleWebViewController.h"
#import "WXApi.h"

#import <WebKit/WebKit.h>
#import "WebViewProgressView.h"
#import "SDWebImageDownloader.h"
#import "EntityViewController.h"

#import "ShareView.h"
#import "LoginView.h"

@interface ArticleWebViewController ()<WKNavigationDelegate , WKUIDelegate>{
    UIBarButtonItem *_moreButton;
    UIBarButtonItem *_digButton;
}

//是否是外链
@property (nonatomic , assign)int linkCount;

@property (nonatomic , strong)WebViewProgressView * progressView;
@property (nonatomic , strong)UIImage * image;
@property (nonatomic , strong)UIButton * digBtn;
@property (nonatomic , strong)UIButton * moreBtn;
@property (nonatomic , strong)UILabel * label;

@end

@implementation ArticleWebViewController

- (instancetype)initWithArticle:(GKArticle *)article
{
    if (self) {
        self.article = article;
        self.url = self.article.articleURL;
    }
    return self;
}

#pragma mark - UI
- (UIButton *)digBtn
{
    if (!_digBtn) {
        _digBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _digBtn.frame = CGRectMake(0., 0., 32, 44);
        _digBtn.tintColor = UIColorFromRGB(0xffffff);
        [_digBtn setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
        [_digBtn setImage:[UIImage imageNamed:@"thumbed"] forState:UIControlStateSelected];
        [_digBtn addTarget:self action:@selector(digBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_digBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.)];
        _digBtn.backgroundColor = [UIColor clearColor];
        if (self.article.IsDig) {
            _digBtn.selected = YES;
        }
    }
    return _digBtn;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.webView addSubview:self.label];
    _linkCount = 1;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchWebView:)];
    
    [self.webView addGestureRecognizer:tap];
    
    NSMutableArray * BtnArray = [NSMutableArray array];
    
    //更多按钮
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
    [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem * moreBarItem = [[UIBarButtonItem alloc]initWithCustomView:_moreBtn];
#warning ...
    _moreButton = moreBarItem;
    [BtnArray addObject:moreBarItem];
    
    //点赞按钮
    
    UIBarButtonItem * likeBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.digBtn];
#warning ...
    _digButton = likeBarItem;
    [BtnArray addObject:likeBarItem];
    [self.navigationItem setRightBarButtonItems:BtnArray animated:YES];
    
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0., 0., 32., 44.);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0., 0., 0., 20.);
    UIBarButtonItem * backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[WebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    self.title = @"正在加载...";
}

- (void)touchWebView:(UITapGestureRecognizer *)tap
{
//    NSLog(@"123123123123");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar addSubview:self.progressView];
    
    //    [AVAnalytics beginLogPageView:@"webView"];
    [MobClick beginLogPageView:@"articleWebView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.progressView removeFromSuperview];
    
    [MobClick endLogPageView:@"articleWebView"];
}

- (void)setDigBtnIsShow:(BOOL)isShow{
    if (isShow) {
        self.navigationItem.rightBarButtonItems = @[_moreButton,_digButton];
    }else{
        self.navigationItem.rightBarButtonItems = @[_moreButton];
    }
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.title = @"正在加载...";
    
    

}

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


#pragma mark - button action
- (void)moreButtonAction:(id)sender
{
    UIImage * image = [UIImage imageNamed:@"wxshare"];
    if (self.image) {
        image = [UIImage imageWithData:[self.image imageDataLessThan_10K]];
    }
    
    
    ShareView * view = [[ShareView alloc]initWithTitle:self.article.title SubTitle:@"" Image:image URL:[self.webView.URL absoluteString]];
    view.type = @"url";
    view.tapRefreshButtonBlock = ^(){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    };
    [view show];
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
            self.title = @"图文";
            [self setDigBtnIsShow:YES];
        }else{
            self.title = result;
            [self setDigBtnIsShow:NO];
        }
    }];

}

- (void)digBtnAction:(UIButton *)btn
{
    //    NSLog(@"OKOKOKOKO");
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    else
    {
        
        [API digArticleWithArticleId:self.article.articleId isDig:!self.digBtn.selected success:^(BOOL IsDig) {
            
            if (IsDig == self.digBtn.selected)
            {
                [SVProgressHUD showImage:nil status:@"点赞成功"];
            }
            self.digBtn.selected = IsDig;
            self.article.IsDig = IsDig;
            
            if (IsDig)
            {
                self.article.dig_count += 1;
                NSLog(@"%ld",self.article.dig_count);
            }
            else
            {
                self.article.dig_count -= 1;
                NSLog(@"%ld",self.article.dig_count);
            }
            if (btn) {
                btn.selected = self.article.IsDig;
            }
            
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"点赞失败"];
        }];
    }
}

//#pragma mark - button action
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  
}



@end