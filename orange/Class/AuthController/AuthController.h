//
//  AuthController.h
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AuthController : BaseViewController

@property (copy, nonatomic) void (^successBlock)();

- (void)setSelectedWithType:(NSString *)type;


@end
