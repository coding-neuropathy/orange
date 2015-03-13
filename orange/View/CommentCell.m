//
//  CommentCell.m
//  orange
//
//  Created by huiter on 15/2/1.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "CommentCell.h"
#import "UserViewController.h"


@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xeeeeee);
//        self.H.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.H];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setComment:(GKComment *)comment
{
    _comment = comment;
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
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 13.f, 36.f, 36.f)];
        [self.contentView addSubview:self.avatar];
        self.avatar.layer.cornerRadius = 18;
        self.avatar.userInteractionEnabled = YES;
        self.avatar.layer.masksToBounds = YES;
    }
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(avatarButtonAction)];
    [self.avatar addGestureRecognizer:tap];
    
    [self.avatar sd_setImageWithURL:self.comment.creator.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60, 60)]];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    
    
    
    if(!self.label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 70, 20)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 4.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
    }
    self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a>", self.comment.creator.userId, self.comment.creator.nickname];
    
    if(!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 70, 20)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 4.0;
        self.contentLabel.delegate = self;
        [self.contentView addSubview:self.contentLabel];
    }
    
    if (_comment.repliedUser) {
        
        [self.contentLabel setText: [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^777777' size=14> 回复了 </font><a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^999999' size=14>：%@</font>",_comment.creator.userId,_comment.creator.nickname,_comment.repliedUser.userId,_comment.repliedUser.nickname,_comment.text]];
        
    }
    else
    {
        [self.contentLabel setText:[NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^777777' size=14>：%@</font>",_comment.creator.userId,_comment.creator.nickname,_comment.text]];
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", self.comment.text];
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.label.deFrameBottom;
    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont systemFontOfSize:10];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }

        [self.timeButton setImage:nil forState:UIControlStateNormal];

    [self.timeButton setTitle:[NSString stringWithFormat:@"%@",[self.comment.createdDate stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.deFrameRight = kScreenWidth - 15;
    self.timeButton.deFrameBottom =  self.contentView.deFrameHeight -10;
    
    if (!self.replyButton) {
        _replyButton = [[UIButton alloc] init];
        self.replyButton.deFrameSize = CGSizeMake(44.f, 44.f);
        self.replyButton.backgroundColor = [UIColor clearColor];

        self.replyButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.replyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.replyButton setTitleColor:UIColorFromRGB(0xcacaca) forState:UIControlStateNormal];
        [self.replyButton setTitle:[NSString fontAwesomeIconStringForEnum:FAReply] forState:UIControlStateNormal];
        [self.replyButton addTarget:self action:@selector(replyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.replyButton];
    }
    self.replyButton.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - 8);
    self.replyButton.deFrameRight = CGRectGetWidth(self.contentView.bounds)-8;
    if (self.comment.creator == [Passport sharedInstance].user) {
        self.replyButton.hidden = YES;
    } else {
        self.replyButton.hidden = NO;
    }
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
}

+ (CGFloat)height:(GKComment *)comment
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 4.0;
    if (comment.repliedUser) {
        
        [label setText: [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^777777' size=14> 回复了 </font><a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^999999' size=14>：%@</font>",comment.creator.userId,comment.creator.nickname,comment.repliedUser.userId,comment.repliedUser.nickname,comment.text]];
        
    }
    else
    {
        [label setText:[NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^777777' size=14>：%@</font>",comment.creator.userId,comment.creator.nickname,comment.text]];
    }
    return label.optimumSize.height + 60.f;
}

- (void)avatarButtonAction
{
    UserViewController * VC = [[UserViewController alloc]init];
    VC.user = self.comment.creator;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

- (void)replyButtonAction
{
    if (self.tapReplyButtonBlock) {
        self.tapReplyButtonBlock(self.comment);
    }
}

@end
