//
//  UserHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
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
