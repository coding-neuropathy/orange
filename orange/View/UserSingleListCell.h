//
//  UserSingleListCell.h
//  orange
//
//  Created by huiter on 15/1/28.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface UserSingleListCell : UITableViewCell<RTLabelDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) GKUser     *user;

/** 认证用户标记 */
@property (nonatomic, strong) UIImageView * staffImageView;
@property (copy, nonatomic) void (^TapAvatarAction)(GKUser *user);


+ (CGFloat)height;

@end
