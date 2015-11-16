//
//  PreviewArticleController.m
//  orange
//
//  Created by 谢家欣 on 15/11/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "PreviewArticleController.h"

@interface PreviewArticleController ()

@property (strong, nonatomic) GKArticle * article;
@property (strong, nonatomic) UIImageView * showImageView;

@end

@implementation PreviewArticleController

- (instancetype)initWIthArticle:(GKArticle *)article
{
    self = [super init];
    if (self) {
        self.article = article;
    }
    return self;
    
}

- (UIImageView *)showImageView
{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenWidth / 1.8)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.showImageView sd_setImageWithURL:_article.coverURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(kScreenWidth -32, (kScreenWidth - 32) / 1.8)]];
        
    }
    return _showImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.showImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:@"赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    return @[action];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
