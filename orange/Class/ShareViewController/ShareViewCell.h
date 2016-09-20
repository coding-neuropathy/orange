//
//  ShareViewCell.h
//  orange
//
//  Created by 谢家欣 on 16/9/20.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewCell : UIView

//@property (assign, nonatomic) NSInteger cellIndex;

//@property (copy, nonatomic) void (^tapCellAction)(NSInteger index);

- (void)setIconWithImage:(UIImage *)image Title:(NSString *)title;
//- (void)setTitleWithString:(NSString *)ttitle;

@end
