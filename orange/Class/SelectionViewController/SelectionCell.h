//
//  SelectionCell.h
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKViewDelegate.h"


@interface SelectionCell : UICollectionViewCell

@property (nonatomic, strong) GKEntity      *entity;
@property (nonatomic, strong) NSDictionary  *dict;
@property (nonatomic, strong) UIImageView   *image;

@property (assign, nonatomic) id<GKViewDelegate> delegate;

+ (CGFloat)height:(GKNote *)note;

@end
