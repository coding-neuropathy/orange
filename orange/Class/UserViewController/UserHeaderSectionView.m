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

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = UIColorFromRGB(0xffffff);
//        //        self.backgroundColor = [UIColor redColor];
//    }
//    return self;
//}

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

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = [UIFont systemFontOfSize:14.];
        _numberLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_numberLabel];
    }
    
    return _numberLabel;
}

- (void)setUser:(GKUser *)user WithType:(UserPageType)type
{
    _user = user;
    
    switch (type) {
        case UserLikeType:
            self.titleLabel.text = NSLocalizedStringFromTable(@"like", kLocalizedFile, nil);
            self.numberLabel.text = [NSString stringWithFormat:@"%ld", _user.likeCount];
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(16., 0., 40., self.deFrameHeight);
    self.numberLabel.frame = CGRectMake(0., 0., 100., self.deFrameHeight);
    self.numberLabel.deFrameLeft = self.titleLabel.deFrameRight + 5.;
}

@end
