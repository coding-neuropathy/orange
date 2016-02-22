//
//  DiscoverUsersView.m
//  orange
//
//  Created by D_Collin on 16/2/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "DiscoverUsersView.h"


@interface DiscoverUsersView ()

@property (nonatomic , strong) UILabel * userLabel;

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
    
    self.userScrollView.contentSize = CGSizeMake(50 * _users.count + 8 * (_users.count - 1), 100.);
    
    for (UIView * view in self.userScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _users.count; i ++) {
        GKUser * user = _users[i];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 50.+ i * 8, 0, 50., 50.)];
        [imageView sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(50., 50.)]];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBtnAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.userScrollView addSubview:imageView];
    }
    
    [self setNeedsLayout];
}

#pragma mark --------- button action ------------

- (void)userBtnAction:(id)sender
{
    
    if (self.tapUserBlock) {
        self.tapUserBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 30.);
    self.userScrollView.frame = CGRectMake(10., 45., kScreenWidth - 20., 50.);
    self.userScrollView.layer.cornerRadius = 25;
    self.userScrollView.layer.masksToBounds = YES;
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
