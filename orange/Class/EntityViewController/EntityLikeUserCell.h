//
//  EntityLikeUserCell.h
//  orange
//
//  Created by 谢家欣 on 15/6/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntityLikeUserCellDelegate <NSObject>

@optional
- (void)handleGotoEntityLikeListBtn:(id)sender;

@end


@interface EntityLikeUserCell : UICollectionViewCell

@property (strong, nonatomic) GKUser    *user;
@property (strong, nonatomic) NSArray   *likeUsers;

@property (weak, nonatomic) id<EntityLikeUserCellDelegate> delegate;

- (void)setLikeUsers:(NSArray *)likeUsers WithLikeCount:(NSInteger)likecount;

@end
