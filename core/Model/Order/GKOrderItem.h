//
//  GkOrderItem.h
//  orange
//
//  Created by 谢家欣 on 16/9/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKOrderItem : GKBaseModel

@property (assign, nonatomic) NSInteger volume;
@property (strong, nonatomic) NSString  *entityTitle;
@property (strong, nonatomic) NSURL     *imageURL;
@property (assign, nonatomic) float     totalPrice;
@property (assign, nonatomic) float     promoTotalPrice;
@property (strong, nonatomic) NSDate    *addDateTime;

@end
