//
//  IndexRequestHandler.m
//  seach
//
//  Created by 谢家欣 on 15/9/28.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "IndexRequestHandler.h"

@implementation IndexRequestHandler

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexAllSearchableItemsWithAcknowledgementHandler:(void (^)(void))acknowledgementHandler {
    // Reindex all data with the provided index
    
    acknowledgementHandler();
}

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexSearchableItemsWithIdentifiers:(NSArray <NSString *> *)identifiers acknowledgementHandler:(void (^)(void))acknowledgementHandler {
    // Reindex any items with the given identifiers and the provided index
    
    acknowledgementHandler();
}

@end
