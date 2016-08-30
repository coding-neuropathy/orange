//
//  CartCell.m
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CartCell.h"

@interface CartCell ()

@property (strong, nonatomic) UIButton  *addBtn;
@property (strong, nonatomic) UIButton  *decrBtn;

@end

@implementation CartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self                = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}


- (void)setCartItem:(ShoppingCart *)cartItem
{
    _cartItem                   = cartItem;
    self.textLabel.text         = _cartItem.entity.entityName;
//    self.detailTextLabel.text   = _cartItem.sku.attrs
    
    [self.imageView sd_setImageWithURL:_cartItem.entity.imageURL_310x310 placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.imageView.deFrameSize] options:SDWebImageRetryFailed];
    

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
