//
//  EntityHeaderSectionView.h
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EntitySectionType) {
    CategoryHeaderType = 0,
    LikeType,
    NoteType,
    RecommendType,
    ShopType,
};

@protocol EntityHeaderSectionViewDelegate <NSObject>

@optional
- (void)TapHeaderView:(id)sender;

@end

@interface EntityHeaderSectionView : UICollectionReusableView

@property (strong, nonatomic) NSString * text;
@property (assign, nonatomic) EntitySectionType headertype;
@property (weak, nonatomic) id<EntityHeaderSectionViewDelegate> delegate;

@end
