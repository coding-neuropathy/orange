//
//  DiscoverHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/3/14.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverHeaderViewDelegate <NSObject>

- (void)TapBannerImageAction:(NSDictionary *)dict;

@end

@interface DiscoverHeaderView : UIView

@property (strong, nonatomic) NSArray * bannerArray;
@property (weak, nonatomic) id<DiscoverHeaderViewDelegate> delegate;

@end
