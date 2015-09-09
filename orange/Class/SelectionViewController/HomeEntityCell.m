//
//  HomeEntityCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/7.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HomeEntityCell.h"
#import "NSString+Helper.h"

@interface HomeEntityCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UILabel * tagLabel;
@property (strong, nonatomic) UIButton * likeBtn;

@end

@implementation HomeEntityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.font = [UIFont systemFontOfSize:14.];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _tagLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
 
    [self.imageView sd_setImageWithURL:_entity.imageURL_310x310];
    self.titleLabel.text = _entity.title;
//    self.detailLabel.textColor = _entity.description;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0., 0., 180., 180.);
    self.titleLabel.frame = CGRectMake(0., 0., 163., 30.);
//    CGFloat titleHeight =  [self.titleLabel.text heightWithLineWidth:self.titleLabel.deFrameWidth Font:self.titleLabel.font];
    self.titleLabel.deFrameHeight = [self.titleLabel.text heightWithLineWidth:self.titleLabel.deFrameWidth Font:self.titleLabel.font];
    self.titleLabel.deFrameTop = 16.;
    self.titleLabel.deFrameLeft = self.imageView.deFrameRight + 10;
}

@end
