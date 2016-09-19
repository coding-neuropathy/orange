//
//  ShareController.h
//  orange
//
//  Created by 谢家欣 on 16/9/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareController : UIViewController

@property (weak, nonatomic) GKEntity    *entity;

@property (nonatomic, copy) void (^refreshBlock)();


- (instancetype)initWithTitle:(NSString *)title URLString:(NSString *)urlString Image:(UIImage *)image;
- (void)show;

@end
