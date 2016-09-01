//
//  OrderCell.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell ()

@property (strong, nonatomic) UILabel   *priceLabel;
@property (strong, nonatomic) UILabel   *volumeLable;

@end

@implementation OrderCell

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font            = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.];
        _priceLabel.textColor       = [UIColor colorFromHexString:@"#5976c1"];
        _priceLabel.textAlignment   = NSTextAlignmentRight;
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)volumeLable
{
    if (!_volumeLable) {
        _volumeLable                = [[UILabel alloc] initWithFrame:CGRectZero];
        _volumeLable.font           = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.];
        _volumeLable.textColor      = [UIColor colorFromHexString:@"#757575"];
        _volumeLable.textAlignment  = NSTextAlignmentRight;
        [self.contentView addSubview:_volumeLable];
    }
    return _volumeLable;
}

@end
