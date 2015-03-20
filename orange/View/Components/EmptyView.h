//
//  EmptyView.h
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EmptyType) {
    Default = 0,
    NoMessageType,
    NoFeedType,
    NoResultType,
};

@interface EmptyView : UIView

@property (strong, nonatomic) UIImageView * noticImageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detailLabel;

@end
