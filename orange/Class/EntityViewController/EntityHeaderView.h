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

@end

@interface EntityHeaderView : UICollectionReusableView

@property (nonatomic, strong) GKEntity *entity;
@property (weak, nonatomic) id<EntityHeaderViewDelegate> delegate;
@property (weak, nonatomic) id<GKViewDelegate> actionDelegate;

+ (CGFloat)headerViewHightWithEntity:(GKEntity *)entity;

@end
