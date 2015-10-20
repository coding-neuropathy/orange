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
@property (strong, nonatomic) UILabel * indicatorLable;
@property (assign, nonatomic) UserPageType type;

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

- (UILabel *)indicatorLable
{
    if (!_indicatorLable) {
        _indicatorLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _indicatorLable.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        _indicatorLable.textAlignment = NSTextAlignmentLeft;
        _indicatorLable.textColor = UIColorFromRGB(0x9d9e9f);
        _indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleRight];
//        _indicatorLable.hidden = YES;
//        _indicatorLable.backgroundColor = [UIColor redColor];
        [self addSubview:_indicatorLable];
    }
    return _indicatorLable;
}

- (void)setUser:(GKUser *)user WithType:(UserPageType)type
{
    _user = user;
    _type = type;
    
    switch (_type) {
        case UserLikeType:
            self.titleLabel.text = NSLocalizedStringFromTable(@"like", kLocalizedFile, nil);
            self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_user.likeCount];
            break;
        case UserPostType:
            self.titleLabel.text = NSLocalizedStringFromTable(@"note", kLocalizedFile, nil);
            self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_user.noteCount];
            break;
        case UserTagType:
            self.titleLabel.text = NSLocalizedStringFromTable(@"tags", kLocalizedFile, nil);
            self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_user.tagCount];
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(16., 0., 40., self.deFrameHeight);
    self.numberLabel.frame = CGRectMake(0., 0., 100., self.deFrameHeight);
    self.numberLabel.deFrameLeft = self.titleLabel.deFrameRight + 5.;
    
    self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
    self.indicatorLable.center = self.titleLabel.center;
    self.indicatorLable.deFrameRight = self.deFrameRight - 10.;
}

#pragma mark - touch touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapHeaderViewWithType:)])
    {
        [_delegate TapHeaderViewWithType:self.type];
    }
}

@end
