//
//  GKHandler.h
//  orange
//
//  Created by 谢家欣 on 16/9/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKViewDelegate.h"

@interface GKHandler : NSObject <GKViewDelegate>


DEFINE_SINGLETON_FOR_HEADER(GKHandler);

- (void)TapLikeButtonWithEntity:(GKEntity *)entity Button:(UIButton *)button;

- (void)TapBuyButtonActionWithEntity:(GKEntity *)entity;

- (void)tapStoreButtonWithEntity:(GKEntity *)entity;

@end
