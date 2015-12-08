//
//  SearchController.h
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"
#import "DiscoverController.h"

@interface SearchController : UIViewController<UISearchResultsUpdating>
@property(nonatomic,weak) DiscoverController *discoverVC;

-(void)searchText:(NSString *)string;
- (void)setSelectedWithType:(SearchType)type;

@end
