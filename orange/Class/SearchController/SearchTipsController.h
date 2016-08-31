//
//  SearchTipsController.h
//  orange
//
//  Created by 谢家欣 on 16/8/31.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTipsController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void (^tapRecordBtnBlock)(NSString * keyword);

- (void)setSearchHistoryWords:(NSArray *)history_words HotWords:(NSArray *)hotwords;

@end
