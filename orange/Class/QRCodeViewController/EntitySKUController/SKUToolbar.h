//
//  SKUToolbar.h
//  orange
//
//  Created by 谢家欣 on 16/8/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKUToolbar : UIView

@property (assign, nonatomic) float price;

- (void)updatePriceWithprice:(float)price;

@end
