//
//  BaseViewController.h
//  orange
//
//  Created by huiter on 15/1/27.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (weak, nonatomic) UIApplication * app;

- (void)setWhiteBackBtn;
- (void)setDefaultBackBtn;

@end
