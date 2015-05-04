//
//  SelectionCategoryView.h
//  Blueberry
//
//  Created by huiter on 13-10-25.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectionCategoryView : UIView

@property (nonatomic, copy) void (^tapButtonBlock)(NSUInteger i, NSString * catename);
@property (nonatomic, assign) NSUInteger cateId;
@property (nonatomic, weak) UITableView *tableView;
- (id)initWithCateId:(NSUInteger)cateId;
- (void)show;
- (void)dismiss;
@end
