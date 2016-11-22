//
//  RecUserController.h
//  orange
//
//  Created by D_Collin on 16/2/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@interface RecUserController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) GKUser    *user;

@end
