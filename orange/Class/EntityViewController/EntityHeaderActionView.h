//
//  EntityHeaderActionView.h
//  orange
//
//  Created by 谢家欣 on 15/6/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntityHeaderActionViewDelegate <NSObject>

- (void)handelTapLikeBtn:(id)sender;
- (void)handelTapBuyBtn:(id)sender;

@end

@interface EntityHeaderActionView : UICollectionReusableView

@property (strong, nonatomic) GKEntity * entity;
@property (weak, nonatomic) id<EntityHeaderActionViewDelegate> delegate;

@end
