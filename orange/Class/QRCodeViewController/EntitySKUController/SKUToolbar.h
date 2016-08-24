//
//  SKUToolbar.h
//  orange
//
//  Created by 谢家欣 on 16/8/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKUToolbarDelegate <NSObject>

- (void)tapOrderBtn:(id)sender;

@end


@interface SKUToolbar : UIView

@property (assign, nonatomic) float price;
@property (weak, nonatomic) id<SKUToolbarDelegate> delegate;

- (void)updatePriceWithprice:(float)price;

@end
