//
//  EntityHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/3/12.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntityHeaderViewDelegate <NSObject>

- (void)handelTapImageWithIndex:(NSUInteger)idx;

@optional
- (void)handleGotoEntityLikeListBtn:(id)sender;

@end

@interface EntityHeaderView : UICollectionReusableView

@property (nonatomic, strong) GKEntity *entity;
@property (weak, nonatomic) id<EntityHeaderViewDelegate> delegate;
@property (weak, nonatomic) id<GKViewDelegate> actionDelegate;

- (void)setEntity:(GKEntity *)entity WithLikeUser:(NSArray *)likeUsers;

+ (CGFloat)headerViewHightWithEntity:(GKEntity *)entity;

@end
