//
//  UserLikeCell.h
//  orange
//
//  Created by 谢家欣 on 16/9/9.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLikeCell : UICollectionViewCell

@property (strong, nonatomic) NSArray * entityArray;

@property (nonatomic , copy) void (^tapEntityImageBlock)(GKEntity * entity);

@end
