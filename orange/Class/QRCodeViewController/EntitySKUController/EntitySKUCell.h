//
//  EntitySKUCell.h
//  orange
//
//  Created by 谢家欣 on 16/8/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntitySKUCell : UICollectionViewCell

@property (strong, nonatomic) GKEntitySKU     *sku;


+ (CGFloat)cellWidthWithSKU:(GKEntitySKU *)sku;

@end
