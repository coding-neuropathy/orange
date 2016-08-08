//
//  AuthUserViewController.h
//  orange
//
//  Created by D_Collin on 16/2/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

@interface AuthUserViewController : BaseViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)GKUser * user;

- (instancetype)initWithUser:(GKUser *)user;

@end
