//
//  GKSelectionEntity.h
//  orange
//
//  Created by 谢家欣 on 16/3/28.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseData.h"

@interface GKSelectionEntity : GKBaseData<NSCoding>

@property (assign, nonatomic) NSInteger categoryId;



- (void)refreshWithCategoryId:(NSInteger)cateId;
- (void)loadWithCategoryId:(NSInteger)cateId;

@end
