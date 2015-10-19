//
//  UserFooterSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserFooterSectionView.h"

@interface UserFooterSectionView ()

@property (strong, nonatomic) UILabel * titelLabel;

@end

@implementation UserFooterSectionView

- (UILabel *)titelLabel
{
    if (!_titelLabel) {
        _titelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_titelLabel];
    }
    return _titelLabel;
}

@end
