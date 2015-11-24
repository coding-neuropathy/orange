//
//  EntityPreView.m
//  orange
//
//  Created by 谢家欣 on 15/11/24.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "EntityPreView.h"

@interface EntityPreView ()

@property (strong, nonatomic) UIImageView * entityImage;
@property (strong, nonatomic) UILabel * titleLable;

@end

@implementation EntityPreView


- (UIImageView *)entityImage
{
    if (!_entityImage) {
        _entityImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _entityImage.contentMode = UIViewContentModeScaleAspectFill;
        _entityImage.layer.masksToBounds = YES;
        
        [self addSubview:_entityImage];
    }
    return _entityImage;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.font = [UIFont systemFontOfSize:20.];
        _titleLable.textColor = UIColorFromRGB(0x414243);
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLable];
    }
    return _titleLable;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    self.titleLable.text = _entity.title;

    
    [self.entityImage sd_setImageWithURL:_entity.imageURL_640x640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(100., 100.)]];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLable.frame = CGRectMake(10., 20., self.deFrameWidth - 20, 30.);
    
    self.entityImage.frame = CGRectMake(0., 0., self.deFrameWidth, self.deFrameWidth);
    self.entityImage.deFrameTop = self.titleLable.deFrameBottom + 10.;
}

@end
