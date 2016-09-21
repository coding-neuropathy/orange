//
//  ShareController.h
//  orange
//
//  Created by 谢家欣 on 16/9/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@interface ShareController : UIViewController

@property (assign, nonatomic)   ShareType   type;
@property (weak, nonatomic)     GKEntity    *entity;
@property (weak, nonatomic)     GKArticle   *article;

@property (copy, nonatomic) void (^refreshBlock)();
@property (copy, nonatomic) void (^tipOffBlock)();




- (instancetype)initWithTitle:(NSString *)title URLString:(NSString *)urlString Image:(UIImage *)image;
- (void)show;

@end
