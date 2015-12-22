//
//  PNoteViewController.h
//  orange
//
//  Created by D_Collin on 15/12/21.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNoteViewController : UIViewController

//点评
@property (strong, nonatomic)GKNote * note;
//商品
@property (strong, nonatomic)GKEntity * entity;
//点评成功的回调
@property (nonatomic, copy) void (^successBlock)(GKNote *);

@end
