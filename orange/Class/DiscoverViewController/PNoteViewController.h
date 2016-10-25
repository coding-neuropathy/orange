//
//  PNoteViewController.h
//  orange
//
//  Created by D_Collin on 15/12/21.
//  Copyright © 2015年 guoku.com. All rights reserved.
//  商品评论模态视图控制器

#import <UIKit/UIKit.h>

@interface PNoteViewController : UIViewController

//商品
@property (strong, nonatomic)GKEntity * entity;
//点评成功的回调
@property (nonatomic, copy) void (^successBlock)(GKNote *);

- (instancetype)initWithEntityNote:(GKNote *)note;

@end
