//
//  UserHeaderView.m
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

/**
 *  用户头像
 */
@property (strong, nonatomic) UIImageView * avatarView;

/**
 *  用户昵称 
 */
@property (strong, nonatomic) RTLabel * nicknameLabel;

/**
 *  个人签名 
 */
@property (strong, nonatomic) UILabel * bioLabel;

/** 
 *  签名背景 
 */
@property (nonatomic, strong) UIView * bioBackView;

/** 
 *  关注 
 */
@property (strong, nonatomic) UIButton * friendBtn;

/** 
 *  粉丝 
 */
@property (strong, nonatomic) UIButton * fansBtn;

/**
 *  用户关系
 */
@property (strong, nonatomic) UIView * v;
@property (strong, nonatomic) UIButton * relationBtn;
@property (strong, nonatomic) UIButton * blockBtn;
@property (strong, nonatomic) UIButton * editBtn;

/**
 *  seller
 */
@property (strong, nonatomic) UIButton * createOrderBtn;
@property (strong, nonatomic) UIButton * reviewOrderBtn;

/** 身份标记 */
//@property (nonatomic , strong)UIImageView * staffImage;

@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

#pragma mark - lazy load subview
- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView                     = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarView.deFrameSize         = IS_IPAD ? CGSizeMake(120., 120.) : CGSizeMake(80., 80.);
        _avatarView.layer.cornerRadius  = _avatarView.deFrameWidth / 2.;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.contentMode         = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_avatarView];
    }
    return _avatarView;
}

- (RTLabel *)nicknameLabel
{
    if (!_nicknameLabel) {
        _nicknameLabel                  = [[RTLabel alloc] initWithFrame:CGRectZero];
//        _nicknameLabel.backgroundColor = [UIColor yellowColor];
        _nicknameLabel.paragraphReplacement = @"";
        _nicknameLabel.lineSpacing = 7.;
        //        _nicknameLabel.textColor = UIColorFromRGB(0x212121);
        _nicknameLabel.font             = [UIFont fontWithName:kFontAwesomeFamilyName size:18.];
        //        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nicknameLabel];
    }
    return _nicknameLabel;
}

- (UILabel *)bioLabel
{
    if (!_bioLabel) {
        _bioLabel                       = [[UILabel alloc] initWithFrame:CGRectZero];
        _bioLabel.font                  = [UIFont fontWithName:@"PingFangSC-Regular" size:16.];
        _bioLabel.textColor             = [UIColor colorFromHexString:@"#9d9e9f"];
        _bioLabel.textAlignment         = NSTextAlignmentCenter;
        _bioLabel.backgroundColor       = [UIColor clearColor];
        
        [self addSubview:_bioLabel];
    }
    return _bioLabel;
}

- (UIView *)bioBackView
{
    if (!_bioBackView) {
        _bioBackView                    = [[UIView alloc]initWithFrame:CGRectZero];
        _bioBackView.backgroundColor    = [UIColor colorFromHexString:@"#fafafa"];
        UIView * line                   = [[UIView alloc]initWithFrame:CGRectMake(0., 0., self.deFrameWidth, 1.)];
        line.backgroundColor            = [UIColor colorFromHexString:@"#f1f1f1"];
        [_bioBackView addSubview:line];
        
        _bioLabel                       = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., self.deFrameWidth - 15., 40.)];
        _bioLabel.font                  = [UIFont systemFontOfSize:14.];
        _bioLabel.lineBreakMode         = NSLineBreakByWordWrapping;
        
        _bioLabel.textColor = UIColorFromRGB(0x757575);
        _bioLabel.textAlignment = NSTextAlignmentLeft;
        _bioLabel.numberOfLines = 3;
        
        _bioLabel.backgroundColor = [UIColor clearColor];
        [self.bioBackView addSubview:_bioLabel];
        [self addSubview:_bioBackView];
    }
    return _bioBackView;
}

//- (UIView *)v
//{
//    if (!_v) {
//        _v = [[UIView alloc] initWithFrame:CGRectZero];
//        _v.backgroundColor = UIColorFromRGB(0xebebeb);
//        [self addSubview:_v];
//    }
//    return _v;
//}

- (UIButton *)friendBtn
{
    if (!_friendBtn) {
        _friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _friendBtn.backgroundColor = [UIColor redColor];
        _friendBtn.titleLabel.font = IS_IPHONE_5 || IS_IPHONE_4_OR_LESS ? [UIFont systemFontOfSize:12.] : [UIFont systemFontOfSize:14.];
        [_friendBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [_friendBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_friendBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 20.)];
        [_friendBtn addTarget:self action:@selector(friendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_friendBtn];
    }
    return _friendBtn;
}

- (UIButton *)fansBtn
{
    if (!_fansBtn) {
        _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _fansBtn.backgroundColor = [UIColor greenColor];
        _fansBtn.titleLabel.font = IS_IPHONE_5 || IS_IPHONE_4_OR_LESS ? [UIFont systemFontOfSize:12.] : [UIFont systemFontOfSize:14.];
        [_fansBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [_fansBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_fansBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 20., 0., 0.)];
        [_fansBtn addTarget:self action:@selector(fansBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_fansBtn];
    }
    return _fansBtn;
}

- (UIButton *)relationBtn
{
    if (!_relationBtn) {
        _relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _relationBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
        //        _relationBtn.
        _relationBtn.layer.masksToBounds = YES;
        _relationBtn.layer.cornerRadius = 4.;
       [_relationBtn.layer setBorderWidth:1.0];
        _relationBtn.layer.borderColor=UIColorFromRGB(0x6192ff).CGColor;
        _relationBtn.hidden = YES;
        [self addSubview:_relationBtn];
    }
    return _relationBtn;
}

- (UIButton *)blockBtn
{
    if (!_blockBtn) {
        _blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _blockBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
        [_blockBtn setTitle:[NSString stringWithFormat:@"%@ 该用户已被禁言",[NSString fontAwesomeIconStringForEnum:FATimes]] forState:UIControlStateNormal];
        [_blockBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        
        _blockBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _blockBtn.layer.masksToBounds = YES;
        _blockBtn.layer.cornerRadius = 4.;
        _blockBtn.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _blockBtn.hidden = YES;
        
        [self addSubview:_blockBtn];
    }
    return _blockBtn;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
        [_editBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [_editBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"edit your profile", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_editBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 4.;
        [_editBtn.layer setBorderWidth:1.0];
        _editBtn.layer.borderColor=UIColorFromRGB(0x6192ff).CGColor;
        _editBtn.hidden = YES;
        [_editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editBtn];
    }
    return _editBtn;
}

/**
 *  seller components
 */
- (UIButton *)createOrderBtn
{
    if (!_createOrderBtn) {
        _createOrderBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _createOrderBtn.deFrameSize         = CGSizeMake(kScreenWidth / 2., 49.);
        NSString * titleString              = [NSString stringWithFormat:@"%@ %@",
                                                        [NSString fontAwesomeIconStringForEnum:FAPlusSquareO],
                                                        NSLocalizedStringFromTable(@"create-order", kLocalizedFile, nil)];
        [_createOrderBtn setTitle:titleString forState:UIControlStateNormal];
//        _createOrderBtn.titleLabel.textColor = UIColorFromRGB(0x212121);
        [_createOrderBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        _createOrderBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];;
//        [_createOrderBtn setBackgroundColor:[UIColor redColor]];
        
        [_createOrderBtn addTarget:self action:@selector(createOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_createOrderBtn];
    }
    return _createOrderBtn;
}

- (UIButton *)reviewOrderBtn
{
    if (!_reviewOrderBtn) {
        _reviewOrderBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _reviewOrderBtn.deFrameSize         = CGSizeMake(kScreenWidth / 2., 49.);
        NSString * titleString              = [NSString stringWithFormat:@"%@ %@",
                                                        [NSString fontAwesomeIconStringForEnum:FAFileTextO],
                                                        NSLocalizedStringFromTable(@"review-order", kLocalizedFile, nil)];
        [_reviewOrderBtn setTitle:titleString forState:UIControlStateNormal];
        [_reviewOrderBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        _reviewOrderBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];;
        
        [_reviewOrderBtn addTarget:self action:@selector(reviewOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reviewOrderBtn];
    }
    return _reviewOrderBtn;
}


#pragma mark - set user data
- (void)setUser:(GKUser *)user
{
    _user = user;
    [self.avatarView sd_setImageWithURL:_user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(self.avatarView.deFrameWidth, self.deFrameWidth)]];
    
    if ([_user.gender isEqualToString:@"M"]) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nick];
    } else if ([_user.gender isEqualToString:@"F"]) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nick];
    }
    else {
        self.nicknameLabel.text = [NSString stringWithFormat:@"<b size='18' color='^212121'>%@</b>", _user.nick];
    }
    if (_user.authorized_author == YES) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@", _user.nick];
//        self.staffImage.image = [UIImage imageNamed:@"official"];
    }
    self.bioLabel.text = _user.bio;
    
    if(!_user.bio.length)
    {
        [self.bioBackView removeFromSuperview];
    }
    
    {
        NSString * str = [NSString stringWithFormat:@"%@ %ld",NSLocalizedStringFromTable(@"followers", kLocalizedFile, nil), (long)_user.fanCount];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange positionRange = [str rangeOfString:[NSString stringWithFormat:@"%ld",(long)_user.fanCount]];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9d9e9f) range:positionRange];
        
        [self.fansBtn setAttributedTitle:mutableStr forState:UIControlStateNormal];
        [self.fansBtn sizeToFit];
    }
    {
        
        NSString * str = [NSString stringWithFormat:@"%@ %ld",NSLocalizedStringFromTable(@"following", kLocalizedFile, nil), (long)_user.followingCount];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange positionRange = [str rangeOfString:[NSString stringWithFormat:@"%ld",(long)_user.followingCount]];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9d9e9f) range:positionRange];
//        [mutableStr add]
        [self.friendBtn setAttributedTitle:mutableStr forState:UIControlStateNormal];
        [self.friendBtn sizeToFit];
    }
    
    
    if (_user.userId == [Passport sharedInstance].user.userId) {
        self.editBtn.hidden = NO;
        self.blockBtn.hidden = YES;
        self.relationBtn.hidden = YES;
        
    } else if (_user.user_state == GKUserBlockState) {
        self.editBtn.hidden = YES;
        self.relationBtn.hidden = YES;
        self.blockBtn.hidden = NO;
    } else {
        self.editBtn.hidden = YES;
        self.blockBtn.hidden = YES;
        self.relationBtn.hidden = NO;
        
        for (id target in [self.relationBtn allTargets]) {
            [self.relationBtn removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
        }
        
        switch (_user.relation) {
            case GKUserRelationTypeNone:
            {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAPlus], NSLocalizedStringFromTable(@"follow", kLocalizedFile, nil)] forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeFan:
            {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAPlus], NSLocalizedStringFromTable(@"follow", kLocalizedFile, nil)]  forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6192ff)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeFollowing:
            {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FACheck], NSLocalizedStringFromTable(@"following", kLocalizedFile, nil)]  forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6192ff)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeBoth: {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ 互相关注",[NSString fontAwesomeIconStringForEnum:FAExchange]]  forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6192ff)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeSelf:
            {
                
            }
                break;
            default:
                break;
        }
    }
    
    [self setNeedsLayout];
}


#pragma mark - layout subviews
- (void)layoutOrderButton
{
    if ([self.user.bio length] > 0) {
        self.createOrderBtn.deFrameBottom       = self.bioBackView.deFrameTop;
        self.reviewOrderBtn.center              = self.createOrderBtn.center;
        self.reviewOrderBtn.deFrameLeft         = self.createOrderBtn.deFrameRight;
    } else {
        self.createOrderBtn.deFrameBottom       = self.deFrameBottom;
        
        self.reviewOrderBtn.center              = self.createOrderBtn.center;
        self.reviewOrderBtn.deFrameLeft         = self.createOrderBtn.deFrameRight;
    }
}

- (void)layoutiPhoneSubViews
{
    self.avatarView.center = CGPointMake(self.frame.size.width / 2, 25+32.);
    self.avatarView.deFrameTop = self.deFrameTop + 20.;
    self.avatarView.deFrameLeft = self.deFrameLeft + 24.;
    
    
    self.nicknameLabel.frame = CGRectMake(0., 0.,self.nicknameLabel.optimumSize.width + 20., 30.);
    self.nicknameLabel.deFrameTop = self.avatarView.deFrameTop;
    self.nicknameLabel.deFrameLeft = self.avatarView.deFrameRight + 24.;
    
    self.bioBackView.frame = CGRectMake(0., 0., self.deFrameWidth, 60.);
    self.bioBackView.deFrameLeft = self.deFrameLeft;
    self.bioBackView.deFrameBottom = self.deFrameBottom;
    
    if (IS_IPHONE && self.user.userId == [Passport sharedInstance].user.userId) [self layoutOrderButton];
    
    self.friendBtn.deFrameLeft          = self.nicknameLabel.deFrameLeft;
    self.fansBtn.deFrameLeft           = self.friendBtn.deFrameRight + 30.;
    
    if (_user.userId == [Passport sharedInstance].user.userId) {
        self.editBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.editBtn.deFrameLeft = self.avatarView.deFrameRight + 24.;
        self.editBtn.deFrameTop = self.nicknameLabel.deFrameBottom + 5.;
        self.friendBtn.deFrameTop = self.editBtn.deFrameBottom + 16.;
        self.fansBtn.deFrameTop   = self.editBtn.deFrameBottom + 16.;
    } else if (_user.user_state == GKUserBlockState) {
        self.blockBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.blockBtn.deFrameLeft = self.avatarView.deFrameRight + 24.;
        self.blockBtn.deFrameTop = self.nicknameLabel.deFrameBottom + 5.;
        self.fansBtn.deFrameTop   = self.blockBtn.deFrameBottom + 16.;
        self.friendBtn.deFrameTop = self.blockBtn.deFrameBottom + 16.;
    } else {
        self.relationBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.relationBtn.deFrameLeft = self.avatarView.deFrameRight + 24.;
        self.relationBtn.deFrameTop = self.nicknameLabel.deFrameBottom + 5.;
        self.fansBtn.deFrameTop   = self.relationBtn.deFrameBottom + 16.;
        self.friendBtn.deFrameTop = self.relationBtn.deFrameBottom + 16.;
    }
}

- (void)layoutSubviews
{
    [self layoutiPhoneSubViews];
    
//    self.v.frame = CGRectMake(CGRectGetMaxX(self.friendBtn.frame) + 20, self.friendBtn.frame.origin.y + 7, 1., 15.);
    
    [super layoutSubviews];

//    [self relationBtn];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (IS_IPHONE && self.user.userId == [Passport sharedInstance].user.userId) {
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
        CGContextSetLineWidth(context, kSeparateLineWidth);
        CGContextMoveToPoint(context, 0., self.createOrderBtn.deFrameTop);
        CGContextAddLineToPoint(context, self.deFrameWidth, self.createOrderBtn.deFrameTop);
    
        CGContextMoveToPoint(context, self.createOrderBtn.deFrameRight, self.createOrderBtn.deFrameTop);
        CGContextAddLineToPoint(context, self.createOrderBtn.deFrameRight, self.createOrderBtn.deFrameBottom);

        CGContextStrokePath(context);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGFloat xPoint = self.friendBtn.deFrameRight + (self.fansBtn.deFrameLeft - self.friendBtn.deFrameRight) / 2.;
    
    CGContextMoveToPoint(context, xPoint, self.friendBtn.deFrameTop + 3);
    CGContextAddLineToPoint(context, xPoint, self.friendBtn.deFrameBottom - 3);

    CGContextStrokePath(context);
}

#pragma mark button action
- (void)friendBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapFriendBtnWithUser:)]) {
        [_delegate TapFriendBtnWithUser:self.user];
    }
}

- (void)fansBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapFansBtnWithUser:)]) {
        [_delegate TapFansBtnWithUser:self.user];
    }
}

- (void)editBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapEditBtnWithUser:)]) {
        [_delegate TapEditBtnWithUser:self.user];
    }
}


//#pragma mark - button action
- (void)followButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapFollowBtnWithUser:View:)]) {
        [_delegate TapFollowBtnWithUser:self.user View:self];
    }
}

- (void)unfollowButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapUnFollowBtnWithUser:View:)])
    {
        [_delegate TapUnFollowBtnWithUser:self.user View:self];
    }
}

/**
 *  seller button action
 */
- (void)createOrderAction:(id)sender
{
//    NSLog(@"create create");
    if (_delegate && [_delegate respondsToSelector:@selector(TapCreateOrder:)]) {
        [_delegate TapCreateOrder:sender];
    }
}

- (void)reviewOrderAction:(id)sender
{
//    NSLog(@"review review");
    if (_delegate && [_delegate respondsToSelector:@selector(TapReviewOrder:)]) {
        [_delegate TapReviewOrder:sender];
    }
}

@end
