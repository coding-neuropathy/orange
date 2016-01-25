//
//  EntityPreViewController.h
//  orange
//
//  Created by 谢家欣 on 15/11/24.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityPreViewController : UIViewController

/** 3d-Touch购买商品界面跳转 */
@property (nonatomic, copy) void(^backblock)(UIViewController * vc);
@property (nonatomic, copy) void(^baichuanblock)(GKPurchase * purchase);


- (instancetype)initWithEntity:(GKEntity *)entity;

@end
