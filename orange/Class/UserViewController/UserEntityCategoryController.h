//
//  UserEntityCategoryController.h
//  orange
//
//  Created by 谢家欣 on 15/10/23.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEntityCategoryController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSInteger currentIndex;
@property (nonatomic, copy) void (^tapBlock)(GKCategory * category);

@end
