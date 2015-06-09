//
//  EntityCell.h
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EntityCellDelegate <NSObject>

@optional
- (void)TapImageWithEntity:(GKEntity *)entity;

@end


@interface EntityCell : UICollectionViewCell

@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) id<EntityCellDelegate> delegate;

@end
