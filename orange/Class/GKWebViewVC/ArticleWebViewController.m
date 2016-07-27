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

#import "ArticleCommentController.h"

@interface ArticleWebViewController ()<WKNavigationDelegate , WKUIDelegate>
{
    UIBarButtonItem *_moreButton;
    UIBarButtonItem *_digButton;
    UIBarButtonItem *_flexItem;
    UIBarButtonItem *_digLabelItem;
    UIBarButtonItem *_commentButton;
    UIBarButtonItem *_commentLabelItem;
}

//是否是外链
@property (nonatomic , assign)int linkCount;

@property (nonatomic , strong)WebViewProgressView * progressView;
@property (nonatomic , strong)UIImage * image;
@property (nonatomic , strong)UIButton * digBtn;
@property (nonatomic , strong)UIButton * moreBtn;
@property (nonatomic , strong)UILabel * label;
@property (nonatomic , strong)UIButton * commentBtn;

@property (nonatomic , strong)UIButton * digLabel;
@property (nonatomic , strong)UIButton * commentLabel;

@property (nonatomic , strong)GKArticleComment * comment;

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
//点赞按钮
- (UIButton *)digBtn
{
    if (!_digBtn) {
        _digBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _digBtn.frame = CGRectMake(0., 0., 32, 44);
        _digBtn.tintColor = UIColorFromRGB(0xffffff);
        [_digBtn setImage:[UIImage imageNamed:@"Poke"] forState:UIControlStateNormal];
        [_digBtn setImage:[UIImage imageNamed:@"Poked"] forState:UIControlStateSelected];
        [_digBtn addTarget:self action:@selector(digBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_digBtn setImageEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.)];
        _digBtn.backgroundColor = [UIColor clearColor];
        if (self.article.IsDig) {
            _digBtn.selected = YES;
        }
    }
    return _digBtn;
}
//更多按钮
- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(0., 0., 32., 44.);
        [_moreBtn setImage:[UIImage imageNamed:@"more-1"] forState:UIControlStateNormal];
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.backgroundColor = [UIColor clearColor];
        
    }
    return _moreBtn;
}
//点赞字样
- (UIButton *)digLabel
{
    if (!_digLabel) {
        _digLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _digLabel.frame =CGRectMake(0., 0., 20., 44.);
        _digLabel.titleLabel.font = [UIFont systemFontOfSize:12.];
        [_digLabel setTitle:NSLocalizedStringFromTable(@"poke", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_digLabel setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        [_digLabel setTitleEdgeInsets:UIEdgeInsetsMake(0., -15., 0., 0.)];
        _digLabel.backgroundColor = [UIColor clearColor];
    }
    return _digLabel;
}

//评论按钮
- (UIButton *)commentBtn
{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(0., 0., 32., 44.);
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0., -15, 0., 0.)];
        [_commentBtn addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.backgroundColor = [UIColor clearColor];
    }
    return _commentBtn;
}

//评论字样
- (UIButton *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentLabel.frame =CGRectMake(0., 0., 37., 44.);
        _commentLabel.titleLabel.font = [UIFont systemFontOfSize:12.];
        [_commentLabel setTitle:NSLocalizedStringFromTable(@"comment", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_commentLabel setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        [_commentLabel setTitleEdgeInsets:UIEdgeInsetsMake(0., -20., 0., 0.)];
        _commentLabel.backgroundColor = [UIColor clearColor];
    }
    return _commentLabel;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self creatBottomBar];
    
    [self.webView addSubview:self.label];
    _linkCount = 1;

    
//    //更多按钮
//    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
//    [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
//    _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _moreBtn.backgroundColor = [UIColor clearColor];
//    UIBarButtonItem * moreBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
//    _moreButton = moreBarItem;
//    [BtnArray addObject:moreBarItem];
    
    //点赞按钮
    
//    UIBarButtonItem * likeBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.digBtn];
//    _digButton = likeBarItem;
//    [BtnArray addObject:likeBarItem];
//    [self.navigationItem setRightBarButtonItems:BtnArray animated:YES];
    
    
    //返回按钮
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"back-1.png"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0., 0., 32., 44.);
////    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0., 0., 0., 20.);
//    UIBarButtonItem * backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[WebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
//    self.title = @"正在加载...";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if(IS_IPAD) self.tabBarController.tabBar.translucent = YES;
    //    [self.navigationController.navigationBar addSubview:self.progressView];
    //    [AVAnalytics beginLogPageView:@"webView"];
    [MobClick beginLogPageView:@"articleWebView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.progressView removeFromSuperview];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [MobClick endLogPageView:@"articleWebView"];
#warning hidden tabbar in ipad
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
}

- (void)setDigBtnIsShow:(BOOL)isShow{
    if (isShow) {
        self.toolbarItems = @[_digButton,_digLabelItem,_commentButton,_commentLabelItem,_flexItem,_moreButton];
//        self.navigationItem.rightBarButtonItems = @[_moreButton,_digButton];
    }else{
        self.toolbarItems = @[_flexItem,_flexItem,_flexItem,_flexItem,_flexItem,_moreButton];
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

- (void)commentButtonAction:(id)sender
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    else
    {
    
    ArticleCommentController * vc = [[ArticleCommentController alloc]init];
    
    vc.article = self.article;
    
    vc.comment = self.comment;
    
    vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [vc setCommentSuccessBlock:^(GKArticleComment *comment) {
       
        self.comment = comment;
        
        [self.webView reload];
        
    }];
    
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

    [self presentViewController:vc animated:YES completion:nil];
        
    }
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

- (void)digBtnAction:(UIButton *)btn
{
    
    [MobClick event:@"article_dig" attributes:@{@"article": self.article.title} counter:(int)self.article.dig_count];

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
            }
            else
            {
                self.article.dig_count -= 1;
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

#pragma mark ---------- create Bottom Bar -------------

- (void)creatBottomBar
{
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
    _moreButton = moreItem;
    
    UIBarButtonItem * digItem = [[UIBarButtonItem alloc]initWithCustomView:self.digBtn];
    _digButton = digItem;
    
    UIBarButtonItem * digLabelItem = [[UIBarButtonItem alloc]initWithCustomView:self.digLabel];
    _digLabelItem = digLabelItem;
    
    UIBarButtonItem * commentItem = [[UIBarButtonItem alloc]initWithCustomView:self.commentBtn];
    _commentButton = commentItem;
    
    UIBarButtonItem * commentLabelItem = [[UIBarButtonItem alloc]initWithCustomView:self.commentLabel];
    _commentLabelItem = commentLabelItem;
    

    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _flexItem = flexItem;
    [self setToolbarItems:[NSArray arrayWithObjects:digItem,digLabelItem,commentItem,commentLabelItem,flexItem,moreItem,nil]];
}

@end