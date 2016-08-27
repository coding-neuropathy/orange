//
//  DiscoverUsersView.m
//  orange
//
//  Created by D_Collin on 16/2/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "DiscoverUsersView.h"

#import "RecUserController.h"

@interface UserImageView : UIImageView

@property (nonatomic , strong)GKUser * user;

@property (nonatomic , strong)UIImageView * avatarView;

@end


@interface UserNameLabel : UILabel

@property (nonatomic , strong)GKUser * user;

@property (nonatomic , strong)UILabel * userName;

@end

@interface DiscoverUsersView ()

@property (nonatomic , strong) UILabel * userLabel;

@property (nonatomic , strong) UIButton * moreBtn;



@property (nonatomic , strong) UIScrollView * userScrollView;

@end



@implementation DiscoverUsersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)userLabel
{
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _userLabel.font = [UIFont systemFontOfSize:14.];
        _userLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _userLabel.textColor = UIColorFromRGB(0x414243);
        _userLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_userLabel];
    }
    return _userLabel;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:[NSString stringWithFormat:@"%@", [NSString fontAwesomeIconStringForEnum:FAAngleRight]] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        [_moreBtn addTarget:self action:@selector(tapMorebtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (void)tapMorebtnAction:(id)sender
{
    if (self.tapMoreUserBlock) {
        self.tapMoreUserBlock();
    }
    
}

- (UIScrollView *)userScrollView
{
    if (!_userScrollView) {
        _userScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _userScrollView.scrollsToTop = NO;
        _userScrollView.showsHorizontalScrollIndicator = NO;
        _userScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_userScrollView];
    }
    return _userScrollView;
}

- (void)setUsers:(NSArray *)users
{
    _users = users;
    
    self.userLabel.text = NSLocalizedStringFromTable(@"recommendation user", kLocalizedFile, nil);
    
    self.userScrollView.contentSize = CGSizeMake(50 * _users.count + 18 * (_users.count - 1), 50.);
    
    for (UIView * view in self.userScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _users.count; i ++) {
        GKUser * user = _users[i];
        UserImageView * imageView = [[UserImageView alloc]initWithFrame:CGRectMake(i * 50.+ i * 18, 0, 50., 50.)];
        [imageView sd_setImageWithURL:user.avatarURL
                     placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:imageView.deFrameSize]];
        imageView.user = user;
        UserNameLabel * label = [[UserNameLabel alloc]initWithFrame:CGRectMake(i * 50.+ i * 18, 58., 50., 10.)];
        label.user = user;
        label.text = user.nickname;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBtnAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.userScrollView addSubview:imageView];
        [self.userScrollView addSubview:label];
    }
    
    [self setNeedsLayout];
}

#pragma mark --------- button action ------------

- (void)userBtnAction:(id)sender
{
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
    UserImageView * imageView = (UserImageView *)tap.view;
    if (self.tapUserBlock) {
        self.tapUserBlock(imageView.user);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userLabel.frame = CGRectMake(10., 5.,kScreenWidth - 20., 30.);
    
    self.userScrollView.frame = IS_IPHONE?CGRectMake(10., 45., kScreenWidth - 20., 80.):CGRectMake(10., 45., kScreenWidth  - kTabBarWidth - 20., 80.);
    self.userScrollView.layer.cornerRadius = 4;
    self.userScrollView.layer.masksToBounds = YES;
    
    self.moreBtn.frame = CGRectMake(10., 5., 20., 30.);
    self.moreBtn.deFrameRight = self.userScrollView.deFrameRight;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
//    CGContextSetLineWidth(context, kSeparateLineWidth);
//    CGContextMoveToPoint(context, 0., self.deFrameHeight);
//    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
//    CGContextStrokePath(context);
//    
//}


@end

@implementation UserImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 25.;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:UIColorFromRGB(0x000000) andSize:CGSizeMake(50., 50.)]];
        [self addSubview:_avatarView];
    }
    return _avatarView;
}

@end


@implementation UserNameLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 2.;
        self.layer.masksToBounds = YES;
        self.font = [UIFont systemFontOfSize:10.];
        self.textColor = UIColorFromRGB(0x414243);
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (UILabel *)userName
{
    if (!_userName) {
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(0., 0., 50., 10.)];
        _userName.font = [UIFont boldSystemFontOfSize:10.];
        _userName.lineBreakMode = NSLineBreakByWordWrapping;
        _userName.textColor = UIColorFromRGB(0x414243);
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.backgroundColor = [UIColor redColor];
        [self addSubview:_userName];
    }
    return _userName;
}

@end
