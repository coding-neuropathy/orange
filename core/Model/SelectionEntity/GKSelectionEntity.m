//
//  GKSelectionEntity.m
//  orange
//
//  Created by 谢家欣 on 16/3/28.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKSelectionEntity.h"
#import "API.h"
#import "ImageCache.h"

@import CoreSpotlight;

@interface GKSelectionEntity ()

@end

@implementation GKSelectionEntity

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeInteger:self.categoryId forKey:@"caID"];
//    [aCoder encodeObject:self.dataArray forKey:@"dataArray"];
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        [aDecoder decodeObjectForKey:@"caID"];
//        [aDecoder decodeObjectForKey:@"dataArray"];
//    }
//    return self;
//}

- (void)refresh
{
//    self.page = 1;
    
    [super refresh];
    [API getSelectionListWithTimestamp:self.timestamp cateId:self.categoryId count:30 success:^(NSArray *dataArray) {
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
        
        [self saveEntityToIndexWithData:dataArray];
        
//        缓存
//        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"selection.entity.data"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } failure:^(NSInteger stateCode, NSError * error) {
        self.error = error;
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
        
    }];
}

- (void)refreshWithCategoryId:(NSInteger)cateId
{
    self.categoryId = cateId;
    [self refresh];

}

- (void)load
{
    //    if (self.index == 0) {
    [self setValue:[NSNumber numberWithBool:YES] forKeyPath:@"isLoading"];
    NSTimeInterval timestamp = (NSTimeInterval)[self.dataArray.lastObject[@"time"] doubleValue];
    [API getSelectionListWithTimestamp:timestamp cateId:self.categoryId count:30 success:^(NSArray *dataArray) {
        [self.dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:dataArray]];
        
        [self setValue:[NSNumber numberWithBool:NO] forKeyPath:@"isLoading"];
        
        [self saveEntityToIndexWithData:dataArray];
        
        
    } failure:^(NSInteger stateCode, NSError * error) {
        self.error = error;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GKNetworkReachabilityStatusNotReachable" object:nil];
        [self setValue:[NSNumber numberWithBool:NO] forKeyPath:@"isLoading"];
       
    }];
    
}

- (void)loadWithCategoryId:(NSInteger)cateId
{
    self.categoryId = cateId;
    [self load];
}

//- (BOOL)loadFromCache
//{
//    
//    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selection.entity.data"];
//    if (data) {
//        self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}



#pragma mark - save to index

- (void)saveEntityToIndexWithData:(NSArray *)data
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<CSSearchableItem *> *searchableItems = [NSMutableArray array];
        
        for (NSDictionary * row in data) {
            CSSearchableItemAttributeSet *attributedSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"entity"];
            GKEntity * entity = [[row objectForKey:@"content"] objectForKey:@"entity"];
            GKNote * note = [[row objectForKey:@"content"] objectForKey:@"note"];
            
            attributedSet.title = entity.entityName;
            attributedSet.contentDescription = note.text;
            attributedSet.identifier = @"entity";
            
            /**
             *  set image data
             */
            NSData * imagedata = [ImageCache readImageWithURL:entity.imageURL_240x240];
            if (imagedata) {
                attributedSet.thumbnailData = imagedata;
            } else {
                attributedSet.thumbnailData = [NSData dataWithContentsOfURL:entity.imageURL_240x240];
                [ImageCache saveImageWhthData:attributedSet.thumbnailData URL:entity.imageURL_240x240];
            }
            
            
            CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"entity:%@", entity.entityId] domainIdentifier:@"com.guoku.iphone.search.entity" attributeSet:attributedSet];
            
            [searchableItems addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.entityImageView setImage:placeholder];
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"index Error %@",error.localizedDescription);
                }
            }];
        });
    });
}


@end
