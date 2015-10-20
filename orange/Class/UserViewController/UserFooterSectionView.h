//
//  UserFooterSectionView.h
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@protocol UserFooterSectionDelete <NSObject>

- (void)TapMoreButtonWithType:(UserPageType)type;

@end

@interface UserFooterSectionView : UICollectionReusableView

//@property (strong, nonatomic) NSString * title;
@property (assign, nonatomic) UserPageType type;
@property (weak, nonatomic) id<UserFooterSectionDelete> delegate;

@end
