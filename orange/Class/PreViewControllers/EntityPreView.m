//
//  EntityPreView.m
//  orange
//
//  Created by 谢家欣 on 15/11/24.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "EntityPreView.h"

@interface EntityPreView ()

@property (strong, nonatomic) UIImageView   *entityImage;
@property (strong, nonatomic) UILabel       *titleLable;
@property (strong, nonatomic) UILabel       *priceLabel;

@end

@implementation EntityPreView


- (UIImageView *)entityImage
{
    if (!_entityImage) {
        _entityImage                        = [[UIImageView alloc] initWithFrame:CGRectZero];
        _entityImage.deFrameSize            = CGSizeMake(self.deFrameWidth, self.deFrameWidth);
        _entityImage.contentMode            = UIViewContentModeScaleAspectFill;
        _entityImage.layer.masksToBounds    = YES;
        
        [self addSubview:_entityImage];
    }
    return _entityImage;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.deFrameSize     = CGSizeMake(self.deFrameWidth - 20, 30.);
        _titleLable.font            = [UIFont fontWithName:@"PingFangSC-Bold" size:20.];
        _titleLable.textColor       = [UIColor colorFromHexString:@"#212121"];
        _titleLable.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview:_titleLable];
    }
    return _titleLable;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.deFrameSize     = CGSizeMake(self.deFrameWidth - 20., 40.);
        _priceLabel.font            = [UIFont fontWithName:@"PingFangSC-Semibold" size:24.];
        _priceLabel.textColor       = [UIColor colorFromHexString:@"#5976C1"];
        _priceLabel.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity                     = entity;
    self.titleLable.text        = _entity.entityName;
    self.priceLabel.text        = [NSString stringWithFormat:@"￥ %.2f", _entity.lowestPrice];
    
    if (self.preImage) {
        [self.entityImage sd_setImageWithURL:_entity.imageURL_640x640
                            placeholderImage:self.preImage];
    } else {
        [self.entityImage sd_setImageWithURL:_entity.imageURL_640x640
                        placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.entityImage.deFrameSize]];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLable.deFrameTop      = 20.;
    self.titleLable.deFrameLeft     = 10.;
    
    self.entityImage.deFrameTop     = self.titleLable.deFrameBottom + 10.;
    
    self.priceLabel.center          = self.titleLable.center;
    self.priceLabel.deFrameTop      = self.entityImage.deFrameBottom + 20.;
}

@end
