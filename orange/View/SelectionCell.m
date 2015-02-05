       //
//  SelectionCell.m
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SelectionCell.h"
#import "MLEmojiLabel.h"
#import "GKAPI.h"
#import "EntityViewController.h"
#import "LoginView.h"
#define kWidth (kScreenWidth - 20)
@interface SelectionCell()<MLEmojiLabelDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *tmp;
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MLEmojiLabel *emojiLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIView *H;

@end

@implementation SelectionCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xeeeeee);
        //[self.contentView addSubview:self.H];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setEntity:(GKEntity *)entity
{
    if (_entity) {
        [self removeObserver];
    }
    _entity = entity;
    [self addObserver];
    [self setNeedsLayout];
}
- (void)setNote:(GKNote *)note
{
    _note = note;
    [self setNeedsLayout];
}
- (void)setDate:(NSDate *)date
{
    _date = date;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    if (!self.box) {
        _box = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 7.0f,kScreenWidth -30, 300)];
        self.box.contentMode = UIViewContentModeScaleAspectFit;
        self.box.backgroundColor = [UIColor whiteColor];
        self.box.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        self.box.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.box];
    }
    
    if (!self.image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, 17.0f,kScreenWidth -50, 280)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.backgroundColor = [UIColor whiteColor];
        self.image.userInteractionEnabled = YES;
        [self.contentView addSubview:self.image];
    }
    __block UIImageView *block_img = self.image;
    __block UIImageView *tmp_img = self.tmp;
    __weak __typeof(&*self)weakSelf = self;
    {
        [self.image sd_setImageWithURL:self.entity.imageURL_640x640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth -50, 280)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL*imageURL) {
            tmp_img = [[UIImageView alloc]initWithImage:image];
            if (tmp_img.frame.size.width<280&&tmp_img.frame.size.height<280) {
                block_img.contentMode = UIViewContentModeCenter;
            }
            else
            {
                block_img.contentMode = UIViewContentModeScaleAspectFit;
            }
            if (image && cacheType == SDImageCacheTypeNone) {

            }
            [weakSelf.activityIndicator stopAnimating];
            weakSelf.activityIndicator.hidden = YES;

        }];
    }
    
    [self.emojiLabel setText:self.note.text];
    self.emojiLabel.frame = CGRectMake(15.0f, self.box.deFrameBottom +15, kScreenWidth - 30, [[self class] heightForEmojiText:self.note.text]);
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.emojiLabel];
    
    
    if (!self.likeButton) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.likeButton.layer.masksToBounds = YES;
        self.likeButton.layer.cornerRadius = 2;
        self.likeButton.backgroundColor = [UIColor clearColor];
        self.likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.likeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.likeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.likeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateSelected];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateHighlighted|UIControlStateSelected];
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [self.contentView addSubview:self.likeButton];        
    }
    [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %ld",self.entity.likeCount] forState:UIControlStateNormal];
    self.likeButton.selected = self.entity.liked;
    self.likeButton.deFrameLeft = self.emojiLabel.deFrameLeft;
    self.likeButton.deFrameTop = self.emojiLabel.deFrameBottom+10;
    [self.likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.date stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.deFrameRight = self.emojiLabel.deFrameRight;
    self.timeButton.deFrameTop = self.emojiLabel.deFrameBottom+10;
    [self.timeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height-5;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(imageButtonAction)];
    [self.image addGestureRecognizer:tap];
}

#pragma mark - getter
- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [MLEmojiLabel new];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:15.0f];
        _emojiLabel.delegate = self;
        _emojiLabel.backgroundColor = [UIColor clearColor];
        _emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _emojiLabel.textColor = [UIColor darkGrayColor];
        _emojiLabel.backgroundColor = [UIColor colorWithRed:0.218 green:0.809 blue:0.304 alpha:1.000];
        
        _emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _emojiLabel.isNeedAtAndPoundSign = YES;
        _emojiLabel.disableEmoji = NO;
        
        _emojiLabel.lineSpacing = 3.0f;
        
        _emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        
        //        _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        //        _emojiLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    }
    return _emojiLabel;
}

#pragma mark - height
+ (CGFloat)heightForEmojiText:(NSString*)emojiText
{
    static MLEmojiLabel *protypeLabel = nil;
    if (!protypeLabel) {
        protypeLabel = [MLEmojiLabel new];
        protypeLabel.numberOfLines = 0;
        protypeLabel.font = [UIFont systemFontOfSize:15.0f];
        protypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        protypeLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        protypeLabel.isNeedAtAndPoundSign = YES;
        protypeLabel.disableEmoji = NO;
        protypeLabel.lineSpacing = 3.0f;
        
        protypeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        
        //        protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        //        protypeLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    }
    
    [protypeLabel setText:emojiText];
    
    return [protypeLabel preferredSizeWithMaxWidth:kWidth].height+5.0f*2;
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}
#pragma mark - KVO
- (void)addObserver
{
    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.entity removeObserver:self forKeyPath:@"likeCount"];
    [self.entity removeObserver:self forKeyPath:@"liked"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"likeCount"]) {
        [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %ld",self.entity.likeCount] forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"liked"]) {
        self.likeButton.selected = self.entity.liked;
    }
        
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - Action
- (void)likeButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [GKAPI likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
        if (liked == self.likeButton.selected) {
            [SVProgressHUD showImage:nil status:@"喜爱成功"];
        }
        self.likeButton.selected = liked;
        self.entity.liked = liked;
        if (liked) {
            [SVProgressHUD showImage:nil status:@"喜爱成功"];
            self.entity.likeCount = self.entity.likeCount+1;
        } else {
            self.entity.likeCount = self.entity.likeCount-1;
            [SVProgressHUD dismiss];
        }
        [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %ld",self.entity.likeCount] forState:UIControlStateNormal];



    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"喜爱失败"];
  
    }];
}

- (void)imageButtonAction
{
    EntityViewController * VC = [[EntityViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.entity = self.entity;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}




@end
