//
//  ArticlePreViewController.m
//  orange
//
//  Created by 谢家欣 on 16/2/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticlePreViewController.h"
//#import <WebKit/WebKit.h>
#import <libWeChatSDK/WXApi.h>
#import "ArticlePreView.h"

@interface ArticlePreViewController ()

@property (strong, nonatomic) GKArticle * article;
@property (strong, nonatomic) ArticlePreView * articlePreView;
@property (strong, nonatomic) UIImage * image;

@end

@implementation ArticlePreViewController

- (id)initWithArticle:(GKArticle *)article
{
    self = [super init];
    if (self) {
        self.article = article;
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:self.article.coverURL options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            self.image = image;
        }];
    }
    return self;
}

- (ArticlePreView *)articlePreView
{
    if (!_articlePreView) {
        _articlePreView             = [[ArticlePreView alloc] initWithFrame:CGRectZero];
//        _articlePreView.deFrameSize = CGSizeMake(self.view.deFrameWidth, self.view.deFrameHeight);
        _articlePreView.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        
    }
    return _articlePreView;
}

- (void)loadView
{
//    self.view                   = self.articlePreView;
//    self.view.backgroundColor   = [UIColor colorFromHexString:@"#ffffff"];
    [super loadView];
    
    [self.view addSubview:self.articlePreView];
    self.articlePreView.deFrameSize = CGSizeMake(self.view.deFrameWidth, self.view.deFrameHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:self.article.articleURL]];
    self.articlePreView.article = self.article;
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


#pragma mark - share to sns
-(void)weiboShare
{
    WBMessageObject *message = [WBMessageObject message];
    //    message.text = self.title;
    WBImageObject *image = [WBImageObject object];
    message.text = [NSString stringWithFormat:@"%@ %@?from=weibo", self.article.title, self.article.articleURL];
    image.imageData = UIImageJPEGRepresentation(self.image, 1.0);
    message.imageObject = image;
    
    
    
    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kGK_WeiboRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];

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
    ext.url = [self.article.articleURL absoluteString];

    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;

    [WXApi sendReq:req];
}

@end
