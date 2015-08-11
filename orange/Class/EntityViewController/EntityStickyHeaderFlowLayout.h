//
//  EntityStickyHeaderFlowLayout.h
//  orange
//
//  Created by 谢家欣 on 15/8/9.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const EntityStickyHeaderParallaxHeader;

@interface EntityStickyHeaderFlowLayout : UICollectionViewFlowLayout

//@property (nonatomic) CGSize parallaxHeaderReferenceSize;
//@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
//@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
@property (nonatomic) BOOL disableStickyHeaders;

@end
