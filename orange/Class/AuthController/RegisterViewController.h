//
//  RegisterViewController.h
//  orange
//
//  Created by huiter on 15/12/10.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthController.h"
@interface RegisterViewController : UIViewController
@property(weak,nonatomic) AuthController * authController;
@property (nonatomic, copy) void (^successBlock)();

@end
