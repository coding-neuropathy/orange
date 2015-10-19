//
//  UserHeaderSectionView.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@interface UserHeaderSectionView : UICollectionReusableView

- (void)setUser:(GKUser *)user WithType:(UserPageType)type;

@end
