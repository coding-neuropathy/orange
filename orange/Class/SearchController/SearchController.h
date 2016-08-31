//
//  NewSearchController.h
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController : UIViewController <UISearchResultsUpdating>

- (void)searchText:(NSString *)string;

@end
