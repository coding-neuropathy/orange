//
//  NewUserHeaderView.m
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "NewUserHeaderView.h"

@interface NewUserHeaderView ()

/** 用户头像 */
@property (strong, nonatomic) UIImageView * avatarView;
/** 用户昵称 */
@property (strong, nonatomic) RTLabel * nicknameLabel;
/** 个人签名 */
@property (strong, nonatomic) UILabel * bioLabel;
/** 签名背景 */
@property (nonatomic, strong) UIView * bioBackView;

/** 关注 */
@property (strong, nonatomic) UIButton * friendBtn;
/** 粉丝 */
@property (strong, nonatomic) UIButton * fansBtn;
@property (strong, nonatomic) UIView * v;
@property (strong, nonatomic) UIButton * relationBtn;
@property (strong, nonatomic) UIButton * blockBtn;
@property (strong, nonatomic) UIButton * editBtn;

/** 身份标记 */
//@property (nonatomic , strong)UIImageView * staffImage;

@end

@implementation NewUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
    }
    return self;
}

//- (UIImageView *)staffImage
//{
//    if (!_staffImage) {
//        _staffImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self addSubview:_staffImage];
//    }
//    return _staffImage;
//}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (IS_IPHONE) {
            _avatarView.frame = CGRectMake(0., 0., 80., 80.);
        } else {
            _avatarView.frame = CGRectMake(0., 0., 120., 120.);
        }
        
        _avatarView.layer.cornerRadius = _avatarView.deFrameWidth / 2.;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_avatarView];
    }
    return _avatarView;
}

- (RTLabel *)nicknameLabel
{
    if (!_nicknameLabel) {
        _nicknameLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
//        _nicknameLabel.backgroundColor = [UIColor yellowColor];
        _nicknameLabel.paragraphReplacement = @"";
        _nicknameLabel.lineSpacing = 7.;
        //        _nicknameLabel.textColor = UIColorFromRGB(0x414243);
        _nicknameLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18.];
        //        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nicknameLabel];
    }
    return _nicknameLabel;
}

- (UIView *)bioBackView
{
    if (!_bioBackView) {
        _bioBackView = [[UIView alloc]initWithFrame:CGRectZero];
        _bioBackView.backgroundColor = UIColorFromRGB(0xfafafa);
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, 1.)];
        line.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [_bioBackView addSubview:line];
        _bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., kScreenWidth - 15., 40.)];
        _bioLabel.font = [UIFont systemFontOfSize:14.];
        _bioLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        _bioLabel.textColor = UIColorFromRGB(0x757575);
        _bioLabel.textAlignment = NSTextAlignmentLeft;
        _bioLabel.numberOfLines = 3;
        
        _bioLabel.backgroundColor = [UIColor clearColor];
        [self.bioBackView addSubview:_bioLabel];
        [self addSubview:_bioBackView];
    }
    return _bioBackView;
}

- (UIView *)v
{
    if (!_v) {
        _v = [[UIView alloc] initWithFrame:CGRectZero];
        _v.backgroundColor = UIColorFromRGB(0xebebeb);
        [self addSubview:_v];
    }
    return _v;
}

- (UIButton *)friendBtn
{
    if (!_friendBtn) {
        _friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _friendBtn.backgroundColor = [UIColor redColor];
        _friendBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_friendBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
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
        _fansBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_fansBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
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

- (void)setUser:(GKUser *)user
{
    _user = user;
    [self.avatarView sd_setImageWithURL:_user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(self.avatarView.deFrameWidth, self.deFrameWidth)]];
    
    if ([_user.gender isEqualToString:@"M"]) {
        //        self.nicknameLabel.text = [NSString stringWithFormat:@"<b size='18' color='^414243'>   %@</b> <font face='FontAwesome' color='^8cb4ff'>%@</font>", _user.nickname, [NSString fontAwesom             eIconStringForEnum:FAmars]];
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nick];
//        self.staffImage.image = [UIImage imageNamed:@"user_icon_male"];
    } else if ([_user.gender isEqualToString:@"F"]) {
        //        self.nicknameLabel.text = [NSString stringWithFormat:@"<b size='18' color='^414243'>   %@</b> <font face='FontAwesome' color='^ffb9c1'>%@</font>", _user.nickname, [NSString fontAwesomeIconStringForEnum:FAvenus]];
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nick];
//        self.staffImage.image = [UIImage imageNamed:@"user_icon_famale"];
    }
    else {
        self.nicknameLabel.text = [NSString stringWithFormat:@"<b size='18' color='^414243'>%@</b>", _user.nick];
    }
    if (_user.authorized_author == YES) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nick];
//        self.staffImage.image = [UIImage imageNamed:@"official"];
    }
    _bioLabel.text = _user.bio;
    
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarView.center = CGPointMake(self.frame.size.width / 2, 25+32.);
    self.avatarView.deFrameTop = self.deFrameTop + 20.;
    self.avatarView.deFrameLeft = self.deFrameLeft + 24.;
    
    
    self.nicknameLabel.frame = CGRectMake(0., 0.,self.nicknameLabel.optimumSize.width + 20., 30.);
    self.nicknameLabel.deFrameTop = self.avatarView.deFrameTop;
    self.nicknameLabel.deFrameLeft = self.avatarView.deFrameRight + 24.;
    
//    self.staffImage.frame = CGRectMake(0., 0., 14., 14.);
//    self.staffImage.deFrameTop = self.nicknameLabel.deFrameTop + 6;
//    self.staffImage.deFrameLeft = self.nicknameLabel.deFrameRight - 14;
    self.bioBackView.frame = CGRectMake(0., 0., kScreenWidth, 60.);
    self.bioBackView.deFrameLeft = self.deFrameLeft;
    self.bioBackView.deFrameBottom = self.deFrameBottom;
    
    
//    CGSize size = [_bioLabel sizeThatFits:CGSizeMake(kScreenWidth * 0.8, MAXFLOAT)];
//    self.bioLabel.frame = CGRectMake(0., 0., kScreenWidth * 0.8, size.height);
//    bioLabelHeight = size.height;
    
//    self.bioLabel.center = self.nicknameLabel.center;
//    self.bioLabel.deFrameTop = self.nicknameLabel.deFrameBottom;
    
//    self.friendBtn.frame = CGRectMake(0., 0.,100., 20.);
    self.friendBtn.deFrameLeft   = self.nicknameLabel.deFrameLeft;
    
//    self.fansBtn.frame = CGRectMake(0., 0.,100., 20.);
    self.fansBtn.deFrameLeft     = self.friendBtn.deFrameRight + 43;
    
    if (_user.userId == [Passport sharedInstance].user.userId) {
        self.editBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.editBtn.deFrameLeft = self.avatarView.deFrameRight + 24.;
        self.editBtn.deFrameTop = self.nicknameLabel.deFrameBottom + 5.;
//        self.v.frame = CGRectMake(0., 0., 1, 15.);
//        self.v.center = CGPointMake(self.editBtn.center.x, self.editBtn.center.y + 40.);
        self.friendBtn.deFrameTop = self.editBtn.deFrameBottom + 16.;
        self.fansBtn.deFrameTop   = self.editBtn.deFrameBottom + 16.;
    } else if (_user.user_state == GKUserBlockState) {
        self.blockBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.blockBtn.deFrameLeft = self.avatarView.deFrameRight + 24.;
        self.blockBtn.deFrameTop = self.nicknameLabel.deFrameBottom + 5.;
//        self.v.frame = CGRectMake(0., 0., 1, 15.);
//        self.v.center = CGPointMake(self.blockBtn.center.x, self.blockBtn.center.y + 40.);
        self.fansBtn.deFrameTop   = self.blockBtn.deFrameBottom + 16.;
        self.friendBtn.deFrameTop = self.blockBtn.deFrameBottom + 16.;
    } else {
        self.relationBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.relationBtn.deFrameLeft = self.avatarView.deFrameRight + 24.;
        self.relationBtn.deFrameTop = self.nicknameLabel.deFrameBottom + 5.;
//        self.v.frame = CGRectMake(0., 0., 1, 15.);
//        self.v.center = CGPointMake(self.relationBtn.center.x, self.relationBtn.center.y + 40.);
        self.fansBtn.deFrameTop   = self.relationBtn.deFrameBottom + 16.;
        self.friendBtn.deFrameTop = self.relationBtn.deFrameBottom + 16.;
    }
    
    self.v.frame = CGRectMake(CGRectGetMaxX(self.friendBtn.frame) + 20, self.friendBtn.frame.origin.y + 7, 1., 15.);
    
    [self relationBtn];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - button action
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

@end