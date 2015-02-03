//
//  NoteCell.m
//  orange
//
//  Created by huiter on 15/1/27.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "NoteCell.h"
#import "UserViewController.h"
#import "GKAPI.h"
#import "LoginView.h"
#import "NoteViewController.h"
@implementation NoteCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:self.H];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNote:(GKNote *)note
{
    _note = note;
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
    
    [self.avatar sd_setImageWithURL:self.note.creator.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60, 60)]];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    

    
    if(!self.label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 70, 20)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 4.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
    }
    self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a>", self.note.creator.userId, self.note.creator.nickname];
    
    if(!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 70, 20)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 4.0;
        self.contentLabel.delegate = self;
        [self.contentView addSubview:self.contentLabel];
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", self.note.text];
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.label.deFrameBottom;
    
    if (!self.pokeButton) {
        _pokeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        self.pokeButton.layer.masksToBounds = YES;
        self.pokeButton.layer.cornerRadius = 2;
        self.pokeButton.backgroundColor = [UIColor clearColor];
        self.pokeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.pokeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.pokeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.pokeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.pokeButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateSelected];
        /*
        [self.pokeButton setImage:[UIImage imageNamed:@"icon_poke"] forState:UIControlStateNormal];
        [self.pokeButton setImage:[UIImage imageNamed:@"icon_poke"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [self.pokeButton setImage:[UIImage imageNamed:@"icon_poke_press"] forState:UIControlStateSelected];
        [self.pokeButton setImage:[UIImage imageNamed:@"icon_poke_press"] forState:UIControlStateHighlighted|UIControlStateSelected];
         */
        [self.pokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [self.contentView addSubview:self.pokeButton];
    }
    self.pokeButton.selected = self.note.poked;
    [self.pokeButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp],self.note.pokeCount] forState:UIControlStateNormal];
    self.pokeButton.deFrameLeft = self.contentLabel.deFrameLeft;
    self.pokeButton.deFrameBottom = self.contentView.deFrameHeight -10;
    [self.pokeButton addTarget:self action:@selector(pokeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.commentButton) {
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        self.commentButton.layer.masksToBounds = YES;
        self.commentButton.layer.cornerRadius = 2;
        self.commentButton.backgroundColor = [UIColor clearColor];
        self.commentButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.commentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.commentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.commentButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        /*
        [self.commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:@"icon_comment_press"] forState:UIControlStateSelected];
        [self.commentButton setImage:[UIImage imageNamed:@"icon_comment_press"] forState:UIControlStateHighlighted|UIControlStateSelected];
         */
        [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [self.contentView addSubview:self.commentButton];
    }
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FACommentO],self.note.commentCount] forState:UIControlStateNormal];
    self.commentButton.deFrameLeft = self.pokeButton.deFrameRight +10;
    self.commentButton.deFrameBottom = self.contentView.deFrameHeight -10;
    [self.commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
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
    if (self.note.marked) {
        [self.timeButton setImage:[UIImage imageNamed:@"icon_star"] forState:UIControlStateNormal];
    }
    else
    {
        [self.timeButton setImage:nil forState:UIControlStateNormal];
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@",[self.note.createdDate stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.deFrameRight = kScreenWidth - 15;
    self.timeButton.deFrameBottom =  self.contentView.deFrameHeight -10;
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
}

+ (CGFloat)height:(GKNote *)note
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 4.0;
    label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", note.text];
    return label.optimumSize.height + 80.f;
    
    
}
#pragma mark - Action
- (void)pokeButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [GKAPI pokeWithNoteId:self.note.noteId state:!self.pokeButton.selected success:^(NSString *entityId, NSUInteger noteId, BOOL poked) {
        if (poked == self.pokeButton.selected) {
            
        }
        else if (poked) {
            self.note.pokeCount = self.note.pokeCount+1;
        } else {
            self.note.pokeCount = self.note.pokeCount-1;
        }
        self.note.poked = poked;
        [self.pokeButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp],self.note.pokeCount] forState:UIControlStateNormal];
        self.pokeButton.selected = self.note.poked;
    } failure:^(NSInteger stateCode) {
        
    }];
}
- (void)commentButtonAction
{
    NoteViewController * VC = [[NoteViewController alloc]init];
    VC.note = self.note;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}
- (void)avatarButtonAction
{
    UserViewController * VC = [[UserViewController alloc]init];
    VC.user = self.note.creator;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}
@end
