//
//  GKDiscover.m
//  orange
//
//  Created by 谢家欣 on 16/8/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKDiscover.h"
#import "API.h"


@interface GKDiscover ()

@end

@implementation GKDiscover

static NSString *  BannerIdentifier = @"Banner";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    
    }
    return self;
}

- (NSArray *)banners
{
    if (!_banners) {
        _banners = [NSArray array];
    }
    return _banners;
}

- (void)refresh
{
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isRefreshing"];
        [API getDiscoverWithsuccess:^(NSArray *banners, NSArray * entities,
                                      NSArray * categories, NSArray * articles, NSArray * users) {
            self.banners = banners;
            self.categories = categories;
            self.users = users;
            self.articles = articles;
            self.entities = entities;
            
            [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
        } failure:^(NSInteger stateCode, NSError * error) {
            self.error = error;
//            [self.collectionView.pullToRefreshView stopAnimating];
            [self setValue:[NSNumber numberWithBool:NO] forKey:@"isRefreshing"];
        }];
}


- (NSInteger)count
{
    return self.bannerCount + self.categoryCount + self.userCount + self.articleCount + self.entityCount;
}

- (NSInteger)bannerCount
{
    return self.banners.count;
}

- (NSInteger)categoryCount
{
    return self.categories.count;
}

- (NSInteger)userCount
{
    return self.users.count;
}

- (NSInteger)entityCount
{
    return self.entities.count;
}

- (NSInteger)articleCount
{
    return self.articles.count;
}

@end
