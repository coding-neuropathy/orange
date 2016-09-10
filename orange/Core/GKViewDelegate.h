//
//  GKViewDelegate.h
//  orange
//
//  Created by 谢家欣 on 16/9/10.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#ifndef GKViewDelegate_h
#define GKViewDelegate_h

@protocol GKViewDelegate <NSObject>

@optional
/**
 *  handle tap entity image
 *
 *  @param entity GKEntity Objecit
 */
- (void)TapEntityImage:(GKEntity *)entity;

- (void)TapLikeButtonWithEntity:(GKEntity *)entity Button:(UIButton *)button;

@end

#endif /* GKViewDelegate_h */
