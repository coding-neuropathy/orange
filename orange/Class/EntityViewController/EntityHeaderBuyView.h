//
//  EntityHeaderBuyView.h
//  orange
//
//  Created by 谢家欣 on 15/8/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntityHeaderBuyViewDelegate <NSObject>

- (void)tapLikeBtn:(id)sender;
- (void)tapPostNoteBtn:(id)sender;
- (void)tapBuyBtn:(id)sender;

@end

@interface EntityHeaderBuyView : UICollectionReusableView
@property (strong, nonatomic) GKNote * note;
@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) UIButton *likeButton;
@property (weak, nonatomic) id<EntityHeaderBuyViewDelegate> delegate;

@end
