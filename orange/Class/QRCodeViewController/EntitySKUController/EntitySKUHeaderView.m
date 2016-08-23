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
@property (strong, nonatomic) UIButton      *BuyBtn;

@end

@implementation EntitySKUHeaderView

#pragma mark - lazy load view
- (UIImageView *)entityImageView
{
    if (!_entityImageView) {
        _entityImageView                    = [[UIImageView alloc] initWithFrame:CGRectZero];
        _entityImageView.deFrameSize        = CGSizeMake(206. / kScreeenScale, 206. / kScreeenScale);
        _entityImageView.contentMode        = UIViewContentModeScaleAspectFit;
        
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

- (void)setEntity:(GKEntity *)entity
{
    self.entity = entity;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.entityImageView.deFrameTop         = 24.;
    self.entityImageView.deFrameLeft        = (self.deFrameWidth - self.entityImageView.deFrameWidth) / 2.;
    
    self.titleLabel.deFrameTop              = self.entityImageView.deFrameBottom + 24.;
    self.titleLabel.deFrameLeft             = 24.;
    
    
}

@end
