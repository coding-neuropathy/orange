//
//  GKHandler.m
//  orange
//
//  Created by 谢家欣 on 16/9/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKHandler.h"

@interface GKHandler ()

@property(nonatomic, strong) id<ALBBItemService> itemService;

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
        self.itemService    = [[ALBBSDK sharedInstance] getService:@protocol(ALBBItemService)];
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
            
            NSNumber  *_itemId = [[[NSNumberFormatter alloc] init] numberFromString:purchase.origin_id];
            ALBBTradeTaokeParams *taoKeParams = [[ALBBTradeTaokeParams alloc] init];
            taoKeParams.pid = kGK_TaobaoKe_PID;
            [_itemService showTaoKeItemDetailByItemId:[UIApplication sharedApplication].keyWindow.rootViewController
                                           isNeedPush:YES
                                    webViewUISettings:nil
                                               itemId:_itemId
                                             itemType:1
                                               params:nil
                                          taoKeParams:taoKeParams
                          tradeProcessSuccessCallback:_tradeProcessSuccessCallback
                           tradeProcessFailedCallback:_tradeProcessFailedCallback];
        } else
            [self showWebViewWithTaobaoUrl:[purchase.buyLink absoluteString]];
        
        [MobClick event:@"purchase" attributes:@{@"entity":entity.title} counter:(int)entity.lowestPrice];
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
    
    [[OpenCenter sharedOpenCenter] openWebWithURL:[NSURL URLWithString:url]];
}
@end
