//
//  LoginViewController.h
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthController.h"


@interface LoginViewController : UIViewController

@property(weak,nonatomic) AuthController * authController;
@property (nonatomic, copy) void (^successBlock)();

@property (copy, nonatomic) void (^signInSuccessBlock)(BOOL finished);


@end
