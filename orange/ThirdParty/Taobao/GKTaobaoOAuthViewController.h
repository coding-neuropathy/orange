//
//  GKTaobaoOAuthViewController.h
//  Catpower
//
//  Created by 梁 玮殷 on 3/12/12.
//  Copyright (c) 2012 QIN Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKTaobaoConfig.h"

@protocol GKTaobaoOAuthViewControllerDelegate <NSObject>
@optional
- (void)TaoBaoGrantFinished;
@end

@interface GKTaobaoOAuthViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, weak) id <GKTaobaoOAuthViewControllerDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView * activity;

+ (id)taobaoOAuthViewController;
+(void)clean;

@end
