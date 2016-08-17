//
//  SearchView.h
//  orange
//
//  Created by D_Collin on 16/7/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView


//@property (nonatomic, copy) void (^taphotCategoryBtnBlock)(NSString * hotString);

@property (nonatomic, copy) void (^tapRecordBtnBlock)(NSString * keyword);


- (void)setHotArray:(NSArray *)hotArray withRecentArray:(NSArray *)recentArray;

@end
