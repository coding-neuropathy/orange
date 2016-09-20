//
//  ShareView.h
//  orange
//
//  Created by huiter on 15/7/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libWeChatSDK/WXApi.h>
//#import "ReportViewController.h"
#import "DataStructure.h"

@protocol ShareViewDelegate <NSObject>

- (void)handleCancelBtnAction:(id)sender;

@optional
- (void)handleShareOnMomentsAction:(id)sender;
- (void)handleShareToWeChat:(id)sender;
- (void)handleShareToWeibo:(id)sender;
- (void)handleOpenInSafari:(id)sender;
- (void)handleSendMail:(id)sender;
- (void)handlePageRefreshRequest:(id)sender;
- (void)handlerCopyURL:(id)sender;
- (void)handlerTipOff:(id)sender;

@end





@interface ShareView : UIView
//@property (nonatomic, strong) GKEntity * entity;
//@property (nonatomic, strong) NSString * type;
@property (assign, nonatomic) ShareType type;
@property (strong, nonatomic) id<ShareViewDelegate> delegate;

//@property (nonatomic, copy) void (^tapRefreshButtonBlock)();


//- (instancetype)initWithTitle:(NSString *)title SubTitle:(NSString *)subTitle Image:(UIImage *)image URL:(NSString *)url;
//- (void)show;
//- (void)dismiss;


@end
