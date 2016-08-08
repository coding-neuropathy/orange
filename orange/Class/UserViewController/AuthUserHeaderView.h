//
//  UserHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthUserHeaderView;

@protocol AuthUserHeaderViewDelegate <NSObject>

- (void)TapFriendBtnWithUser:(GKUser *)user;
- (void)TapFansBtnWithUser:(GKUser *)user;

@optional
- (void)TapEditBtnWithUser:(GKUser *)user;
- (void)TapFollowBtnWithUser:(GKUser *)user View:(AuthUserHeaderView *)view;
- (void)TapUnFollowBtnWithUser:(GKUser *)user View:(AuthUserHeaderView *)view;


@end

@interface AuthUserHeaderView : UICollectionReusableView

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) id<AuthUserHeaderViewDelegate> delegate;

@end
