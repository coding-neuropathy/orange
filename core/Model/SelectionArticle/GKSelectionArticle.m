//
//  GKSelectionArticle.m
//  orange
//
//  Created by 谢家欣 on 16/8/2.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKSelectionArticle.h"
#import "API.h"
#import "ImageCache.h"

@import CoreSpotlight;

@implementation GKSelectionArticle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = 20;
    }
    return self;
}

- (void)refresh
{
//    self.page = 1;
    
    [API getArticlesWithTimestamp:self.timestamp Page:self.page Size:self.size success:^(NSArray *articles) {
        self.dataArray = [NSMutableArray arrayWithArray:articles];
        self.page +=1;
        
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
//        [self.collectionView.pullToRefreshView stopAnimating];
//        [self.collectionView reloadData];
        [self saveEntityToIndexWithData:articles];
    } failure:^(NSInteger stateCode, NSError * error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GKNetworkReachabilityStatusNotReachable" object:nil];
        self.error = error;
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
    }];
}

- (void)load
{
        [API getArticlesWithTimestamp:self.timestamp Page:self.page Size:self.size success:^(NSArray *articles) {
            self.page += 1;
            [self.dataArray addObjectsFromArray:articles];
//            [self.collectionView.infiniteScrollingView stopAnimating];
//            [self.collectionView reloadData];
            [self setValue:[NSNumber numberWithBool:NO] forKeyPath:@"isLoading"];
            [self saveEntityToIndexWithData:articles];
        } failure:^(NSInteger stateCode, NSError * error) {
            self.error = error;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"GKNetworkReachabilityStatusNotReachable" object:nil];
            [self setValue:[NSNumber numberWithBool:NO] forKeyPath:@"isLoading"];
        }];
}

#pragma mark - save to index
- (void)saveEntityToIndexWithData:(NSArray *)data
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<CSSearchableItem *> *searchableItems = [NSMutableArray array];
        
        for (NSDictionary * row in data) {
            CSSearchableItemAttributeSet *attributedSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"article"];
            GKArticle * article = (GKArticle *)row;
            attributedSet.title = article.title;
            attributedSet.contentDescription = article.content;
            attributedSet.identifier = @"article";
            
            /**
             *  set image data
             */
            NSData * imagedata = [ImageCache readImageWithURL:article.coverURL_300];
            if (imagedata) {
                attributedSet.thumbnailData = imagedata;
            } else {
                attributedSet.thumbnailData = [NSData dataWithContentsOfURL:article.coverURL_300];
                [ImageCache saveImageWhthData:attributedSet.thumbnailData URL:article.coverURL_300];
            }
            
            
            CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"article:%ld", (long)article.articleId] domainIdentifier:@"com.guoku.iphone.search.article" attributeSet:attributedSet];
            
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
