//
//  EntityPreViewController.m
//  orange
//
//  Created by 谢家欣 on 15/11/24.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "EntityPreViewController.h"
#import "EntityPreView.h"
//#import "LoginView.h"

#import "WebViewController.h"
@interface EntityPreViewController ()

@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) EntityPreView * preView;
@property (weak, nonatomic) UIImage * preImage;

//@property(nonatomic, strong) id<ALBBItemService> itemService;

@property (strong, nonatomic) NSString * seller_id;


@end

@implementation EntityPreViewController
//{
//    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
//    tradeProcessFailedCallback _tradeProcessFailedCallback;
//}

- (instancetype)initWithEntity:(GKEntity *)entity
{
    self = [self initWithEntity:entity PreImage:nil];
//    if (self) {
//        self.entity     = entity;
//    }
    return self;
}

- (instancetype)initWithEntity:(GKEntity *)entity PreImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.entity     = entity;
        self.preImage   = image;
    
    }
    return self;
}


- (EntityPreView *)preView
{
    if (!_preView) {
        _preView = [[EntityPreView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        _preView.preImage           = self.preImage;
        _preView.entity             = self.entity;
        _preView.backgroundColor    = [UIColor colorFromHexString:@"#f1f1f1"];
    }
    return _preView;
}

- (void)loadView
{
    self.view = self.preView;
}

#pragma mark - action
- (void)likeAction
{
    [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
    
    [API likeEntityWithEntityId:self.entity.entityId isLike:YES success:^(BOOL liked) {
        self.entity.liked = liked;
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"like failure", kLocalizedFile, nil)];
    }];
}

#pragma mark -
- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (!k_isLogin)
        {
            [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
                [self likeAction];
            }];
        } else {
            [self likeAction];
        }
        
//        [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];

    }];
    
    
#pragma mark --------------- 点击跳转至购买页 ---------------------
    UIPreviewAction * action2 = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"buy", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        //code signing
    
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            
            
            if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"]) {
                self.baichuanblock(purchase);
            }
            else{
                
                [self showWebViewWithTaobaoUrl:[purchase.buyLink absoluteString] ];
            }
//            [AVAnalytics event:@"buy action" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.lowestPrice];
//            [MobClick event:@"purchase" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.lowestPrice];

        }
        
    }];
    
    return @[action,action2];
}

- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url
{
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    NSString * TTID = [NSString stringWithFormat:@"%@_%@",kTTID_IPHONE,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sid = @"";
    taobao_url = [taobao_url stringByReplacingOccurrencesOfString:@"&type=mobile" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@&sche=com.guoku.iphone&ttid=%@&sid=%@&type=mobile&outer_code=IPE",taobao_url, TTID,sid];
    GKUser *user = [Passport sharedInstance].user;
    if(user)
    {
        url = [NSString stringWithFormat:@"%@%lu",url,user.userId];
    }

    WebViewController *webVC =[[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    webVC.title = @"宝贝详情";
    webVC.hidesBottomBarWhenPushed = YES;
    
    if(self.backblock){
        self.backblock(webVC);
    }

}


@end
