//
//  EntitySKUView.h
//  orange
//
//  Created by 谢家欣 on 16/8/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntitySKUViewDelegate <NSObject>

- (void)TapAddCartWithSKU:(GKEntitySKU *)sku;
- (void)TapSKUTagWithSKU:(GKEntitySKU *)sku;


@end

@interface EntitySKUView : UIScrollView

@property (strong, nonatomic) GKEntity * entity;

@property (weak, nonatomic) id<EntitySKUViewDelegate> SKUDelegate;

@end
