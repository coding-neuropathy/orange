//
//  SearchResultsViewController.h
//  orange
//
//  Created by huiter on 15/8/6.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverController.h"

@interface SearchResultsViewController : UIViewController <UISearchResultsUpdating>
@property(nonatomic,weak) DiscoverController *discoverVC;
-(void)searchText:(NSString *)string;
@end
