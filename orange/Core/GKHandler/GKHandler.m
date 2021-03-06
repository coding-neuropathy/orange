//
//  GKHandler.m
//  orange
//
//  Created by 谢家欣 on 16/9/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKHandler.h"
#import "WebViewController.h"

@interface GKHandler ()

//@property(nonatomic, strong) id<ALBBItemService> itemService;
//@property   (weak,  nonatomic)  id<AlibcTradeService>   tradeService;

@end

@implementation GKHandler
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

DEFINE_SINGLETON_FOR_CLASS(GKHandler);

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.itemService    = [[ALBBSDK sharedInstance] getService:@protocol(ALBBItemService)];
//        self.tradeService       = [[AlibcTradeSDK sharedInstance] get]
//        self.tradeService       = [[AlibcTradeSDK ]
    }
    return self;
}

- (void)likeActionWith:(GKEntity *)entity Button:(UIButton *)button
{
    [API likeEntityWithEntityId:entity.entityId isLike:!button.selected success:^(BOOL liked) {
        if (liked == button.selected) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
            image.frame = button.imageView.frame;
            [button addSubview:image];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
                image.deFrameTop = image.deFrameTop - 10;
                image.alpha = 0.1;
            }completion:^(BOOL finished) {
                [image removeFromSuperview];
            }];
            
        }
        button.selected = liked;
        entity.liked = liked;
        
        if (liked) {
            
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
            image.frame = button.imageView.frame;
            [button addSubview:image];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
                image.deFrameTop = image.deFrameTop - 10;
                image.alpha = 0.1;
            }completion:^(BOOL finished) {
                [image removeFromSuperview];
            }];
            entity.likeCount = entity.likeCount + 1;
            [MobClick event:@"like_click" attributes:@{@"entity":entity.title} counter:(int)entity.likeCount];
        } else {
            entity.likeCount = entity.likeCount - 1;
            [MobClick event:@"unlike_click" attributes:@{@"entity":entity.title} counter:(int)entity.unlikeCount];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"like failure", kLocalizedFile, nil)];
        
    }];
}

#pragma mark - <GKViewDelegate>
- (void)TapEntityImage:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
}

- (void)TapLikeButtonWithEntity:(GKEntity *)entity Button:(UIButton *)button
{
    if(!k_isLogin)
    {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self likeActionWith:entity Button:button];
        }];
    } else {
        [self likeActionWith:entity Button:button];
    }
}

- (void)TapBuyButtonActionWithEntity:(GKEntity *)entity
{
    if (entity.purchaseArray.count >0) {
        GKPurchase * purchase = entity.purchaseArray[0];
        if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"])
        {
            
            UIViewController    *controller     = [UIApplication sharedApplication].keyWindow.rootViewController;
            id<AlibcTradePage>  page            = [AlibcTradePageFactory itemDetailPage:purchase.origin_id];
            
            AlibcTradeShowParams *showParams    = [[AlibcTradeShowParams alloc] init];
            showParams.openType                 = ALiOpenTypeAuto;
//            showParams.isNeedPush               = YES;
            
            AlibcTradeTaokeParams   *taoKeParams = [[AlibcTradeTaokeParams alloc] init];
            taoKeParams.pid                     = kGK_TaobaoKe_PID;
            
            [UIApplication sharedApplication].statusBarStyle    = UIStatusBarStyleDefault;
            
            [[AlibcTradeSDK sharedInstance].tradeService show:controller
                                                         page:page
                                                   showParams:showParams
                                                  taoKeParams:taoKeParams
                                                   trackParam:nil
                                  tradeProcessSuccessCallback:_tradeProcessSuccessCallback
                                   tradeProcessFailedCallback:_tradeProcessFailedCallback];
            
        } else {
            [self showWebViewWithTaobaoUrl:[purchase.buyLink absoluteString]];
        }
        
        [MobClick event:@"purchase" attributes:@{@"entity":entity.title} counter:(int)entity.lowestPrice];
    }
}

- (void)tapStoreButtonWithEntity:(GKEntity *)entity
{
    if (entity.purchaseArray.count >0) {
        GKPurchase * purchase = entity.purchaseArray[0];
        if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"])
        {
            
            UIViewController    *controller         = [UIApplication sharedApplication].keyWindow.rootViewController;
//            id<AlibcTradePage>  page            = [AlibcTradePageFactory itemDetailPage:purchase.origin_id];
            
            DDLogInfo(@"store id %@", purchase.seller);
            id<AlibcTradePage>  page                = [AlibcTradePageFactory shopPage:purchase.seller];
            
            AlibcTradeShowParams *showParams        = [[AlibcTradeShowParams alloc] init];
            showParams.openType                     = ALiOpenTypeAuto;
            //            showParams.isNeedPush               = YES;
            
            AlibcTradeTaokeParams   *taoKeParams    = [[AlibcTradeTaokeParams alloc] init];
            taoKeParams.pid                         = kGK_TaobaoKe_PID;
            
            [UIApplication sharedApplication].statusBarStyle    = UIStatusBarStyleDefault;
            
            [[AlibcTradeSDK sharedInstance].tradeService show:controller
                                                         page:page
                                                   showParams:showParams
                                                  taoKeParams:taoKeParams
                                                   trackParam:nil
                                  tradeProcessSuccessCallback:_tradeProcessSuccessCallback
                                   tradeProcessFailedCallback:_tradeProcessFailedCallback];
            
//            [MobClick event:@"purchase" attributes:@{@"store":purchase.seller}];
        }
    }
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
        url = [NSString stringWithFormat:@"%@%lu",url,(unsigned long)user.userId];
    }
    
    WebViewController *controller   = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    UINavigationController  *nav    = [[UINavigationController alloc] initWithRootViewController:controller];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
//    [[OpenCenter sharedOpenCenter] openWebWithURL:[NSURL URLWithString:url]];
}
@end
