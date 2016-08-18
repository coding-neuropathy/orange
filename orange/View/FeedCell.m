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
    FeedUserFollower,
    FeedUserLike,
    FeedArticleDig,
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
        
//        self.backgroundColor = UIColorFromRGB(0xffffff);

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    
//    for (UIView *subView in self.contentView.subviews) {
//        subView.hidden = YES;
//    }
//}

- (void)dealloc
{
    [self.avatar removeObserver:self forKeyPath:@"image"];
    [self.contentLabel removeObserver:self forKeyPath:@"text"];
    [self.image removeObserver:self forKeyPath:@"image"];
    
}

#pragma mark - init view
- (UIView *)H
{
    if (!_H) {
//        _H = [[UIView alloc] initWithFrame:CGRectMake(60, self.contentView.deFrameHeight - 1, self.contentView.deFrameWidth, 0.5)];
        _H = [[UIView alloc] initWithFrame:CGRectZero];
        _H.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.contentView addSubview:_H];
    }
    return _H;
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
        _avatar.layer.cornerRadius = 18;
        _avatar.layer.masksToBounds = YES;
        [_avatar addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        _avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(avatarButtonAction)];
        [_avatar addGestureRecognizer:tap];
        
        [self.contentView addSubview:_avatar];
    }
    return _avatar;
}

- (RTLabel *)label
{
    if (!_label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectZero];
        _label.paragraphReplacement = @"";
        _label.lineSpacing = 4.0;
        _label.delegate = self;
        [self.contentView addSubview:_label];
        
        [_label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return _label;
}

- (RTLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.paragraphReplacement = @"";
        _contentLabel.lineSpacing = 4.0;
        _contentLabel.delegate = self;
        
        [_contentLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
        _timeLabel.font = [UIFont systemFontOfSize:12.f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = UIColorFromRGB(0x9d9e9f);
        
        [_timeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _image.contentMode          = UIViewContentModeScaleAspectFill;
        _image.layer.masksToBounds  = YES;
        
        [_image addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        _image.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageButtonAction)];
        [_image addGestureRecognizer:tap];
        _image.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        _image.layer.borderWidth = 0.5;
        [self.contentView addSubview:_image];
    }
    return _image;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatar.frame = CGRectMake(12.f, 13.f, 36.f, 36.f);
//    self.label.frame = CGRectMake(60., 15., kScreenWidth - 70., 20.);
    self.contentLabel.frame = CGRectMake(60, 15, self.contentView.deFrameWidth - 70 - 58, 20);
    
//    if (IS_IPAD) {
//        self.contentLabel.frame = CGRectMake(60, 15, self.contentView.deFrameWidth - 70 - 58, 20);
//    }
//    self.timeLabel.deFrameSize = CGSizeMake(80.f, 12.f);
    self.image.frame = CGRectMake(0., 13., 42., 42.);
    
    
    if (IS_IPAD) {
        self.image.deFrameRight = self.contentView.deFrameRight - 20.;
    }
    [self configContent];
    
    [self bringSubviewToFront:self.H];
    
    self.H.frame = CGRectMake(60, self.contentView.deFrameHeight - 1, self.contentView.deFrameWidth, 1);
    
    self.H.hidden = NO;
//    _H.deFrameBottom = self.frame.size.height;
//
}
//
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
//    CGContextSetLineWidth(context, kSeparateLineWidth);
//    
//    CGContextMoveToPoint(context, 60., 0.);
//    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, 0.);
//    
////    CGContextMoveToPoint(context, 0., self.contentView.deFrameHeight);
////    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
//    
//    CGContextStrokePath(context);
//}

+ (FeedType)typeFromFeed:(NSDictionary *)feedDict
{
    FeedType type = FeedTypeDefault;
    
    NSString *typeString = feedDict[@"type"];
    if ([typeString isEqualToString:@"entity"]) {
        type = FeedEntityNote;
    } else if ([typeString isEqualToString:@"user_follow"]) {
        type = FeedUserFollower;
    } else if ([typeString isEqualToString:@"user_like"]) {
        type = FeedUserLike;
    } else if ([typeString isEqualToString:@"article_dig"]){
        type = FeedArticleDig;
    }
    
    return type;
}

- (void)configContent
{
//    NSDictionary * feed = self.feed;
    NSTimeInterval timestamp = [self.feed[@"time"] doubleValue];
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithDefaultFormat];
    FeedType type = [FeedCell typeFromFeed:self.feed];
    switch (type) {
        case FeedEntityNote:
        {
            GKNote *note = self.feed[@"object"][@"note"];
            GKEntity *entity = self.feed[@"object"][@"entity"];
            GKUser * user = note.creator;
            
            [self.avatar sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(36, 36)]];
            
            self.contentLabel.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><font face='Helvetica' color='^414243' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                                      (unsigned long)user.userId,
                                      user.nick,
                                      NSLocalizedStringFromTable(@"noted 1 item:", kLocalizedFile, nil),
                                      note.text,
                                      time];
            self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5;

            
            [self.image sd_setImageWithURL:entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(100, 100)]];
            self.image.frame = IS_IPHONE?CGRectMake(kScreenWidth - 58, self.avatar.deFrameTop, 42, 42):CGRectMake(kScreenWidth - 58 - kTabBarWidth, self.avatar.deFrameTop, 42, 42);
            self.image.deFrameLeft = self.contentLabel.deFrameRight + 12.;
        }
            break;
        case FeedUserLike:
        {
            
            GKUser * user = self.feed[@"object"][@"user"];
            GKEntity *entity = self.feed[@"object"][@"entity"];
//            NSLog(@"%@ %@", self.feed[@"type"], user.nickname);
            [self.avatar sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60., 60.)]];
            
            self.contentLabel.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                                      (unsigned long)user.userId,
                                      user.nick,
                                      NSLocalizedStringFromTable(@"liked 1 item", kLocalizedFile, nil),
                                      time];
            
            self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5;
            
            [self.image sd_setImageWithURL:entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(100, 100)]];
            self.image.deFrameLeft = self.contentLabel.deFrameRight + 12.;
//            self.image.frame = IS_IPHONE?CGRectMake(kScreenWidth - 58, self.avatar.deFrameTop, 42, 42):CGRectMake(kScreenWidth - 58 - kTabBarWidth, self.avatar.deFrameTop, 42, 42);
            self.image.deFrameRight = self.contentView.deFrameWidth - 16.;
            self.image.deFrameTop   = self.avatar.deFrameTop;
        }
            break;
        case FeedUserFollower:
        {
            GKUser * user = self.feed[@"object"][@"user"];
            GKUser * target = self.feed[@"object"][@"target"];
            [self.avatar sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60., 60.)]];
            if (target.userId == [Passport sharedInstance].user.userId) {
                self.contentLabel.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font> <a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", (unsigned long)user.userId, user.nick, NSLocalizedStringFromTable(@"started following", kLocalizedFile, nil),(unsigned long)target.userId, NSLocalizedStringFromTable(@"you", kLocalizedFile, nil), time];
            } else {
                self.contentLabel.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font> <a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", (unsigned long)user.userId, user.nick, NSLocalizedStringFromTable(@"started following", kLocalizedFile, nil),(unsigned long)target.userId,target.nick, time];
            }
            self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5;

            self.image.hidden = YES;
        }
            break;
        case FeedArticleDig:
        {
            GKUser * user = self.feed[@"object"][@"user"];
            GKArticle * article = self.feed[@"object"][@"article"];
            [self.avatar sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60., 60.)]];
            self.contentLabel.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                                      (unsigned long)user.userId,
                                      user.nick,
                                      NSLocalizedStringFromTable(@"bumped 1 item", kLocalizedFile, nil),
                                      time];
            self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5;
            
            [self.image sd_setImageWithURL:article.coverURL_300 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(100, 100)]];
            self.image.deFrameLeft = self.contentLabel.deFrameRight + 12.;
            self.image.frame = IS_IPHONE?CGRectMake(kScreenWidth - 58, self.avatar.deFrameTop, 42, 42):CGRectMake(kScreenWidth - 58 - kTabBarWidth, self.avatar.deFrameTop, 42, 42);
        }
        default:
            break;
            
    }
}

+ (CGFloat)height:(NSDictionary *)feed
{
    CGFloat height = 0.;
//    NSLog(@"feed %@", feed);
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70 - 58., 20)];
    if (IS_IPAD) {
        label.frame = CGRectMake(60, 15, kPadScreenWitdh -70 - 58., 20);
    } else {
        label.frame = CGRectMake(60, 15, kScreenWidth -70 - 58., 20);
    }
    
    label.paragraphReplacement = @"";
    label.lineSpacing = 4.0;
    NSTimeInterval timestamp = [feed[@"time"] doubleValue];
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithDefaultFormat];
    
    FeedType type = [FeedCell typeFromFeed:feed];
    switch (type) {
        case FeedEntityNote:
        {
            GKNote *note = feed[@"object"][@"note"];
            GKUser * user = note.creator;
//            GKEntity *entity = feed[@"object"][@"entity"];
            
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><font face='Helvetica' color='^414243' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                          (unsigned long)user.userId,
                          user.nick,
                          NSLocalizedStringFromTable(@"noted 1 item:", kLocalizedFile, nil),
                          note.text,
                          time];
            CGFloat y = label.optimumSize.height + 5.;
            height = y;
            if (height < 40) {
                height = 40;
            }
        }
            break;
        case FeedUserLike:
        {
            GKUser * user = feed[@"object"][@"user"];
//            NSLog(@"%@", feed[@"type"]);
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                          (unsigned long)user.userId,
                          user.nick,
                          NSLocalizedStringFromTable(@"liked 1 item", kLocalizedFile, nil),
                          time];
////
            CGFloat y = label.optimumSize.height + 5.;
            height = y;
            if (height < 40) {
                height = 40;
            }
        }
            break;
        case FeedUserFollower:
        {
            GKUser * user = feed[@"object"][@"user"];
            GKUser * target = feed[@"object"][@"target"];
            if (target.userId == [Passport sharedInstance].user.userId) {
                label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font> <a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", (unsigned long)user.userId, user.nick, NSLocalizedStringFromTable(@"started following", kLocalizedFile, nil),(unsigned long)target.userId, NSLocalizedStringFromTable(@"you", kLocalizedFile, nil), time];
            
            } else {
                label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", (unsigned long)user.userId, user.nick,NSLocalizedStringFromTable(@"started following", kLocalizedFile, nil), (unsigned long)target.userId, target.nick, time];
            }
            CGFloat y = label.optimumSize.height + 5.;
            height = y;
            if (height < 40) {
                height = 40;
            }
        }
            break;
        case FeedArticleDig:
        {
            GKUser * user = feed[@"object"][@"user"];
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> %@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                          (unsigned long)user.userId,
                          user.nick,
                          NSLocalizedStringFromTable(@"bumped 1 item", kLocalizedFile, nil),
                          time];
            
            
            CGFloat y = label.optimumSize.height + 5.;
            height = y;
            if (height < 40) {
                height = 40;
            }
            
        }
        default:
//            height = 0;
            break;
    }
    
    return height+24;
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ((UIView *)object).hidden = NO;
}
- (void)avatarButtonAction
{

//    NSDictionary * feed = self.feed;
//    NSLog(@"feed %@", self.feed);
    GKUser * user;
    switch ([FeedCell typeFromFeed:self.feed]) {
        case FeedEntityNote:
        {
            GKNote *note = self.feed[@"object"][@"note"];
            user = note.creator;
        }
            break;
        case FeedUserLike:
        {
            user = self.feed[@"object"][@"user"];

        }
            break;
        case FeedUserFollower:
        {
            user = self.feed[@"object"][@"user"];
        }
            break;
        case FeedArticleDig:
        {
            user = self.feed[@"object"][@"user"];
        }
        default:
            break;
    }

    if (user)
    {
        [[OpenCenter sharedOpenCenter] openUser:user];
    }

    [MobClick event:@"feed_forward_user"];
}


#pragma mark - button action
- (void)imageButtonAction
{
    
    switch ([FeedCell typeFromFeed:self.feed]) {
        case FeedArticleDig:
        {
            GKArticle * article = self.feed[@"object"][@"article"];
            [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
        }
            break;
        case FeedUserLike:
        {
            GKEntity *entity = self.feed[@"object"][@"entity"];
            [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
            
            [MobClick event:@"feed_forward_entity"];
        }
            break;
        case FeedEntityNote:
        {
            GKEntity * entity = self.feed[@"object"][@"entity"];
            [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
        }
        default:
            break;
    }
    
}

#pragma mark - <RTLabelDelegate>
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"user"])
    {
        GKUser * user = [GKUser modelFromDictionary:@{@"userId":@([array[1] integerValue])}];
        [[OpenCenter sharedOpenCenter] openUser:user];
    }
    if([array[0] isEqualToString:@"entity"])
    {
        GKEntity * entity = [GKEntity modelFromDictionary:@{@"entityId":@([array[1] integerValue])}];
        EntityViewController * VC = [[EntityViewController alloc]init];
        if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
        VC.entity = entity;
        [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    }
}


@end
