//
//  GKBaseData.h
//  orange
//
//  Created by 谢家欣 on 16/3/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKBaseData : NSObject {
    BOOL isLoading;
    BOOL isRefreshing;
    BOOL isChange;
}

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (readonly, getter=count) NSInteger count;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic) NSTimeInterval timestamp;

@property (strong, nonatomic) NSError * error;

- (void)refresh;
- (void)load;

- (NSInteger)indexOfObject:(id)anObject;
- (id)objectAtIndex:(NSUInteger)index;
//- (void)removeObjectAtIndex:(NSInteger)index;
- (void)removeAllObjects;


/**
 *  kvo method
 */
- (void)addTheObserverWithObject:(id)obj;
- (void)removeTheObserverWithObject:(id)obj;

@end
