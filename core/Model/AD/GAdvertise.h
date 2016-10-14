//
//  GAdvertise.h
//  orange
//
//  Created by 谢家欣 on 16/10/14.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GAdvertise : GKBaseModel

@property (assign, nonatomic) NSInteger AdvertiseId;
@property (strong, nonatomic) NSURL     *clickURL;
@property (strong, nonatomic) NSURL     *imageURL;

@end
