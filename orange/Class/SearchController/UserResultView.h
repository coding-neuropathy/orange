//
//  UserResultView.h
//  orange
//
//  Created by D_Collin on 16/7/12.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserResultView : UICollectionReusableView

/** 用户数组 */
@property (nonatomic , strong) NSArray * users;

/** 用户头像点击事件 */
@property (nonatomic , copy) void (^tapUsersBlock)(GKUser * user);

@property (nonatomic , copy)void (^tapMoreUsersBlock)();


@end
