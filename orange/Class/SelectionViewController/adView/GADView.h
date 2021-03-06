//
//  GADView.h
//  orange
//
//  Created by 谢家欣 on 16/10/17.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GADView : UICollectionReusableView

@property (strong, nonatomic) NSArray   * adDataArray;

@property (copy, nonatomic) void (^touchADBlock)(NSURL *adURL);
@property (copy, nonatomic) void (^closeADBlock)();

@end
