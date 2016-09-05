//
//  ShareView.h
//  orange
//
//  Created by huiter on 15/7/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libWeChatSDK/WXApi.h>
#import "ReportViewController.h"

@interface ShareView : UIView
@property(nonatomic, strong) GKEntity * entity;
@property(nonatomic, strong) NSString * type;
- (instancetype)initWithTitle:(NSString *)title SubTitle:(NSString *)subTitle Image:(UIImage *)image URL:(NSString *)url;
- (void)show;
- (void)dismiss;
@property (nonatomic, copy) void (^tapRefreshButtonBlock)();

@end
