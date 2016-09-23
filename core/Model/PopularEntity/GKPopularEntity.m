//
//  GKPopularEntity.m
//  orange
//
//  Created by 谢家欣 on 16/9/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKPopularEntity.h"
#import "API.h"

@implementation GKPopularEntity


- (void)refresh
{    
    [super refresh];
    [API getTopTenEntityCount:3 success:^(NSArray *array) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
        
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
    
        
        [self.wormhole passMessageObject:@{
                                           @"data": self.dataArray,
                                           @"timestamp": @(self.timestamp),
                                           } identifier:@"pop-entities"];
    } failure:^(NSInteger stateCode, NSError *error) {
        self.error = error;
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
    }];
}

- (void)getDataFromWomhole
{
    NSDictionary *cacheData  = [self.wormhole messageWithIdentifier:@"pop-entities"];
    
    self.dataArray  = [cacheData valueForKey:@"data"];
    NSTimeInterval cachetime = [[cacheData valueForKey:@"timestamp"] doubleValue];
    
    float expire = self.timestamp - cachetime;
    
    if (self.dataArray.count == 0 || expire > 43200) {
        NSLog(@"cache miss");
        [self refresh];
    } else {
        NSLog(@"cache hit hit %f", expire);
    }
}

@end
