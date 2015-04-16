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
#import "TagViewController.h"
#import "EntityViewController.h"
#import "GKWebVC.h"

static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"(#|＃)([のA-Z0-9a-z\u4e00-\u9fa5_]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}
static inline NSRegularExpression * UrlRegularExpression() {
    static NSRegularExpression *_urlRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _urlRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"(http(s)?://([A-Z0-9a-z._=&?-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _urlRegularExpression;
}

@implementation NoteCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xebebeb);
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
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(16.f, 20.f, 36.f, 36.f)];
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
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(64, 20, kScreenWidth - 78, 20)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 7.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
    }
    self.label.text = [NSString stringWithFormat:@"<a href='user:%lu'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a>", (unsigned long)self.note.creator.userId, self.note.creator.nickname];
    
    if(!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(64, 20, kScreenWidth - 78, 20)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 7.0;
        self.contentLabel.delegate = self;
        [self.contentLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        self.contentLabel.textColor = UIColorFromRGB(0x414243);
        [self.contentView addSubview:self.contentLabel];
    }
    
    if(self.note.text!=nil)
    {
        NSMutableString * resultText = [NSMutableString stringWithString:self.note.text];
        NSRegularExpression *regexp =  ParenthesisRegularExpression();
        NSArray *array = [regexp matchesInString: self.note.text
                                         options: 0
                                           range: NSMakeRange( 0, [self.note.text length])];
        
        NSUInteger i = 0;
        NSUInteger j = 0;
        for (NSTextCheckingResult *match in array)
        {
            j = match.range.location+i;
            
            NSString * a = [NSString stringWithFormat:@"<a href='tag:%@'><font face='Helvetica' color='^427ec0'>",[[self.note.text substringWithRange:NSMakeRange(match.range.location+1,match.range.length-1)]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [resultText insertString:a atIndex:j];
            NSString * b = [NSString stringWithFormat:@"</font></a>"];
            j = match.range.length+j+a.length;
            [resultText insertString:b atIndex:j];
            
            i = i + b.length + a.length;
        }
        NSRegularExpression *urlregexp =  UrlRegularExpression();
        NSArray *urlarray = [urlregexp matchesInString: resultText
                                               options: 0
                                                 range: NSMakeRange( 0, [resultText length])];
        i = 0;
        for (NSTextCheckingResult *match in urlarray)
        {
            j = match.range.location+i;
            NSString * a = [NSString stringWithFormat:@"<a href='%@'><font face='Helvetica' color='^427ec0'>",[resultText substringWithRange:NSMakeRange(match.range.location,match.range.length)]];
            [resultText insertString:a atIndex:j];
            NSString * b = [NSString stringWithFormat:@"</font></a>"];
            j = match.range.length+j+a.length;
            [resultText insertString:b atIndex:j];
            
            i = i + b.length + a.length;
            
        }
        
        [self.contentLabel setText:resultText];
    }
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.label.deFrameBottom+5;
    
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
    [self.pokeButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp],(unsigned long)self.note.pokeCount] forState:UIControlStateNormal];
    if (self.note.pokeCount ==0) {
        [self.pokeButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp]] forState:UIControlStateNormal];
    }
    
    self.pokeButton.deFrameLeft = self.contentLabel.deFrameLeft;
    self.pokeButton.deFrameBottom = self.contentView.deFrameHeight -15;
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
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FACommentO],(unsigned long)self.note.commentCount] forState:UIControlStateNormal];
    
    if(self.note.commentCount == 0)
    {
        [self.commentButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FACommentO]] forState:UIControlStateNormal];
    }
    
    
    
    self.commentButton.deFrameLeft = self.pokeButton.deFrameRight +10;
    self.commentButton.deFrameBottom = self.contentView.deFrameHeight -15;
    [self.commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.note.createdDate stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.deFrameRight = kScreenWidth - 16;
    self.timeButton.deFrameBottom =  self.contentView.deFrameHeight -15;
    
    if (!self.markButton) {
        _markButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.markButton.layer.masksToBounds = YES;
        self.markButton.layer.cornerRadius = 2;
        self.markButton.backgroundColor = [UIColor clearColor];
        self.markButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.markButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.markButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.markButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.markButton setTitleColor:UIColorFromRGB(0xFF9600) forState:UIControlStateSelected];
        [self.markButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [self.contentView addSubview:self.markButton];
        [self.markButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAStar]] forState:UIControlStateNormal];
    }
    self.markButton.selected = self.note.marked;
    self.markButton.center = self.label.center;
    self.markButton.deFrameRight = kScreenWidth - 16;
    
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
}

+ (CGFloat)height:(GKNote *)note
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth -78, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 7.0;
    label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", note.text];
    return label.optimumSize.height + 97.f;
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
        [self.pokeButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp],(unsigned long)self.note.pokeCount] forState:UIControlStateNormal];
        if (self.note.pokeCount ==0) {
            [self.pokeButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp]] forState:UIControlStateNormal];
        }
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

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"http"])
    {
        GKWebVC * vc =  [GKWebVC linksWebViewControllerWithURL:url];
        [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
    }
    if([array[0] isEqualToString:@"tag"])
    {
        TagViewController * vc = [[TagViewController alloc]init];
        vc.tagName = [array[1]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vc.user = self.note.creator;
        if (kAppDelegate.activeVC.navigationController) {
            [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
        }
    }
    if([array[0] isEqualToString:@"user"])
    {
        GKUser * user = [GKUser modelFromDictionary:@{@"userId":@([array[1] integerValue])}];
        UserViewController * vc = [[UserViewController alloc]init];
        vc.user = user;
        if (kAppDelegate.activeVC.navigationController) {
            [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
        }
    }
    if([array[0] isEqualToString:@"entity"])
    {
        GKEntity * entity = [GKEntity modelFromDictionary:@{@"entityId":@([array[1] integerValue])}];
        EntityViewController * vc = [[EntityViewController alloc]init];
        vc.entity = entity;
        if (kAppDelegate.activeVC.navigationController) {
            [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
@end
