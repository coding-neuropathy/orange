//
//  GKHandler.m
//  orange
//
//  Created by 谢家欣 on 16/9/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKHandler.h"



@implementation GKHandler

DEFINE_SINGLETON_FOR_CLASS(GKHandler);

#pragma mark - <GKViewDelegate>
- (void)TapEntityImage:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
}

- (void)TapLikeButtonWithEntity:(GKEntity *)entity Button:(UIButton *)button
{
//    DDLogInfo(@"tap action");
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

@end
