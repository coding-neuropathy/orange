//
//  CategroyGroupController.h
//  orange
//
//  Created by 谢家欣 on 15/9/16.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  商品显示样式
 */
typedef NS_ENUM(NSInteger, EntityDisplayStyle) {
    ListStyle = 0,
    GridStyle,
};

@interface CategroyGroupController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithGid:(NSInteger)gid;

@end
