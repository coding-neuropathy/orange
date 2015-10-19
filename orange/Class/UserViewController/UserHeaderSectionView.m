//
//  UserHeaderSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserHeaderSectionView.h"


@interface UserHeaderSectionView ()

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * numberLabel;

@end

@implementation UserHeaderSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        //        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
//        _titleLabel.text = NSLocalizedStringFromTable(@"like", kLocalizedFile, nil);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setUser:(GKUser *)user WithType:(UserPageType)type
{
    _user = user;
    
    switch (type) {
        case UserLikeType:
            self.titleLabel.text = NSLocalizedStringFromTable(@"like", kLocalizedFile, nil);
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(16., 0., kScreenWidth - 32., self.deFrameHeight);
}

@end
