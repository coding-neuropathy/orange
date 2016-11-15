//
//  UserSingleListCell.m
//  orange
//
//  Created by huiter on 15/1/28.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "UserSingleListCell.h"
#import "RTLabel.h"
//#import "UserViewController.h"
//#import "API.h"
//#import "LoginView.h"

@interface UserSingleListCell ()

@property (strong, nonatomic) UIButton      *blockBtn;

@property (nonatomic, strong) UIImageView   *avatar;
@property (nonatomic, strong) RTLabel       *label;
@property (nonatomic, strong) RTLabel       *contentLabel;
@property (nonatomic, strong) UIButton      *followButton;
//@property (nonatomic, strong) UIView *H;

@end

@implementation UserSingleListCell

#pragma mark - class method
+ (CGFloat)height
{
    return 74;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (UIButton *)blockBtn
{
    if (!_blockBtn) {
        _blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _blockBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        _blockBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _blockBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [_blockBtn setTitle:[NSString fontAwesomeIconStringForEnum:FATimes] forState:UIControlStateNormal];
        [_blockBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        _blockBtn.hidden = YES;
        _blockBtn.layer.cornerRadius = 4.;
        [self.contentView addSubview:_blockBtn];
    }
    return _blockBtn;
}

- (UIButton *)followButton
{
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        _followButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.center = CGPointMake(kScreenWidth - 40, 37)
        _followButton.layer.cornerRadius = 4;
        _followButton.hidden = YES;
        _followButton.layer.borderWidth = 1.0;
        _followButton.layer.borderColor = UIColorFromRGB(0x6192ff).CGColor;
        [self.contentView addSubview:_followButton];
    }
    return _followButton;
}


- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar                         = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatar.deFrameSize             = CGSizeMake(36., 36.);
        _avatar.userInteractionEnabled  = YES;
        _avatar.layer.cornerRadius      = _avatar.deFrameHeight / 2.;
        _avatar.layer.masksToBounds     = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(avatarButtonAction:)];
        [_avatar addGestureRecognizer:tap];
        
        [self.contentView addSubview:_avatar];
    }
    return _avatar;
}

- (RTLabel *)label
{
    if (!_label) {
        _label                  = [[RTLabel alloc] initWithFrame:CGRectZero];
        _label.font             = [UIFont boldSystemFontOfSize:14.];
        _label.lineBreakMode    = NSLineBreakByWordWrapping;
        //        self.label.paragraphReplacement = @"";
        _label.lineSpacing      = 1.;
        _label.delegate         = self;
        _label.textAlignment    = NSTextAlignmentLeft;
        [self.contentView addSubview:_label];
    }
    return _label;
}

- (RTLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel                       = [[RTLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.deFrameSize           = CGSizeMake(self.contentView.deFrameWidth - 70, 20);
        _contentLabel.paragraphReplacement  = @"";
        _contentLabel.lineSpacing           = 4.0;
        _contentLabel.delegate              = self;
        
        [self.contentView addSubview:self.contentLabel];
    }
    return _contentLabel;
}

#pragma mark - set data
- (void)setUser:(GKUser *)user
{
    if (_user) {
        [self removeObserver];
    }
    _user = user;
    
    [self addObserver];
    
    [self.avatar sd_setImageWithURL:self.user.avatarURL
                   placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:self.avatar.deFrameSize]];
    

    
    if (_user.user_state == GKUserBlockState) {
        self.followButton.hidden = YES;
        self.blockBtn.hidden = NO;
    } else {
        self.followButton.hidden = NO;
        self.blockBtn.hidden = YES;
    }
    
    if (_user.authorized_author == YES) {
//        self.label.text = [NSString stringWithFormat:@"%@",_user.nick];
        self.staffImageView.image = [UIImage imageNamed:@"official"];
    }
    else
    {
        self.staffImageView.image = [UIImage new];
    }
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^212121' size=14>%@ </font></a>",
                       (long)self.user.userId, self.user.nick];
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=12>%@ %ld   %@ %ld</font>",
                              NSLocalizedStringFromTable(@"following", kLocalizedFile, nil),
                              (long)self.user.followingCount,
                              NSLocalizedStringFromTable(@"followers", kLocalizedFile, nil),
                              (long)self.user.fanCount];;
    
    
    [self setNeedsLayout];
}

//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    self.avatar.deFrameTop  = 19.;
    self.avatar.deFrameLeft = 10.;
    
    if (!_staffImageView) {
        _staffImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0., 0., 15., 15.)];
        [self.contentView addSubview:_staffImageView];
    }
    self.staffImageView.deFrameTop = self.avatar.deFrameBottom - 10.;
    self.staffImageView.deFrameLeft = self.avatar.deFrameRight - 10.;
    
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;

    self.label.frame = CGRectMake(0., 0., kScreenWidth - 70, 20);
    self.label.deFrameTop = 19.;
    self.label.deFrameLeft = 60.;
    
    

    
    self.contentLabel.deFrameLeft   = 60.;
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop    = self.label.deFrameBottom;

    if (self.user.user_state == GKUserBlockState) {
        self.blockBtn.frame     = CGRectMake(0., 0., 40., 24.);
        self.blockBtn.center    = CGPointMake(self.contentView.deFrameWidth - 40., 37.);
//        self.blockBtn.center = IS_IPHONE ? CGPointMake(kScreenWidth - 40, 37) : CGPointMake(kScreenWidth - kTabBarWidth - 40, 37);
    } else {
        self.followButton.frame     = CGRectMake(0., 0., 24., 24.);
        self.followButton.center    = CGPointMake(self.contentView.deFrameWidth - 40., 37.);
//        self.followButton.center = IS_IPHONE?CGPointMake(kScreenWidth - 40, 37) : CGPointMake(kScreenWidth - kTabBarWidth - 40, 37);
        [self configFollowButton];
    }

}

-(void)configFollowButton
{
    for (id target in [self.followButton allTargets])
    {
        [self.followButton removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
    self.followButton.hidden = NO;
    if (self.user.relation == GKUserRelationTypeNone) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAPlus]] forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.followButton setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFan) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAPlus]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.followButton setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFollowing) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FACheck]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0x6192ff)];
        [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeBoth) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAExchange]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0x6192ff)];
        [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeSelf) {
        self.followButton.hidden = YES;
    }
    
    [self.contentView bringSubviewToFront:self.followButton];
}

#pragma mark - action
- (void)followAction
{
    [API followUserId:self.user.userId state:YES success:^(GKUserRelationType relation) {
        self.user.relation = relation;
        [self configFollowButton];
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"follow-success", kLocalizedFile, nil)];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"follow-failure", kLocalizedFile, nil)];
    }];
}

#pragma mark - button action;
- (void)followButtonAction
{
    if(!k_isLogin) {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self followAction];
        }];
    } else {
        [self followAction];
    }

}

- (void)unfollowButtonAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定取消关注？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 20001;
    [alertView show];
}

- (void)unfollow
{
    if(!k_isLogin) {
        [[OpenCenter sharedOpenCenter] openAuthPage];
    } else {
        [API followUserId:self.user.userId state:NO success:^(GKUserRelationType relation) {
            self.user.relation = relation;
            [self configFollowButton];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"unfollow-failure", kLocalizedFile, nil)];
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 60., self.frame.size.height - kSeparateLineWidth);
    CGContextAddLineToPoint(context, kScreenWidth, self.frame.size.height - kSeparateLineWidth);
    
    CGContextStrokePath(context);
}


#pragma mark - button action
- (void)avatarButtonAction:(id)sender
{
    //     [[OpenCenter sharedOpenCenter] openUser:self.user];
    if (self.TapAvatarAction) {
        self.TapAvatarAction(self.user);
    }
}


#pragma mark = <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==20001)
    {
        if(buttonIndex == 1)
        {
            [self unfollow];
        }
    }
}

#pragma mark - KVO
- (void)addObserver
{
    [self.user addObserver:self forKeyPath:@"relation" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.user removeObserver:self forKeyPath:@"relation"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"relation"]) {
        [self configFollowButton];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
