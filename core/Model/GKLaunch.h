//
//  GKLaunch.h
//  orange
//
//  Created by 谢家欣 on 15/11/22.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKLaunch : GKBaseModel

/**
 *  ID
 */
@property (assign, nonatomic) NSInteger launchId;

/**
 *  title
 */
@property (strong, nonatomic) NSString * title;

/**
 *  description
 */
@property (strong, nonatomic) NSString * desc;

/**
 * launch image
 */
@property (strong, nonatomic) NSURL * launchImageUrl;

@end
