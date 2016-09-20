//
//  ArticlePreViewController.m
//  orange
//
//  Created by 谢家欣 on 16/2/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "ArticlePreViewController.h"
#import "ArticlePreView.h"
#import "ThreePartHandler.h"

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
//        [self wxShare:0];
        [[ThreePartHandler sharedThreePartHandler] wxShare:0 ShareImage:self.image Title:self.article.title URL:[self.article.articleURL absoluteString]];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to moment", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        [self wxShare:1];
        [[ThreePartHandler sharedThreePartHandler] wxShare:1 ShareImage:self.image Title:self.article.title URL:[self.article.articleURL absoluteString]];
    }];

    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"share to weibo", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        [self weiboShare];
//        NSString *shareText =  [NSString stringWithFormat:@"%@ %@?from=weibo", self.article.title, self.article.articleURL];
        [[ThreePartHandler sharedThreePartHandler] weiboShareWithTitle:self.article.title ShareImage:self.image URLString:self.article.articleURL.absoluteString];
    }];
    
    return @[action, action2, action3];
}


@end
