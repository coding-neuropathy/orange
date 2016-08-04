//
//  GKDiscover.h
//  orange
//
//  Created by 谢家欣 on 16/8/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseData.h"

@interface GKDiscover : GKBaseData

@property (strong, nonatomic) NSArray * banners;
@property (strong, nonatomic) NSArray * categories;
@property (strong, nonatomic) NSArray * articles;
@property (strong, nonatomic) NSArray * entities;
@property (strong, nonatomic) NSArray * users;

@property (readonly, getter=bannerCount) NSInteger bannerCount;
@property (readonly, getter=categoryCount) NSInteger categoryCount;
@property (readonly, getter=userCount) NSInteger userCount;
@property (readonly, getter=entityCount) NSInteger entityCount;
@property (readonly, getter=articleCount) NSInteger articleCount;

@end
