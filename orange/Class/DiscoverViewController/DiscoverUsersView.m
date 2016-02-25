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
        _userLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _userLabel.font = [UIFont systemFontOfSize:14.];
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
        [_moreBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
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
    
    self.userScrollView.contentSize = CGSizeMake(50 * _users.count + 8 * (_users.count - 1), 50.);
    
    for (UIView * view in self.userScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _users.count; i ++) {
        GKUser * user = _users[i];
        UserImageView * imageView = [[UserImageView alloc]initWithFrame:CGRectMake(i * 50.+ i * 8, 0, 50., 50.)];
        [imageView sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(50., 50.)]];
        imageView.user = user;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBtnAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.userScrollView addSubview:imageView];
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
    
    self.userScrollView.frame = CGRectMake(10., 45., kScreenWidth - 20., 50.);
    self.userScrollView.layer.cornerRadius = 4;
    self.userScrollView.layer.masksToBounds = YES;
    
    self.moreBtn.frame = CGRectMake(10., 5., 20., 30.);
    self.moreBtn.deFrameRight = self.userScrollView.deFrameRight;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextStrokePath(context);
    
}


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

//- (void)setUser:(GKUser *)user
//{
//    _user = user;
//    [self setNeedsLayout];
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}

@end

