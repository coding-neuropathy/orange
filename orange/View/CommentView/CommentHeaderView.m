//
//  CommentHeaderView.m
//  orange
//
//  Created by 谢家欣 on 15/3/13.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "CommentHeaderView.h"
#import "RTLabel.h"
@interface CommentHeaderView ()<RTLabelDelegate>

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UIButton *pokeButton;
@property (nonatomic, strong) UIButton *timeButton;
@property (strong, nonatomic) UILabel * starLabel;

@end

@implementation CommentHeaderView

@synthesize delegate = _delegate;

+ (CGFloat)height:(GKNote *)note
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:IS_IPHONE?CGRectMake(60, 0, kScreenWidth -70, 20):CGRectMake(60, 0, kScreenWidth - kTabBarWidth -70, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 7.0;
    label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", note.text];
    return label.optimumSize.height + 100.f;
}

- (UIImageView *)avatar
{
    if(!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatar.layer.masksToBounds = YES;
        
        _avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(avatarButtonAction:)];
        [_avatar addGestureRecognizer:tap];
        [self addSubview:_avatar];
    }
    return _avatar;
}

- (RTLabel *)label
{
    if (!_label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectZero];
        _label.paragraphReplacement = @"";
        _label.lineSpacing = 7.0;
        _label.delegate = self;
        [self addSubview:_label];
    }
    return _label;
}

- (RTLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.paragraphReplacement = @"";
        _contentLabel.lineSpacing = 7.;
        _contentLabel.delegate = self;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)pokeButton
{
    if (!_pokeButton) {
        _pokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pokeButton.layer.masksToBounds = YES;
        _pokeButton.layer.cornerRadius = 2;
        _pokeButton.backgroundColor = [UIColor clearColor];
        _pokeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        _pokeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _pokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_pokeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [_pokeButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateSelected];
        [_pokeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [_pokeButton addTarget:self action:@selector(pokeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pokeButton];
    }
    return _pokeButton;
}

- (UIButton *)timeButton
{
    if (!_timeButton) {
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeButton.layer.masksToBounds = YES;
        _timeButton.backgroundColor = [UIColor clearColor];
        _timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        _timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_timeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        
        [self addSubview:_timeButton];
    }
    return _timeButton;
}

- (UILabel *)starLabel
{
    if (!_starLabel) {
        _starLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _starLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        _starLabel.textAlignment = NSTextAlignmentRight;
        //        _starLabel.hidden = YES;
        _starLabel.backgroundColor = [UIColor clearColor];
        _starLabel.textColor = UIColorFromRGB(0xFF9600);
        _starLabel.text = [NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAStar]];
        [self addSubview:_starLabel];
    }
    return _starLabel;
}


- (void)setNote:(GKNote *)note
{
    _note = note;
    
    [self.avatar sd_setImageWithURL:self.note.creator.avatarURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(60, 60)]];
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%ld'><font face='Helvetica-Bold' color='^427ec0' size=14>%@ </font></a>", self.note.creator.userId, self.note.creator.nickname];
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^414243' size=14>%@</font>", self.note.text];
    
    self.pokeButton.selected = self.note.poked;
    [self.pokeButton setTitle:[NSString stringWithFormat:@"%@ %lu",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp],self.note.pokeCount] forState:UIControlStateNormal];
    if (self.note.pokeCount ==0) {
        [self.pokeButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAThumbsOUp]] forState:UIControlStateNormal];
    }

    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.note.createdDate stringWithDefaultFormat]] forState:UIControlStateNormal];
    
    self.starLabel.hidden = YES;
    if (self.note.marked) {
        self.starLabel.hidden = NO;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatar.frame = CGRectMake(10.f, 20.f, 36.f, 36.f);
    self.avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    self.label.frame = IS_IPHONE?CGRectMake(56., 20., kScreenWidth - 70., 20.):CGRectMake(56., 20., kScreenWidth - kTabBarWidth - 70., 20.);
    self.contentLabel.frame = IS_IPHONE?CGRectMake(56, 20, kScreenWidth - 70, 20):CGRectMake(56, 20, kScreenWidth - kTabBarWidth- 70, 20);
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.;
    self.contentLabel.deFrameTop = self.label.deFrameBottom + 5.;
    self.pokeButton.frame = CGRectMake(0, 0, 50, 20);
    self.pokeButton.deFrameLeft = self.contentLabel.deFrameLeft;
    self.pokeButton.deFrameBottom = self.deFrameHeight - 15;
    
    self.timeButton.frame = CGRectMake(0, 0, 160, 20);
    self.timeButton.deFrameRight = IS_IPHONE?kScreenWidth - 10:kScreenWidth - kTabBarWidth - 10;
    self.timeButton.deFrameBottom =  self.deFrameHeight -15;

    self.starLabel.frame = CGRectMake(0., 0., 160., 20.);
    self.starLabel.center = self.label.center;
    self.starLabel.deFrameRight = IS_IPHONE?kScreenWidth - 16.:kScreenWidth  - kTabBarWidth- 16.;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)avatarButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapAvatarButtonAction:)]) {
        [_delegate TapAvatarButtonAction:sender];
    }
}

- (void)pokeButtonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapPokeButtonAction:)]) {
        [_delegate TapPokeButtonAction:sender];
    }
}

@end
