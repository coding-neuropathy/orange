//
//  GroupViewController.h
//  Blueberry
//
//  Created by huiter on 13-11-9.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger gid;
- (id)initWithGid:(NSUInteger)gid;
@end
