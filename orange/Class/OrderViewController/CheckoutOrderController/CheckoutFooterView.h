//
//  CheckoutFooterView.h
//  orange
//
//  Created by 谢家欣 on 16/9/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckoutFooterViewDelegate;


@interface CheckoutFooterView : UICollectionReusableView

@property (strong, nonatomic) GKOrder   *order;
@property (weak, nonatomic) id<CheckoutFooterViewDelegate> delegate;

@end

@protocol CheckoutFooterViewDelegate <NSObject>

@optional
- (void)tapAlipayBtn:(id)sender;
- (void)tapWeCahtBtn:(id)sender;
- (void)tapStorePayBtn:(id)sender;

@end
