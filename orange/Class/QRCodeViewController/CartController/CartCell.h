//
//  CartCell.h
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell

@property (weak, nonatomic) ShoppingCart *cartItem;

@property (nonatomic, copy) void (^updateOrderPrice)();

@end
