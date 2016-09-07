//
//  PaymentCodeController.h
//  orange
//
//  Created by 谢家欣 on 16/9/6.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCodeController : UIViewController

@property (nonatomic, copy) void (^closeAction)();

- (instancetype)initWithOrder:(GKOrder *)order;
- (void)fadeIn;

@end
