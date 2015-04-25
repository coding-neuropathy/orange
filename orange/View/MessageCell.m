//
//  MessageCell.m
//  orange
//
//  Created by huiter on 15/1/18.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "MessageCell.h"
#import "RTLabel.h"
#import "UserViewController.h"
#import "EntityViewController.h"
/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, MessageType) {
    /**
     *  默认类型
     */
    MessageTypeDefault = 0,
    /**
     *  评论被回复
     */
    MessageCommentReply,
    /**
     *  点评被评论
     */
    MessageNoteComment,
    /**
     *  被关注
     */
    MessageUserFollow,
    /**
     *  点评被赞
     */
    MessageNotePoke,
    /**
     *  商品被点评
     */
    MessageEntityNote,
    /**
     *  商品被喜爱
     */
    MessageEntityLike,
    /**
     *  点评入精选
     */
    MessageNoteSelection,
};

@interface MessageCell()<RTLabelDelegate>
@property (nonatomic, assign) MessageType type;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) UIView *H;

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _H = [[UIView alloc] initWithFrame:CGRectMake(60,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.contentView addSubview:self.H];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(NSDictionary *)message
{
    _message = message;
    
    self.type = [MessageCell typeFromMessage:self.message];
}

- (void)setType:(MessageType)type
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
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(12.f, 12.f, 36.f, 36.f)];
        [self.contentView addSubview:self.avatar];
        self.avatar.backgroundColor = UIColorFromRGB(0xf6f6f6);
        self.avatar.layer.cornerRadius = 18;
        self.avatar.layer.masksToBounds = YES;
        [self.avatar addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        self.avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(avatarButtonAction)];
        [self.avatar addGestureRecognizer:tap];
    }
    
    if(!self.label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 130, 20)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 4.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
        
        [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(16.f, 12.f, 42.f, 42.f)];
//        [_image set]
        _image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.image];
        [self.image addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        self.image.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageButtonAction)];
        [self.image addGestureRecognizer:tap];
        self.image.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        self.image.layer.borderWidth = 0.5;
    }
    
    [self configContent];
    
    [self bringSubviewToFront:self.H];
    self.H.hidden = NO;
    _H.deFrameBottom = self.frame.size.height;
    
}

- (void)configContent
{
    NSDictionary * message = self.message;
    MessageType type = [MessageCell typeFromMessage:message];
    NSTimeInterval timestamp = [self.message[@"time"] doubleValue];
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithDefaultFormat];
    switch (type) {
        case MessageCommentReply:
        {
            GKComment *replying_comment = message[@"content"][@"replying_comment"];
            GKUser * user = replying_comment.creator;
            
            [self.avatar sd_setImageWithURL:user.avatarURL];
            self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>回复了你的评论</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", user.userId, user.nickname,time];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            break;
        }
            // 点评被评论
        case MessageNoteComment:
        {
            GKNote *note = message[@"content"][@"note"];
            GKComment *comment = message[@"content"][@"comment"];
            GKUser * user = comment.creator;
            
            [self.avatar sd_setImageWithURL:user.avatarURL];
            self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>%@ </font><a href='entity:%@'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> 的点评</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                               user.userId,
                               user.nickname,
                               NSLocalizedStringFromTable(@"commented on your", kLocalizedFile, nil),
                               note.entityId,
                               note.title,
                               time];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            self.image.frame = CGRectMake(kScreenWidth -58, self.avatar.deFrameTop, 42, 42);
            __block UIImageView *block_img = self.image;
            [self.image sd_setImageWithURL:note.entityChiefImage_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(30, 30)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    block_img.alpha = 0.0;
                    [UIView animateWithDuration:0.25 animations:^{
                        block_img.alpha = 1.0;
                    }];
                }
            }];
            
            break;
        }
            
        case MessageUserFollow:
        {
            GKUser *user = self.message[@"content"][@"user"];
            
            [self.avatar sd_setImageWithURL:user.avatarURL];
            self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                               user.userId,
                               user.nickname,
                               NSLocalizedStringFromTable(@"followed you", kLocalizedFile, nil),
                               time];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;

            break;
        }
            //赞
        case MessageNotePoke:
        {
            GKNote *note = message[@"content"][@"note"];
            GKUser * user = message[@"content"][@"user"];
            
            [self.avatar sd_setImageWithURL:user.avatarURL];
            self.label.text =  [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>赞了你对 </font><a href='entity:%@'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> 的点评</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", user.userId, user.nickname ,note.entityId,note.title,time];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            self.image.frame = CGRectMake(kScreenWidth -58, self.avatar.deFrameTop, 42, 42);
            __block UIImageView *block_img = self.image;
            [self.image sd_setImageWithURL:note.entityChiefImage_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(30, 30)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    block_img.alpha = 0.0;
                    [UIView animateWithDuration:0.25 animations:^{
                        block_img.alpha = 1.0;
                    }];
                }
            }];
            
            break;
        }
            //商品被点评
        case MessageEntityNote:
        {
            GKNote *note = message[@"content"][@"note"];
            GKEntity * entity = message[@"content"][@"entity"];
            GKUser   *user   = note.creator;
            
            [self.avatar sd_setImageWithURL:user.avatarURL];
            self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                               user.userId,
                               user.nickname,
                               NSLocalizedStringFromTable(@"commented on a product of your recommendation", kLocalizedFile, nil),
                               time];
            
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            self.image.frame = CGRectMake(kScreenWidth -58, self.avatar.deFrameTop, 42, 42);
            __block UIImageView *block_img = self.image;
//            DDLogInfo(@"note image %@", entity.imageURL_240x240);
            [self.image sd_setImageWithURL:entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(30, 30)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    block_img.alpha = 0.0;
                    [UIView animateWithDuration:0.25 animations:^{
                        block_img.alpha = 1.0;
                    }];
                }
            }];
            
            break;
        }
            
        case MessageEntityLike:
        {
            GKEntity *entity = self.message[@"content"][@"entity"];
            GKUser   *user   = self.message[@"content"][@"user"];
            
            [self.avatar sd_setImageWithURL:user.avatarURL];
            self.label.text = [NSString stringWithFormat:@"<a href='user:%lu'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                               user.userId,
                               user.nickname,
                               NSLocalizedStringFromTable(@"liked a product of your recommendation", kLocalizedFile, nil),
                               time];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            self.image.frame = CGRectMake(kScreenWidth - 58, self.avatar.deFrameTop, 42, 42);
            __block UIImageView *block_img = self.image;
            [self.image sd_setImageWithURL:entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(30, 30)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    block_img.alpha = 0.0;
                    [UIView animateWithDuration:0.25 animations:^{
                        block_img.alpha = 1.0;
                    }];
                }
            }];
            
            break;
        }
            
        case MessageNoteSelection:
        {
            GKEntity *entity = self.message[@"content"][@"entity"];

            self.avatar.image = [UIImage imageNamed:@"message_star.png"];
            self.avatar.backgroundColor = UIColorFromRGB(0xfafafa);
            self.avatar.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
            self.avatar.layer.borderWidth = 0.5;
            self.avatar.userInteractionEnabled = NO;
            self.avatar.contentMode = UIViewContentModeCenter;
            self.label.text = [NSString stringWithFormat:@"<font face=\'Helvetica\' color=\'^414243\' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                               NSLocalizedStringFromTable(@"a product of your recommendation is marked as exceptional choice", kLocalizedFile, nil),
                               time];
            self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
            
            self.image.frame = CGRectMake(kScreenWidth - 58, self.avatar.deFrameTop, 42, 42);
            __block UIImageView *block_img = self.image;
            [self.image sd_setImageWithURL:entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f6f6) andSize:CGSizeMake(30, 30)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    block_img.alpha = 0.0;
                    [UIView animateWithDuration:0.25 animations:^{
                        block_img.alpha = 1.0;
                    }];
                }
            }];
            
            break;
        }
            
        default:
          
            break;
    }
    
    self.avatar.hidden = NO;
}

- (void)dealloc
{
    [self.avatar removeObserver:self forKeyPath:@"image"];
    [self.label removeObserver:self forKeyPath:@"text"];
    [self.image removeObserver:self forKeyPath:@"image"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ((UIView *)object).hidden = NO;
}

#pragma mark - RTLabelDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSArray  * array= [[url absoluteString] componentsSeparatedByString:@":"];
    if([array[0] isEqualToString:@"user"])
    {
        GKUser * user = [GKUser modelFromDictionary:@{@"userId":@([array[1] integerValue])}];
        UserViewController * VC = [[UserViewController alloc]init];
        VC.user = user;
        VC.hidesBottomBarWhenPushed = YES;
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


+ (MessageType)typeFromMessage:(NSDictionary *)messageDict
{
    MessageType type = MessageTypeDefault;
    
    NSString *typeString = messageDict[@"type"];
    if ([typeString isEqualToString:@"note_comment_reply_message"]) {
        type = MessageCommentReply;
    } else if ([typeString isEqualToString:@"note_comment_message"]) {
        type = MessageNoteComment;
    } else if ([typeString isEqualToString:@"user_follow"]) {
        type = MessageUserFollow;
    } else if ([typeString isEqualToString:@"note_poke_message"]) {
        type = MessageNotePoke;
    } else if ([typeString isEqualToString:@"entity_note_message"]) {
        type = MessageEntityNote;
    } else if ([typeString isEqualToString:@"entity_like_message"]) {
        type = MessageEntityLike;
    } else if ([typeString isEqualToString:@"note_selection_message"]) {
        type = MessageNoteSelection;
    }
    
    return type;
}

+ (CGFloat)height:(NSDictionary *)message
{
    CGFloat height;
    
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -130, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 4.0;
    
    NSTimeInterval timestamp = [message[@"time"] doubleValue];
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithDefaultFormat];
    
    MessageType type = [MessageCell typeFromMessage:message];
    switch (type) {
        case MessageCommentReply:
        {
            GKComment *replying_comment = message[@"content"][@"replying_comment"];
            GKUser * user = replying_comment.creator;
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>回复了你的评论</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", user.userId, user.nickname,time];
            CGFloat y = label.optimumSize.height + 5.f;
            /*
            RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70, 20)];
            label.paragraphReplacement = @"";
            label.lineSpacing = 4.0;
            label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^414243' size=14>“ %@ ”</font>", replying_comment.text];
            y = label.optimumSize.height + 5.f + y;
            */
            
            height = y;
            if (height < 40) {
                height = 40;
            }
            break;
        }
            // 点评被评论
        case MessageNoteComment:
        {
            GKNote *note = message[@"content"][@"note"];
            GKComment *comment = message[@"content"][@"comment"];
            GKUser * user = comment.creator;
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>评论了你对 </font><a href='entity:%@'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> 的点评</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", user.userId, user.nickname ,note.entityId,note.title,time];
            CGFloat y = label.optimumSize.height + 5.f;
            
            /*
            RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth -70, 20)];
            label.paragraphReplacement = @"";
            label.lineSpacing = 4.0;
            label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^414243' size=14>“ %@ ”</font>", comment.text];
            y = label.optimumSize.height + 5.f + y;
             */
            
            height = y;
            if (height < 40) {
                height = 40;
            }
            break;
        }
            
        case MessageUserFollow:
        {
            height = 26.f;
            break;
        }
            //赞
        case MessageNotePoke:
        {
            GKNote *note = message[@"content"][@"note"];
            GKUser * user = message[@"content"][@"user"];
            label.text =  [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>赞了你对 </font><a href='entity:%@'><font face='Helvetica-Bold' color='^427ec0' size=14>%@</font></a><font face='Helvetica' color='^414243' size=14> 的点评</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>", user.userId, user.nickname ,note.entityId,note.title,time];
            CGFloat y = label.optimumSize.height + 5.f;
            height = y;
            if (height < 40) {
                height = 40;
            }
            break;
        }
            //商品被点评
        case MessageEntityNote:
        {
            GKNote *note = message[@"content"][@"note"];
            GKUser *user   = note.creator;
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>%@</font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                          user.userId,
                          user.nickname,
                          NSLocalizedStringFromTable(@"commented on a product of your recommendation", kLocalizedFile, nil),
                          time];
            CGFloat y = label.optimumSize.height + 5.f;
            height = y;
            if (height < 40) {
                height = 40;
            }
            break;
        }
            
        case MessageEntityLike:
        {
            GKUser * user = message[@"content"][@"user"];
            label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a><font face='Helvetica' color='^414243' size=14>%@ </font><font face='Helvetica' color='^9d9e9f' size=14> %@</font>",
                          user.userId,
                          user.nickname,
                          NSLocalizedStringFromTable(@"liked a product of your recommendation", kLocalizedFile, nil),
                          time];
            CGFloat y =  label.optimumSize.height + 5.f;
            height = y;
            if (height < 40) {
                height = 40;
            }
            break;
        }
            
        case MessageNoteSelection:
        {
            
            height = 40.;
            break;
        }
            
        default:
            height = 0.f;
            break;
    }
    
    return height + 24.;
}

- (void)avatarButtonAction
{
    NSDictionary * message = self.message;
    
    UserViewController * VC = [[UserViewController alloc] init];
    
    
    GKNote *note = message[@"content"][@"note"];
    if (note)
        VC.user = note.creator;
    else {
        GKUser * user = message[@"content"][@"user"];
        VC.user = user;
    }
    VC.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    [AVAnalytics event:@"message_forward_user"];
    [MobClick event:@"message_forward_user"];
}

- (void)imageButtonAction
{
    NSDictionary * message = self.message;
    GKNote *note = message[@"content"][@"note"];
    GKEntity *entity = message[@"content"][@"entity"];
    EntityViewController * VC = [[EntityViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    if(entity)
    {
        VC.entity = entity;
    }
    else
    {
        VC.entity = [GKEntity modelFromDictionary:@{@"entityId":@([note.entityId integerValue])}];
    }
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    [AVAnalytics event:@"message_forward_entity"];
    [MobClick event:@"message_forward_entity"];
}
@end
