//
//  ShareView.h
//  orange
//
//  Created by huiter on 15/7/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <libWeChatSDK/WXApi.h>
//#import "ReportViewController.h"
#import "DataStructure.h"


@protocol ShareViewDelegate, ShareViewDataSource;

@interface ShareView : UIView

@property (assign, nonatomic)   ShareType         type;

@property (weak, nonatomic)     id<ShareViewDataSource> datasource;
@property (weak, nonatomic)     id<ShareViewDelegate>   delegate;

- (void)registerClass:(nullable Class)cellClass;
- (UIView *)dequeueItemViewIndex:(NSInteger)index;

- (void)reloadData;

@end

@protocol ShareViewDelegate <NSObject>

- (void)handleCancelBtnAction:(id)sender;
@optional
- (void)ShareView:(ShareView *)shareview didSelectItemAtIndex:(NSInteger)index;
@end


@protocol ShareViewDataSource <NSObject>

- (NSInteger)numberOfcellInShareView:(ShareView *)shareview;
- (CGFloat)itemSpaceInShareView;
- (CGFloat)shareViewMargin;
- (CGSize)shareView:(ShareView *)shareview sizeForItemAtIndex:(NSInteger)index;

- (UIView *)shareView:(ShareView *)shareview viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@end


