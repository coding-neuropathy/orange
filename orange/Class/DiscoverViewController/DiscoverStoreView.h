//
//  DiscoverStoreView.h
//  orange
//
//  Created by 谢家欣 on 2016/10/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverStoreView : UICollectionReusableView

@property (strong, nonatomic) NSArray *stores;

@property (nonatomic, copy) void (^tapStoreImage)(NSURL *storeURL);

@end
