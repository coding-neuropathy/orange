//
//  UserHeaderView.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

/** 用户头像 */
@property (strong, nonatomic) UIImageView * avatarView;
/** 用户昵称 */
@property (strong, nonatomic) RTLabel * nicknameLabel;
/** 个人签名 */
@property (strong, nonatomic) UILabel * bioLabel;
/** 关注 */
@property (strong, nonatomic) UIButton * friendBtn;
/** 粉丝 */
@property (strong, nonatomic) UIButton * fansBtn;
@property (strong, nonatomic) UIView * v;
@property (strong, nonatomic) UIButton * relationBtn;
@property (strong, nonatomic) UIButton * blockBtn;
@property (strong, nonatomic) UIButton * editBtn;

/** 身份标记 */
@property (nonatomic , strong)UIImageView * staffImage;

@end

@implementation UserHeaderView

static CGFloat bioLabelHeight;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
    }
    return self;
}

- (UIImageView *)staffImage
{
    if (!_staffImage) {
        _staffImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_staffImage];
    }
    return _staffImage;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (IS_IPHONE) {
            _avatarView.frame = CGRectMake(0., 0., 64., 64.);
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
        _nicknameLabel.paragraphReplacement = @"";
        _nicknameLabel.lineSpacing = 7.;
//        _nicknameLabel.textColor = UIColorFromRGB(0x414243);
        _nicknameLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18.];
//        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nicknameLabel];
    }
    return _nicknameLabel;
}

- (UILabel *)bioLabel
{
    if (!_bioLabel) {
        _bioLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bioLabel.font = [UIFont systemFontOfSize:16.];
        _bioLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        _bioLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _bioLabel.textAlignment = NSTextAlignmentCenter;
        _bioLabel.numberOfLines = 3;
        
        _bioLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_bioLabel];
    }
    return _bioLabel;
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
        _friendBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_friendBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [_friendBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        //        _friendBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_friendBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 20.)];
        [_friendBtn addTarget:self action:@selector(friendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_friendBtn];
    }
    return _friendBtn;
}

- (UIButton *)fansBtn
{
    if (!_fansBtn) {
        _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansBtn.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_fansBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [_fansBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_fansBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 10., 0., 0.)];
        //        _fansBtn.titleLabel.textAlignment = NSTextAlignmentRight;
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
        [_editBtn setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
        [_editBtn setTitle:[NSString stringWithFormat:@"%@%@", [NSString fontAwesomeIconStringForEnum:FAPencilSquareO], NSLocalizedStringFromTable(@"edit your profile", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_editBtn setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 4.;
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
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nickname];
        self.staffImage.image = [UIImage imageNamed:@"user_icon_male"];
    } else if ([_user.gender isEqualToString:@"F"]) {
//        self.nicknameLabel.text = [NSString stringWithFormat:@"<b size='18' color='^414243'>   %@</b> <font face='FontAwesome' color='^ffb9c1'>%@</font>", _user.nickname, [NSString fontAwesomeIconStringForEnum:FAvenus]];
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nickname];
        self.staffImage.image = [UIImage imageNamed:@"user_icon_famale"];
    }
    else {
        self.nicknameLabel.text = [NSString stringWithFormat:@"<b size='18' color='^414243'>%@</b>", _user.nickname];
    }
    if (_user.authorized_author == YES) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",_user.nickname];
        self.staffImage.image = [UIImage imageNamed:@"official"];
    }
    _bioLabel.text = _user.bio;
    
    if(!_user.bio.length)
    {
        _bioLabel.text = @"暂无个人签名";
    }
    
    {
        NSString * str = [NSString stringWithFormat:@"%@ %ld",NSLocalizedStringFromTable(@"followers", kLocalizedFile, nil), (long)_user.fanCount];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange positionRange = [str rangeOfString:[NSString stringWithFormat:@"%ld",(long)_user.fanCount]];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9d9e9f) range:positionRange];
        [self.fansBtn setAttributedTitle:mutableStr forState:UIControlStateNormal];
    }
    {
        
        NSString * str = [NSString stringWithFormat:@"%@ %ld",NSLocalizedStringFromTable(@"following", kLocalizedFile, nil), (long)_user.followingCount];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange positionRange = [str rangeOfString:[NSString stringWithFormat:@"%ld",(long)_user.followingCount]];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9d9e9f) range:positionRange];
        [self.friendBtn setAttributedTitle:mutableStr forState:UIControlStateNormal];
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
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6eaaf0)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeFan:
            {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAPlus], NSLocalizedStringFromTable(@"follow", kLocalizedFile, nil)]  forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6eaaf0)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeFollowing:
            {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FACheck], NSLocalizedStringFromTable(@"following", kLocalizedFile, nil)]  forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
                [self.relationBtn addTarget:self action:@selector(unfollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case GKUserRelationTypeBoth: {
                [self.relationBtn setTitle:[NSString stringWithFormat:@"%@ 互相关注",[NSString fontAwesomeIconStringForEnum:FAExchange]]  forState:UIControlStateNormal];
                [self.relationBtn setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
                [self.relationBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
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
    
    self.nicknameLabel.frame = CGRectMake(0., 0., self.nicknameLabel.optimumSize.width + 20., 30.);
    self.nicknameLabel.center = self.avatarView.center;
    self.nicknameLabel.deFrameTop = self.avatarView.deFrameBottom + 16.;
    
    self.staffImage.frame = CGRectMake(0., 0., 18., 18.);
    self.staffImage.deFrameTop = self.nicknameLabel.deFrameTop + 4;
    self.staffImage.deFrameLeft = self.nicknameLabel.deFrameRight - 16;
    
    CGSize size = [_bioLabel sizeThatFits:CGSizeMake(kScreenWidth * 0.8, MAXFLOAT)];
    self.bioLabel.frame = CGRectMake(0., 0., kScreenWidth * 0.8, size.height);
    bioLabelHeight = size.height;

    self.bioLabel.center = self.nicknameLabel.center;
    self.bioLabel.deFrameTop = self.nicknameLabel.deFrameBottom;
    
    
    self.friendBtn.frame = CGRectMake((kScreenWidth) / 2 - 130., 0., 130., 20.);
    self.friendBtn.deFrameTop = self.bioLabel.deFrameBottom + 20.;
    
    self.fansBtn.frame = CGRectMake(0., 0., 130., 20.);
    self.fansBtn.center = self.friendBtn.center;
    self.fansBtn.deFrameLeft = self.friendBtn.deFrameRight + 20.;
    
    self.v.frame = CGRectMake(0., 0., 1, 15.);
    self.v.center = self.bioLabel.center;
    self.v.deFrameTop = self.fansBtn.deFrameTop + 2;
    
    if (_user.userId == [Passport sharedInstance].user.userId) {
        self.editBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.editBtn.center = self.bioLabel.center;
        self.editBtn.deFrameTop = self.fansBtn.deFrameBottom + 20.;
    } else if (_user.user_state == GKUserBlockState) {
        self.blockBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.blockBtn.center = self.bioLabel.center;
        self.blockBtn.deFrameTop = self.fansBtn.deFrameBottom + 20.;
    } else {
        self.relationBtn.frame = CGRectMake(0., 0., 130., 30.);
        self.relationBtn.center = self.bioLabel.center;
        self.relationBtn.deFrameTop = self.fansBtn.deFrameBottom + 20.;
    }
    
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
