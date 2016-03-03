//
//  EntityLikerController.h
//  orange
//
//  Created by 谢家欣 on 15/6/10.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EntityLikerController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithEntity:(GKEntity *)entity;

@end
