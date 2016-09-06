//
//  OrderHeaderView.h
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderHeaderViewDelegate;

@interface OrderHeaderView : UICollectionReusableView

@property (weak, nonatomic) GKOrder     *order;
@property (weak, nonatomic) id<OrderHeaderViewDelegate> delegate;

@property (strong, nonatomic) UILabel   *createOrderLabel;
@property (strong, nonatomic) UILabel   *orderTipsLabel;
@property (strong, nonatomic) UILabel   *orderNumberLabel;
@property (strong, nonatomic) UILabel   *statusTipsLabel;
@property (strong, nonatomic) UILabel   *statusLabel;
@property (strong, nonatomic) UIButton  *paymentBtn;

@property (assign, nonatomic) BOOL      paymentEnable;
//- (void)setPaymentEnable:(BOOL)enable;

@end

@protocol OrderHeaderViewDelegate <NSObject>

@optional
- (void)tapPaymentBtnAction:(GKOrder *)order;

@end