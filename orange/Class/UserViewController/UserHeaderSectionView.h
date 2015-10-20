//
//  UserHeaderSectionView.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@protocol UserHeaderSectionViewDelegate <NSObject>

@optional
- (void)TapHeaderViewWithType:(UserPageType)type;

@end

@interface UserHeaderSectionView : UICollectionReusableView

@property (weak, nonatomic) id<UserHeaderSectionViewDelegate> delegate;
- (void)setUser:(GKUser *)user WithType:(UserPageType)type;

@end
