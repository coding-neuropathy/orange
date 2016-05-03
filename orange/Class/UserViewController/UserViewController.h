//
//  UserViewController.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@interface UserViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) GKUser * user;

- (instancetype)initWithUser:(GKUser *)user;

@end
