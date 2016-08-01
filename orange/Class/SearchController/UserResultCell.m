//
//  UserResultCell.m
//  orange
//
//  Created by D_Collin on 16/7/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UserResultCell.h"
#import "LoginView.h"

@interface UserResultCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * nickLabel;
@property (strong, nonatomic) UILabel * followingTip;
@property (strong, nonatomic) UILabel * fansTip;

@property (strong, nonatomic) UIButton * relationBtn;

@end

@implementation UserResultCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

#pragma mark - init subview;
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.font = [UIFont systemFontOfSize:14.];
        _nickLabel.textColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:.87];
        [self.contentView addSubview:_nickLabel];
    }
    return _nickLabel;
}

- (UILabel *)followingTip
{
    if (!_followingTip) {
        _followingTip = [[UILabel alloc] initWithFrame:CGRectZero];
        _followingTip.font = [UIFont systemFontOfSize:14.];
        _followingTip.textColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:.54];
        _followingTip.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_followingTip];
    }
    return _followingTip;
}

- (UILabel *)fansTip
{
    if (!_fansTip) {
        _fansTip = [[UILabel alloc] initWithFrame:CGRectZero];
        _fansTip.font = [UIFont systemFontOfSize:14.];
        _fansTip.textColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:.54];
        _fansTip.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_fansTip];
    }
    return _fansTip;
}

- (UIButton *)relationBtn
{
    if (!_relationBtn) {
        _relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _relationBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        _relationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        button.center = CGPointMake(kScreenWidth - 40, 37)
        _relationBtn.layer.cornerRadius = 4;
        _relationBtn.hidden = YES;
        _relationBtn.layer.borderWidth = 1.0;
        _relationBtn.layer.borderColor = UIColorFromRGB(0x6192ff).CGColor;
        
        [self addSubview:_relationBtn];
        
    }
    
    return _relationBtn;
}

-(void)configRelationButton
{
    for (id target in [self.relationBtn allTargets])
    {
        [self.relationBtn removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
    self.relationBtn.hidden = NO;
    if (self.user.relation == GKUserRelationTypeNone) {
        [self.relationBtn setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAPlus]] forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.relationBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [self.relationBtn addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFan) {
        [self.relationBtn setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAPlus]]  forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.relationBtn setTitleColor:UIColorFromRGB(0x6192ff) forState:UIControlStateNormal];
        [self.relationBtn addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFollowing) {
        [self.relationBtn setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FACheck]]  forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6192ff)];
        [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.relationBtn addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeBoth) {
        [self.relationBtn setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAExchange]]  forState:UIControlStateNormal];
        [self.relationBtn setBackgroundColor:UIColorFromRGB(0x6192ff)];
        [self.relationBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.relationBtn addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeSelf) {
        self.relationBtn.hidden = YES;
    }
    
    [self.contentView bringSubviewToFront:self.relationBtn];
}

#pragma mark - set user data
- (void)setUser:(GKUser *)user
{
    if (_user) {
        [self removeObserver];
    }
    _user = user;
    
    [self addObserver];
    
    [self.imageView sd_setImageWithURL:_user.avatarURL
                      placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(36., 36.)]];
    
    self.nickLabel.text = _user.nickname;
    
    self.followingTip.text = [NSString stringWithFormat:@"%@ %ld",
                             NSLocalizedStringFromTable(@"following", kLocalizedFile, nil), _user.followingCount];
    
    self.fansTip.text = [NSString stringWithFormat:@"%@ %ld",
                         NSLocalizedStringFromTable(@"followers", kLocalizedFile, nil), _user.fanCount];
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0., 0., 36., 36.);
    self.imageView.layer.cornerRadius = self.imageView.deFrameWidth / 2.;
    self.imageView.deFrameTop = 10.;
    self.imageView.deFrameLeft = 10.;
    
    self.nickLabel.frame = CGRectMake(0., 0., 210., 20.);
    self.nickLabel.deFrameLeft = self.imageView.deFrameRight + 12.;
    self.nickLabel.deFrameTop = 8.;
    
    CGFloat followingWidth = [self.followingTip.text widthWithLineWidth:0. Font:self.followingTip.font];
    self.followingTip.frame = CGRectMake(0., 0., followingWidth, 20.);
    self.followingTip.deFrameLeft = self.nickLabel.deFrameLeft;
    self.followingTip.deFrameBottom = self.contentView.deFrameBottom - 14.;
    
    CGFloat fansWidth = [self.fansTip.text widthWithLineWidth:0. Font:self.fansTip.font];
    self.fansTip.frame = CGRectMake(0., 0., fansWidth, 20.);
    self.fansTip.center = self.followingTip.center;
    self.fansTip.deFrameLeft = self.followingTip.deFrameRight + 20.;
    
    self.relationBtn.frame = CGRectMake(0., 0., 24., 24.);
//    self.relationBtn.center = self.contentView.center;
    self.relationBtn.deFrameTop = 10.;
    self.relationBtn.deFrameRight = self.contentView.deFrameWidth - 10.;
//    self.relationBtn.center = IS_IPHONE?CGPointMake(kScreenWidth - 40, 37):CGPointMake(kScreenWidth - kTabBarWidth - 40, 37);
    [self configRelationButton];
    
    [super layoutSubviews];
}


#pragma mark -
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

#pragma mark - button action
#pragma mark - button action;
- (void)followButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        
        return;
    }
    [API followUserId:self.user.userId state:YES success:^(GKUserRelationType relation) {
        self.user.relation = relation;
        [self configRelationButton];
        [SVProgressHUD showImage:nil status:@"关注成功"];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"关注失败"];
    }];
}

- (void)unfollowButtonAction
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定取消关注？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.delegate = self;
//    alertView.tag = 20001;
//    [alertView show];
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"确定取消关注？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"confirm", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self unfollow];
    }];
    [ac addAction:cancelAction];
    [ac addAction:confirmAction];

    if (self.tapRelationAction) {
        self.tapRelationAction(ac);
    }
}

- (void)unfollow
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [API followUserId:self.user.userId state:NO success:^(GKUserRelationType relation) {
        self.user.relation = relation;
//        [self relationBtn];
//        [SVProgressHUD showImage:nil status:@"取关成功"];
        [self configRelationButton];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"取消关注失败"];
    }];
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
        [self configRelationButton];
    }
}

- (void)dealloc
{
    [self removeObserver];
}


@end
