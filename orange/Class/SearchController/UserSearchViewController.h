//
//  UserSearchViewController.h
//  orange
//
//  Created by huiter on 15/12/8.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSearchViewController : UIViewController
- (void)handleSearchText:(NSString *)searchText;
@property (nonatomic, weak) UISearchBar * searchBar;
@end
