//
//  UserResultCell.h
//  orange
//
//  Created by D_Collin on 16/7/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserResultCell : UICollectionViewCell

@property (strong, nonatomic) GKUser * user;

@property (copy, nonatomic) void (^tapRelationAction)(UIAlertController * alertController);

@end