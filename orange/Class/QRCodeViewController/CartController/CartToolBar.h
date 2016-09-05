//
//  CartToolBar.h
//  orange
//
//  Created by 谢家欣 on 16/8/30.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartToolbarDelegate <NSObject>

- (void)tapCheckOutBtn:(id)sender;

@end

@interface CartToolBar : UIView

@property (assign, nonatomic) CGFloat price;
@property (weak, nonatomic) id<CartToolbarDelegate> delegate;

- (void)updatePriceWithprice:(float)price;

@end
