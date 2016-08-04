//
//  GKSearchData.m
//  orange
//
//  Created by 谢家欣 on 16/8/2.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKSearchData.h"
#import "API.h"

@interface GKSearchData ()

@property (strong, nonatomic) NSMutableArray * entityArray;
@property (strong, nonatomic) NSMutableArray * userArray;
@property (strong, nonatomic) NSMutableArray * articleArray;

@end

@implementation GKSearchData

//- (void)setKeyword:(NSString *)keyword
//{
//    _keyword = keyword;
//}

- (void)refreshWithKeyWord:(NSString *)keyword
{
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isRefreshing"];
    self.keyword = keyword;
    [API searchWithKeyword:self.keyword Success:^(NSArray *entities, NSArray *articles, NSArray *users) {
        self.entityArray = [NSMutableArray arrayWithArray:entities];
        self.userArray = [NSMutableArray arrayWithArray:users];
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
        
    } failure:^(NSInteger stateCode, NSError * error) {
        
        self.error = error;
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
    }];
}

#pragma mark - get object
- (id)userAtIndex:(NSInteger)index
{
    return [self.userArray objectAtIndex:index];
}

- (id)articleAtIndex:(NSInteger)index
{
    return [self.articleArray objectAtIndex:index];
}

- (id)entityAtIndex:(NSInteger)index
{
    return [self.entityArray objectAtIndex:index];
}

#pragma mark - data count
- (NSInteger)count
{
    NSInteger _count = self.entityArray.count + self.articleArray.count + self.userArray.count;
    
    return _count;
}

- (NSInteger)entityCount
{
    NSInteger _count = [self.entityArray count] > 3 ? 3 : [self.entityArray count];
    return _count;
}

- (NSInteger)articleCount
{
    NSInteger _count = [self.articleArray count] > 3 ? 3 : [self.articleArray count];
    
    return _count;
}

- (NSInteger)userCount
{
    NSInteger _count = [self.userArray count] > 3 ? 3 : [self.userArray count];
    return _count;
}

@end
