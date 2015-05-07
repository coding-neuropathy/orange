//
//  UserSingleListCell.m
//  orange
//
//  Created by huiter on 15/1/28.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "UserSingleListCell.h"
#import "UserViewController.h"
#import "GKAPI.h"
#import "LoginView.h"

@implementation UserSingleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xebebeb);
        //[self.contentView addSubview:self.H];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setUser:(GKUser *)user
{
    _user = user;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (!self.avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 19.f, 36.f, 36.f)];
        [self.contentView addSubview:self.avatar];
        self.avatar.userInteractionEnabled = YES;
        self.avatar.layer.cornerRadius = 18;
        self.avatar.layer.masksToBounds = YES;
    }
    
    [self.avatar sd_setImageWithURL:self.user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60, 60)]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(avatarButtonAction)];
    [self.avatar addGestureRecognizer:tap];
    
    
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
        
    if(!self.label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 19, kScreenWidth - 70, 20)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 4.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
    }
    self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^414243' size=14>%@ </font></a>", self.user.userId, self.user.nickname];
    
    if(!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(60, 27, kScreenWidth - 70, 20)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 4.0;
        self.contentLabel.delegate = self;
        [self.contentView addSubview:self.contentLabel];
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=12>%@ %ld   %@ %ld</font>",
                              NSLocalizedStringFromTable(@"following", kLocalizedFile, nil),
                              self.user.followingCount,
                              NSLocalizedStringFromTable(@"followers", kLocalizedFile, nil),
                              self.user.fanCount];;
    
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.label.deFrameBottom;
    
    if (!self.followButton)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.center = CGPointMake(kScreenWidth - 40, 37);
        [self.contentView addSubview:button];
        self.followButton = button;
    }
    [self configFollowButton];
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
}

-(void)configFollowButton
{
    for (id target in [self.followButton allTargets]) {
        [self.followButton removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
    self.followButton.hidden = NO;
    if (self.user.relation == GKUserRelationTypeNone) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAPlus]] forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0x427ec0)];
        [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFan) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAPlus]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0x427ec0)];
        [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFollowing) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FACheck]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
        [self.followButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeBoth) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAExchange]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
        [self.followButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeSelf) {
        self.followButton.hidden = YES;
    }
}
- (void)followButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [GKAPI followUserId:self.user.userId state:YES success:^(GKUserRelationType relation) {
        self.user.relation = relation;
        [self configFollowButton];
        [SVProgressHUD showImage:nil status:@"关注成功"];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"关注失败"];
    }];
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
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [GKAPI followUserId:self.user.userId state:NO success:^(GKUserRelationType relation) {
        self.user.relation = relation;
        [self configFollowButton];
        //[SVProgressHUD showImage:nil status:@"取关成功"];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"取消关注失败"];
    }];
}


- (void)avatarButtonAction
{
    UserViewController * VC = [[UserViewController alloc]init];
    VC.user = self.user;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

+ (CGFloat)height
{
    return 74;
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

@end
