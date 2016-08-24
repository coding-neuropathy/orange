//
//  EntitySKUHeaderView.m
//  orange
//
//  Created by 谢家欣 on 16/8/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUHeaderView.h"

@interface EntitySKUHeaderView ()

@property (strong, nonatomic) UIImageView   *entityImageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *pricelLabel;
@property (strong, nonatomic) UIButton      *cartBtn;

@end

@implementation EntitySKUHeaderView

#pragma mark - lazy load view
- (UIImageView *)entityImageView
{
    if (!_entityImageView) {
        _entityImageView                    = [[UIImageView alloc] initWithFrame:CGRectZero];
        _entityImageView.deFrameSize        = CGSizeMake(206. * kScreeenScale, 206. * kScreeenScale);
        _entityImageView.contentMode        = UIViewContentModeScaleAspectFit;
//        _entityImageView.backgroundColor    = [UIColor redColor];
        
        [self addSubview:_entityImageView];
    }
    return _entityImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                         = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.deFrameSize             = CGSizeMake(self.deFrameWidth - 48., 24.);
        _titleLabel.numberOfLines           = 1;
        _titleLabel.font                    = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.];
        _titleLabel.textColor               = UIColorFromRGB(0x212121);
        _titleLabel.textAlignment           = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode           = NSLineBreakByTruncatingTail;
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)pricelLabel
{
    if (!_pricelLabel) {
        _pricelLabel                        = [[UILabel alloc] initWithFrame:CGRectZero];
        _pricelLabel.deFrameSize            = CGSizeMake(120. * kScreeenScale, 24.);
//        _pricelLabel.layer.cornerRadius     = _pricelLabel.deFrameHeight / 2.;
        _pricelLabel.numberOfLines          = 1;
        _pricelLabel.font                   = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _pricelLabel.textColor              = UIColorFromRGB(0x5976c1);
        _pricelLabel.textAlignment          = NSTextAlignmentLeft;
        
        [self addSubview:_pricelLabel];
    }
    
    return _pricelLabel;
}

- (UIButton *)cartBtn
{
    if (!_cartBtn) {
        _cartBtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartBtn.deFrameSize                = CGSizeMake(128., 32.);
        _cartBtn.layer.cornerRadius         = _cartBtn.deFrameHeight / 2.;
        _cartBtn.backgroundColor            = UIColorFromRGB(0x6192ff);
        _cartBtn.titleLabel.font            = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        
        [_cartBtn setTitle:NSLocalizedStringFromTable(@"add-cart", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_cartBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        [self addSubview:_cartBtn];
    
    }
    
    return _cartBtn;
}


#pragma mark - set data
- (void)setEntity:(GKEntity *)entity
{
    _entity                         = entity;
    self.titleLabel.text            = self.entity.title;
    self.pricelLabel.text           = [NSString stringWithFormat:@"￥ %.2f", _entity.lowestPrice];
    
    DDLogInfo(@"image url %@", _entity.imageURL);
    [self.entityImageView sd_setImageWithURL:_entity.imageURL_640x640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:self.entityImageView.deFrameSize] options:SDWebImageLowPriority];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.entityImageView.deFrameTop         = 24.;
//    self.entityImageView.deFrameLeft        = 85.;
    self.entityImageView.deFrameLeft        = (self.deFrameWidth - self.entityImageView.deFrameWidth) / 2.;
    DDLogInfo(@"image view %@", self.entityImageView);
    
    self.titleLabel.deFrameTop              = self.entityImageView.deFrameBottom + 24.;
    self.titleLabel.deFrameLeft             = 24.;
    
    self.pricelLabel.deFrameTop             = self.titleLabel.deFrameBottom + 20.;
    self.pricelLabel.deFrameLeft            = self.titleLabel.deFrameLeft;
    
    self.cartBtn.center                     = self.pricelLabel.center;
    self.cartBtn.deFrameRight               = self.deFrameRight - 24.;
    
}

@end
