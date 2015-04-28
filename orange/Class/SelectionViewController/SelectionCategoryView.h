//
//  SelectionCategoryView.h
//  Blueberry
//
//  Created by huiter on 13-10-25.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectionCategoryView : UIView

@property (nonatomic, copy) void (^tapButtonBlock)(NSUInteger i);
@property (nonatomic, assign) NSUInteger cateId;
- (id)initWithCateId:(NSUInteger)cateId;
- (void)show;
- (void)dismiss;
@end
