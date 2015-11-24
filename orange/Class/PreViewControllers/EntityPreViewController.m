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
            self.entity.liked = liked;
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"喜爱失败"];
        }];
    }];
    return @[action];
}


@end
