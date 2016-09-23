//
//  GKBaseData.m
//  orange
//
//  Created by 谢家欣 on 16/3/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseData.h"
//#import <MMWormhole/MMWormhole.h>

@implementation GKBaseData

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.dataArray  = [NSMutableArray arrayWithCapacity:0];
        self.page = 1;
        self.size = 30;
        self.timestamp = [[NSDate date] timeIntervalSince1970];
        
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
        [self setValue:[NSNumber numberWithInt:NO] forKey:@"isChange"];
    }
    return self;
}

#pragma mark - init data with lazy load
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSInteger)count
{
    return [self.dataArray count];
}

//- (MMWormhole *)wormhole
//{
//    if (!_wormhole) {
//        _wormhole   = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.guoku.iphone"
//                                                           optionalDirectory:@"wormhole"];
//    }
//    return _wormhole;
//}


#pragma mark - data operation
- (void)refresh
{
    self.page = 1;
    self.timestamp = [[NSDate date] timeIntervalSince1970];
    
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isRefreshing"];
}

- (void)load
{

}

#pragma mark - data array
- (NSInteger)indexOfObject:(id)anObject
{
    return [self.dataArray indexOfObject:anObject];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.dataArray objectAtIndex:index];
}

- (void)removeAllObjects
{
    [self.dataArray removeAllObjects];
}

#pragma mark - kvo 
- (void)addTheObserverWithObject:(id)obj
{
    [self addObserver:obj forKeyPath:@"isLoading" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:obj forKeyPath:@"isRefreshing" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:obj forKeyPath:@"isChange" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeTheObserverWithObject:(id)obj
{
    [self removeObserver:obj forKeyPath:@"isLoading"];
    [self removeObserver:obj forKeyPath:@"isRefreshing"];
    [self removeObserver:obj forKeyPath:@"isChange"];
}



@end
