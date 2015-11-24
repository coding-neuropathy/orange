//
//  EntityPreViewController.m
//  orange
//
//  Created by 谢家欣 on 15/11/24.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "EntityPreViewController.h"
#import "EntityPreView.h"
#import "LoginView.h"

@interface EntityPreViewController ()

@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) EntityPreView * preView;

@end

@implementation EntityPreViewController

- (instancetype)initWithEntity:(GKEntity *)entity
{
    self = [super init];
    if (self) {
        self.entity = entity;
    }
    return self;
}

- (EntityPreView *)preView
{
    if (!_preView) {
        _preView = [[EntityPreView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
        _preView.entity = self.entity;
        _preView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _preView;
}

- (void)loadView
{
    self.view = self.preView;
}

#pragma mark -
- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if(!k_isLogin)
        {
            LoginView * view = [[LoginView alloc]init];
            [view show];
            return;
        }
        
        [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];
        [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
        
        [API likeEntityWithEntityId:self.entity.entityId isLike:YES success:^(BOOL liked) {
//            if (liked == self.likeButton.selected) {
//                UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
//                image.frame = self.likeButton.imageView.frame;
//                [self.likeButton addSubview:image];
//                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
//                    image.deFrameTop = image.deFrameTop - 10;
//                    image.alpha = 0.1;
//                }completion:^(BOOL finished) {
//                    [image removeFromSuperview];
//                }];
//                ////[SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
//            }
//            
//            
//            self.likeButton.selected = liked;
            self.entity.liked = liked;
//
//            DDLogInfo(@"entity view %d", self.likeButton.selected);
//            
//            
//            if (liked) {
//                self.entity.likeCount += 1;
//                UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
//                image.frame = self.likeButton.imageView.frame;
//                [self.likeButton addSubview:image];
//                
//                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
//                    image.deFrameTop = image.deFrameTop - 10;
//                    image.alpha = 0.1;
//                }completion:^(BOOL finished) {
//                    [image removeFromSuperview];
//                }];
//                
//                if ([Passport sharedInstance].user) {
//                    [self.dataArrayForlikeUser insertObject:[Passport sharedInstance].user atIndex:0];
//                }
                ////[SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
//            } else {
//                [self.dataArrayForlikeUser removeObject:[Passport sharedInstance].user];
//                
//                self.entity.likeCount -= 1;
//                [SVProgressHUD dismiss];
//            }
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:4]];
//            if (btn){
//                btn.selected = self.entity.liked;
//                [btn setTitle:[NSString stringWithFormat:@"%ld", self.entity.likeCount] forState:UIControlStateNormal];
//            }
//            [self setNavBarButton:self.flag];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"喜爱失败"];
        }];
    }];
    return @[action];
}


@end
