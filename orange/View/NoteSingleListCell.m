//
//  NoteSingleListCell.m
//  Blueberry
//
//  Created by huiter on 13-10-23.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "NoteSingleListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MLEmojiLabel.h"


#define kWidth (kScreenWidth - 20)
@interface NoteSingleListCell()<MLEmojiLabelDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) MLEmojiLabel *emojiLabel;
@property (nonatomic, strong) UIView *H;
@property (nonatomic, strong) UIButton *timeButton;



@end

@implementation NoteSingleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, self.frame.size.width, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:self.H];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setNote:(GKNote *)note
{
    if (_note) {
        [self removeObserver];
    }
    _note = note;
    [self addObserver];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    // 商品主图
    if (!self.image) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10.f, 80, 80)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:self.image];
    }

    {
        [self.image sd_setImageWithURL:self.note.entityChiefImage_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(240, 240)] options:SDWebImageRetryFailed completed:NULL];
    }
    
    
    [self.emojiLabel setText:self.note.text];
    self.emojiLabel.frame = CGRectMake(100.0f, 10, kScreenWidth - 110, [[self class] heightForEmojiText:self.note.text]);
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.emojiLabel];
    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 15)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.note.createdDate stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.deFrameRight = self.emojiLabel.deFrameRight;
    self.timeButton.deFrameBottom = self.frame.size.height-10;
    //[self.timeButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
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
        _emojiLabel.textColor = UIColorFromRGB(0x666666);
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
    
    return [protypeLabel preferredSizeWithMaxWidth: kScreenWidth - 110].height+5.0f*2;
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

}

- (void)removeObserver
{

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - Action
- (void)buttonAction
{

}


@end
