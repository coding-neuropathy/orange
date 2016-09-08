//
//  DiscoverUsersView.m
//  orange
//
//  Created by D_Collin on 16/2/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "DiscoverUsersView.h"
#import "RecUserController.h"

#import <iCarousel/iCarousel.h>



@interface UserReuserView : UIView

@property (strong, nonatomic) UIImageView   *avatarImageView;
@property (strong, nonatomic) UILabel       *nameLabel;
@property (weak, nonatomic) GKUser          *user;

@end


@interface DiscoverUsersView () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic , strong) UILabel * userLabel;
@property (nonatomic , strong) UIButton * moreBtn;



//@property (nonatomic , strong) UIScrollView * userScrollView;
@property (strong, nonatomic) iCarousel *userCarousel;


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

- (iCarousel *)userCarousel
{
    if (!_userCarousel) {
        _userCarousel               = [[iCarousel alloc] initWithFrame:CGRectZero];
        _userCarousel.deFrameSize   = CGSizeMake(self.deFrameWidth, 80.);
        _userCarousel.type          = iCarouselTypeLinear;
        _userCarousel.dataSource    = self;
        _userCarousel.delegate      = self;
        
        [self addSubview:_userCarousel];
    }
    return _userCarousel;
}


#pragma mark - button action
- (void)tapMorebtnAction:(id)sender
{
    if (self.tapMoreUserBlock) {
        self.tapMoreUserBlock();
    }
    
}

//- (UIScrollView *)userScrollView
//{
//    if (!_userScrollView) {
//        _userScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
//        _userScrollView.scrollsToTop = NO;
//        _userScrollView.showsHorizontalScrollIndicator = NO;
//        _userScrollView.showsVerticalScrollIndicator = NO;
//        [self addSubview:_userScrollView];
//    }
//    return _userScrollView;
//}

- (void)setUsers:(NSArray *)users
{
    _users = users;
    
    self.userLabel.text = NSLocalizedStringFromTable(@"recommendation user", kLocalizedFile, nil);
    
//    self.userScrollView.contentSize = CGSizeMake(50 * _users.count + 18 * (_users.count - 1), 50.);
//    
//    for (UIView * view in self.userScrollView.subviews) {
//        [view removeFromSuperview];
//    }
//    
//    for (int i = 0; i < _users.count; i ++) {
//        GKUser * user = _users[i];
//        UserImageView * imageView = [[UserImageView alloc]initWithFrame:CGRectMake(i * 50.+ i * 18, 0, 50., 50.)];
//        [imageView sd_setImageWithURL:user.avatarURL
//                     placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:imageView.deFrameSize]];
//        imageView.user = user;
//        UserNameLabel * label = [[UserNameLabel alloc]initWithFrame:CGRectMake(i * 50.+ i * 18, 58., 50., 10.)];
//        label.user = user;
//        label.text = user.nickname;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBtnAction:)];
//        [imageView addGestureRecognizer:tap];
//        
//        [self.userScrollView addSubview:imageView];
//        [self.userScrollView addSubview:label];
//    }
//    self.userCarousel.
    [self.userCarousel reloadData];
    
    [self setNeedsLayout];
}

#pragma mark --------- button action ------------

//- (void)userBtnAction:(id)sender
//{
//    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
//    UserImageView * imageView = (UserImageView *)tap.view;
//    if (self.tapUserBlock) {
//        self.tapUserBlock(imageView.user);
//    }
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userLabel.frame = CGRectMake(10., 5., kScreenWidth - 20., 30.);
    
//    self.userScrollView.frame = IS_IPHONE?CGRectMake(10., 45., kScreenWidth - 20., 80.):CGRectMake(10., 45., kScreenWidth  - kTabBarWidth - 20., 80.);
//    self.userScrollView.layer.cornerRadius = 4;
//    self.userScrollView.layer.masksToBounds = YES;
    
    self.moreBtn.frame = CGRectMake(0., 0., 40., 30.);
    self.moreBtn.center  = self.userLabel.center;
    self.moreBtn.deFrameRight = self.deFrameRight - 10.;
    
    
    self.userCarousel.deFrameTop = self.userLabel.deFrameBottom + 10.;
//    self.moreBtn.deFrameRight = self.userScrollView.deFrameRight;
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
#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.users.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
//    if (!view) {
//        UserReuserView * cell = [[UserReuserView alloc] initWithFrame:CGRectMake(0., 0., 68., 80.)];
////        GKUser * user =
//    }  else {
//        UserReuserView * cell  = (UserReuserView *)view;
//    }
    UserReuserView * cell  = (UserReuserView *)view;
    if (!cell) {
        cell = [[UserReuserView alloc] initWithFrame:CGRectZero];
    }
    cell.deFrameSize = CGSizeMake(68., 80.);
    GKUser * user = [self.users objectAtIndex:index];
    cell.user = user;
    return cell;

}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.userCarousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark - <iCarouselDelegate>
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    GKUser * user = [self.users objectAtIndex:index];
    
    if (self.tapUserBlock) {
        self.tapUserBlock(user);
    }
}

@end

@implementation UserReuserView

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView                     = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.deFrameSize         = CGSizeMake(50., 50.);
        _avatarImageView.layer.cornerRadius  = _avatarImageView.deFrameHeight / 2.;
        _avatarImageView.layer.masksToBounds = YES;
        
        [self addSubview:_avatarImageView];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel                          = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.deFrameSize              = CGSizeMake(50., 10.);
        _nameLabel.font                     = [UIFont boldSystemFontOfSize:10.];
        _nameLabel.textColor                = [UIColor colorFromHexString:@"#414243"];
        _nameLabel.lineBreakMode            = NSLineBreakByWordWrapping;
        _nameLabel.textAlignment            = NSTextAlignmentCenter;
        
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (void)setUser:(GKUser *)user
{
    _user   = user;
    
    self.nameLabel.text = _user.nick;
    [self.avatarImageView sd_setImageWithURL:_user.avatarURL
                            placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.avatarImageView.deFrameSize] options:SDWebImageRetryFailed];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarImageView.deFrameLeft    = (self.deFrameWidth - self.avatarImageView.deFrameWidth) / 2.;
    self.nameLabel.center               = self.avatarImageView.center;
    self.nameLabel.deFrameTop           = self.avatarImageView.deFrameBottom + 8.;
    
}

@end

