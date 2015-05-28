//
//  SignInViewController.h
//  orange
//
//  Created by 谢 家欣 on 15/5/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) void (^successBlock)();

- (instancetype)initWithSuccessBlock:(void (^)())block;
- (void)showViewWithAnimation:(BOOL)animated;
- (void)dismissViewWithAnimation:(BOOL)animated;
@end
