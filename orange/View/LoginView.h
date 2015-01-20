//
//  LoginView.h
//  Blueberry
//
//  Created by huiter on 13-10-28.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, copy) void (^successBlock)();

- (void)show;
- (void)dismiss;
@end
