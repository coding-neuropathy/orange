//
//  EmptyView.m
//  orange
//
//  Created by 谢家欣 on 15/3/20.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EmptyView.h"



@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (UIImageView *)noticImageView
{
    if (!_noticImageView) {
        
        _noticImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _noticImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        _noticImageView.image = noticImage;
        [self addSubview:_noticImageView];
    }
    return _noticImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 2;
        _detailLabel.font = [UIFont systemFontOfSize:14.];
        _detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

@end
