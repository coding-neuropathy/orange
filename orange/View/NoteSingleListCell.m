//
//  NoteSingleListCell.m
//  Blueberry
//
//  Created by huiter on 13-10-23.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "NoteSingleListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RTLabel.h"
#import "EntityViewController.h"


#define kWidth (kScreenWidth - 20)
@interface NoteSingleListCell()<RTLabelDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UIView *H;
@property (nonatomic, strong) UIButton *timeButton;



@end

@implementation NoteSingleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
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
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10.f, 100,100)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:self.image];
        self.image.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageButtonAction)];
        [self.image addGestureRecognizer:tap];
    }

    {
        [self.image sd_setImageWithURL:self.note.entityChiefImage_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(240, 240)] options:SDWebImageRetryFailed completed:NULL];
    }
    
    if(!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(120, 20, kScreenWidth - 130, 20)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 7.0;
        self.contentLabel.delegate = self;
        [self.contentView addSubview:self.contentLabel];
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^414243' size=14>%@</font>", self.note.text];
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = 20;
    

    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.note.createdDate stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.deFrameRight = kScreenWidth - 10;
    self.timeButton.deFrameBottom =  self.contentView.deFrameHeight -5;
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
}

+ (CGFloat)height:(GKNote *)note
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth -130, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 7.0;
    label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", note.text];

    
    CGFloat h = label.optimumSize.height+5.0f + 50;
    
    if (h<120) {
        return 120;
    }
    else
    {
        return h;
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

- (void)imageButtonAction
{
    EntityViewController * VC = [[EntityViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.entity = [GKEntity modelFromDictionary:@{@"entityId":@([self.note.entityId integerValue])}];
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

@end
