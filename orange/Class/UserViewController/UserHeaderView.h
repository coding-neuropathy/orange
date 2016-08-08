//
//  UserHeaderView.h
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserHeaderView;

@protocol UserHeaderViewDelegate <NSObject>

- (void)TapFriendBtnWithUser:(GKUser *)user;
- (void)TapFansBtnWithUser:(GKUser *)user;

@optional

- (void)TapEditBtnWithUser:(GKUser *)user;
- (void)TapFollowBtnWithUser:(GKUser *)user View:(UserHeaderView *)view;
- (void)TapUnFollowBtnWithUser:(GKUser *)user View:(UserHeaderView *)view;


@end

@interface UserHeaderView : UICollectionReusableView

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) id<UserHeaderViewDelegate> delegate;

@end
