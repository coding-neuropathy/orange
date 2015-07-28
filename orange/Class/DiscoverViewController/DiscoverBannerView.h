//
//  DiscoverBannerView.h
//  orange
//
//  Created by 谢家欣 on 15/7/27.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverBannerViewDelegate <NSObject>

- (void)TapBannerImageAction:(NSDictionary *)dict;

@end

@interface DiscoverBannerView : UICollectionReusableView

@property (strong, nonatomic) NSArray * bannerArray;
@property (weak, nonatomic) id<DiscoverBannerViewDelegate> delegate;

@end
