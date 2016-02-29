//
//  UserSingleListCell.h
//  orange
//
//  Created by huiter on 15/1/28.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface UserSingleListCell : UITableViewCell<RTLabelDelegate,UIAlertViewDelegate>
@property(strong, nonatomic) GKUser * user;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIView *H;
/** 认证用户标记 */
@property (nonatomic, strong) UIImageView * staffImageView;

+ (CGFloat)height;
@end
