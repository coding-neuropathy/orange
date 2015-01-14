       //
//  SelectionCell.m
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SelectionCell.h"
#import "MLEmojiLabel.h"

#define kWidth (kScreenWidth - 20)
@interface SelectionCell()<MLEmojiLabelDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *tmp;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MLEmojiLabel *emojiLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *timeButton;

@end

@implementation SelectionCell


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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
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
    
    if (!self.image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 17.0f,kScreenWidth -30, 280)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.backgroundColor = [UIColor whiteColor];
        self.image.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
        self.image.layer.borderWidth = 1;
        [self.contentView addSubview:self.image];
    }
    __block UIImageView *block_img = self.image;
    __block UIImageView *tmp_img = self.tmp;
    __weak __typeof(&*self)weakSelf = self;
    {
        [self.image sd_setImageWithURL:self.entity.imageURL_640x640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth-30, 280)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL*imageURL) {
            tmp_img = [[UIImageView alloc]initWithImage:image];
            if (tmp_img.frame.size.width<280&&tmp_img.frame.size.height<280) {
                block_img.contentMode = UIViewContentModeCenter;
            }
            else
            {
                block_img.contentMode = UIViewContentModeScaleAspectFit;
            }
            if (image && cacheType == SDImageCacheTypeNone) {
                block_img.alpha = 0.0;
                [UIView animateWithDuration:0.25 animations:^{
                    block_img.alpha = 1.0;
                }];
            }
            [weakSelf.activityIndicator stopAnimating];
            weakSelf.activityIndicator.hidden = YES;

        }];
    }
    
    [self.emojiLabel setText:self.note.text];
    self.emojiLabel.frame = CGRectMake(15.0f, self.image.deFrameBottom +15, kScreenWidth - 30, [[self class] heightForEmojiText:self.note.text]);
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.emojiLabel];
    
    
    if (!self.likeButton) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.likeButton.layer.masksToBounds = YES;
        self.likeButton.layer.cornerRadius = 2;
        self.likeButton.backgroundColor = [UIColor clearColor];
        self.likeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.likeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.likeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.likeButton setTitleColor:UIColorFromRGB(0x4d4d4f) forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString fontAwesomeIconStringForEnum:FAHeart],self.entity.likeCount] forState:UIControlStateNormal];
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,3, 0, 0)];
        [self.contentView addSubview:self.likeButton];        
    }
    self.likeButton.deFrameLeft = self.emojiLabel.deFrameLeft;
    self.likeButton.deFrameTop = self.emojiLabel.deFrameBottom;
    [self.likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x4d4d4f) forState:UIControlStateNormal];
        [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.date stringWithDefaultFormat]] forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }
    self.timeButton.deFrameRight = self.emojiLabel.deFrameRight;
    self.timeButton.deFrameTop = self.emojiLabel.deFrameBottom;
    [self.timeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [MLEmojiLabel new];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:14.0f];
        _emojiLabel.delegate = self;
        _emojiLabel.backgroundColor = [UIColor clearColor];
        _emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _emojiLabel.textColor = [UIColor blackColor];
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
        protypeLabel.font = [UIFont systemFontOfSize:14.0f];
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

#pragma mark - Action
- (void)likeButtonAction
{

}


@end
