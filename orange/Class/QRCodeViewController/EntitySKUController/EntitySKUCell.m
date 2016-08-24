//
//  EntitySKUCell.m
//  orange
//
//  Created by 谢家欣 on 16/8/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUCell.h"

@interface EntitySKUCell ()

@property (strong, nonatomic) UILabel   *skuInfoLabel;

@end

@implementation EntitySKUCell

#pragma mark - lazy load view
- (UILabel *)skuInfoLabel
{
    if (!_skuInfoLabel) {
        _skuInfoLabel                       = [[UILabel alloc] initWithFrame:CGRectZero];
        _skuInfoLabel.font                  = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        _skuInfoLabel.textColor             = UIColorFromRGB(0x757575);
        _skuInfoLabel.backgroundColor       = UIColorFromRGB(0xf1f1f1);
        _skuInfoLabel.textAlignment         = NSTextAlignmentCenter;
        _skuInfoLabel.layer.masksToBounds   = YES;
        
        [self.contentView addSubview:_skuInfoLabel];
    
    }
    return _skuInfoLabel;
}

#pragma mark - 
- (void)setSKUdefault
{
    self.skuInfoLabel.textColor             = UIColorFromRGB(0x757575);
    self.skuInfoLabel.backgroundColor       = UIColorFromRGB(0xf1f1f1);
    self.skuInfoLabel.layer.borderWidth     = 0.;
//    self.skuInfoLabel.layer.borderColor     = UIColorFromRGB(0xf1f1f1).CGColor;
}

- (void)setSKUselected
{
    self.skuInfoLabel.textColor             = UIColorFromRGB(0x3f6ff0);
    self.skuInfoLabel.backgroundColor       = UIColorFromRGB(0xe6ecef);
    self.skuInfoLabel.layer.borderWidth     = 1.;
    self.skuInfoLabel.layer.borderColor     = UIColorFromRGB(0x3f6ff0).CGColor;
}

#pragma mark - set data;
- (void)setSku:(GKEntitySKU *)sku
{
    _sku                                = sku;
    
//    DDLogInfo(@"sku info %@", _sku.attrs);
    NSMutableString * skuString = [NSMutableString stringWithCapacity:0];
    for (NSString * key in _sku.attrs) {
//        DDLogInfo(@"key %@", key);
        [skuString appendString:[NSString stringWithFormat:@"%@ / %@; ", key, _sku.attrs[key]]];
    }
    DDLogInfo(@"sku info %@", skuString);
//    self.skuInfoLabel.text          = [skuString substringWithRange:NSMakeRange(0, [skuString length] - 1)];
    self.skuInfoLabel.text              = skuString;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.skuInfoLabel.frame                 = CGRectMake(0., 0., [EntitySKUCell cellWidthWithSKU:self.sku], 24.);
    self.skuInfoLabel.layer.cornerRadius    = self.skuInfoLabel.deFrameHeight / 2.;

    [self setSKUdefault];
}


#pragma mark - class method
+ (CGFloat)cellWidthWithSKU:(GKEntitySKU *)sku
{
    NSMutableString * skuString = [NSMutableString stringWithCapacity:0];
    for (NSString * key in sku.attrs) {
        //        DDLogInfo(@"key %@", key);
        [skuString appendString:[NSString stringWithFormat:@"%@ / %@; ", key, sku.attrs[key]]];
    }
    if ([skuString length] == 0)
        return 0.;
    
    CGFloat width = [skuString widthWithLineWidth:0. Font:[UIFont fontWithName:@"PingFangSC-Regular" size:14.]];
    
    
    return width + 16.;
}



@end
