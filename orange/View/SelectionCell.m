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
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    if (!self.image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 17.0f,kScreenWidth -30, 290)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.image];
    }
    __block UIImageView *block_img = self.image;
    __block UIImageView *tmp_img = self.tmp;
    __weak __typeof(&*self)weakSelf = self;
    {
        [self.image sd_setImageWithURL:self.entity.imageURL_310x310 placeholderImage:nil options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL*imageURL) {
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
    self.emojiLabel.frame = CGRectMake(10.0f, 400.0f, kWidth, 200);
    self.emojiLabel.backgroundColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:self.emojiLabel];
    
    
}

+ (CGFloat)heightWithNote:(GKNote *)note Entity:(GKEntity *)entity
{
    return 600;
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
        _emojiLabel.textColor = [UIColor whiteColor];
        _emojiLabel.backgroundColor = [UIColor colorWithRed:0.218 green:0.809 blue:0.304 alpha:1.000];
        
        _emojiLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
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
        protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
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


@end
