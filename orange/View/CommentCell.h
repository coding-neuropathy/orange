//
//  CommentCell.h
//  orange
//
//  Created by huiter on 15/2/1.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface CommentCell : UITableViewCell<RTLabelDelegate>
@property (nonatomic, strong) UIView *H;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) GKComment *comment;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, copy) void (^tapReplyButtonBlock)(GKComment *);
+ (CGFloat)height:(GKComment *)comment;

@end
