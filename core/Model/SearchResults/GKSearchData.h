//
//  GKSearchData.h
//  orange
//
//  Created by 谢家欣 on 16/8/2.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseData.h"

@interface GKSearchData : GKBaseData

@property (strong, nonatomic) NSString * keyword;

@property (readonly, getter=entityCount) NSInteger entityCount;
@property (readonly, getter=articleCount) NSInteger articleCount;
@property (readonly, getter=userCount) NSInteger userCount;



- (void)refreshWithKeyWord:(NSString *)keyword;

- (id)userAtIndex:(NSInteger)index;
- (id)articleAtIndex:(NSInteger)index;
- (id)entityAtIndex:(NSInteger)index;

@end
