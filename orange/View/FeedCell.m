//
//  FeedCell.m
//  orange
//
//  Created by huiter on 15/1/23.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "FeedCell.h"
#import "RTLabel.h"
#import "EntityViewController.h"
#import "UserViewController.h"

typedef NS_ENUM(NSInteger, FeedType) {
    /**
     *  默认类型
     */
    FeedTypeDefault = 0,
    FeedEntityNote,
};

@interface FeedCell()<RTLabelDelegate>
@property (nonatomic, assign) FeedType type;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *H;
@end

@implementation FeedCell


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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setFeed:(NSDictionary *)feed
{
    _feed = feed;
    
    self.type = [FeedCell typeFromFeed:self.feed];
}

- (void)setType:(FeedType)type
{
    _type = type;
    [self setNeedsLayout];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (UIView *subView in self.contentView.subviews) {
        subView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (!self.avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 13.f, 36.f, 36.f)];
        [self.contentView addSubview:self.avatar];
        self.avatar.layer.cornerRadius = 18;
        self.avatar.layer.masksToBounds = YES;
        [self.avatar addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        self.avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(avatarButtonAction)];
        [self.avatar addGestureRecognizer:tap];
    }
    
    if(!self.label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 70, 20)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 4.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
        
        [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if(!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 70, 20)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 4.0;
        self.contentLabel.delegate = self;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.deFrameSize = CGSizeMake(80.f, 12.f);
        self.timeLabel.font = [UIFont systemFontOfSize:10.f];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(60.f, 0.f, 100, 100)];
        [self.contentView addSubview:self.image];
        [self.image addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        self.image.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageButtonAction)];
        [self.image addGestureRecognizer:tap];
    }
    
    [self configContent];
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
    
}

+ (FeedType)typeFromFeed:(NSDictionary *)feedDict
{
    FeedType type = FeedTypeDefault;
    
    NSString *typeString = feedDict[@"type"];
    if ([typeString isEqualToString:@"entity"]) {
        type = FeedEntityNote;
    }
    
    return type;
}

- (void)configContent
{
    NSDictionary * feed = self.feed;
    FeedType type = [FeedCell typeFromFeed:feed];
    switch (type) {
        case FeedEntityNote:
        {
            GKNote *note = feed[@"object"][@"note"];
            GKEntity *entity = feed[@"object"][@"entity"];
            GKUser * user = note.creator;
            
            [self.avatar sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60, 60)]];
            self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14> 点评了</font><a href='entity:%@'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a>", user.userId, user.nickname,entity.entityId,entity.title];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            
            self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>“ %@ ”</font>", note.text];
            self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
            self.contentLabel.deFrameTop = self.label.deFrameBottom;
            
            self.timeLabel.deFrameBottom = self.deFrameHeight - 10.f;
            self.timeLabel.deFrameLeft = 60;

            self.timeLabel.text = [note.createdDate stringWithDefaultFormat];
            
            [self.image sd_setImageWithURL:entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(100, 100)]];
            self.image.deFrameTop = self.contentLabel.deFrameBottom +10;
            
            break;
        }
        default:
            break;
            
    }
}

+ (CGFloat)height:(NSDictionary *)feed
{
    CGFloat height;
    
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 4.0;
    
    
    
    FeedType type = [FeedCell typeFromFeed:feed];
    switch (type) {
        case FeedEntityNote:
        {
            GKNote *note = feed[@"object"][@"note"];
            GKUser * user = note.creator;
            GKEntity *entity = feed[@"object"][@"entity"];
            
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14> 点评了</font><a href='entity:%@'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a>", user.userId, user.nickname,entity.entityId,entity.title];
            CGFloat y = label.optimumSize.height + 5.f;
            
            
            {
                 RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70, 20)];
                 label.paragraphReplacement = @"";
                 label.lineSpacing = 4.0;
                 label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>“ %@ ”</font>", note.text];
                 y = label.optimumSize.height + 5.f + y;
            }
            
            
            height = y + 160;
            break;
        }
        default:
            height = 0;
            break;
    }
    
    return height;
}

- (void)dealloc
{
    [self.avatar removeObserver:self forKeyPath:@"image"];
    [self.label removeObserver:self forKeyPath:@"text"];
    [self.contentLabel removeObserver:self forKeyPath:@"text"];
    [self.image removeObserver:self forKeyPath:@"image"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ((UIView *)object).hidden = NO;
}
- (void)avatarButtonAction
{
    NSDictionary * feed = self.feed;
    GKNote *note = feed[@"object"][@"note"];
    //GKEntity *entity = feed[@"object"][@"entity"];
    UserViewController * VC = [[UserViewController alloc]init];
    VC.user = note.creator;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

- (void)imageButtonAction
{
    NSDictionary * feed = self.feed;
    //GKNote *note = feed[@"object"][@"note"];
    GKEntity *entity = feed[@"object"][@"entity"];
    EntityViewController * VC = [[EntityViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.entity = entity;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"user"])
    {
        GKUser * user = [GKUser modelFromDictionary:@{@"userId":@([array[1] integerValue])}];
        UserViewController * VC = [[UserViewController alloc]init];
        VC.user = user;
        [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    }
    if([array[0] isEqualToString:@"entity"])
    {
        GKEntity * entity = [GKEntity modelFromDictionary:@{@"entityId":@([array[1] integerValue])}];
        EntityViewController * VC = [[EntityViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        VC.entity = entity;
        [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    }
}

@end
