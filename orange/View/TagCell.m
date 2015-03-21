//
//  TagCell.m
//  Blueberry
//
//  Created by 魏哲 on 13-12-5.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "TagCell.h"

@interface TagCell ()

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *entityCountLabel;

@end

@implementation TagCell

+ (CGFloat)height
{
    return 60.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bg = [[UIView alloc]init];
        bg.backgroundColor = UIColorFromRGB(0xf6f6f6);
        self.selectedBackgroundView = bg;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *H = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, self.frame.size.width, 0.5)];
        H.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self.contentView addSubview:H];
    }
    return self;
}

- (void)setTagName:(NSString *)tagName
{
    _tagName = tagName;
    [self setNeedsLayout];
}

- (void)setEntityCount:(NSInteger)entityCount
{
    _entityCount = entityCount;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        self.tagLabel.backgroundColor = [UIColor clearColor];
        self.tagLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.tagLabel.font = [UIFont systemFontOfSize:14.f];
        self.tagLabel.textAlignment = NSTextAlignmentLeft;
        self.tagLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.tagLabel];
    }
    self.tagLabel.text = [NSString stringWithFormat:@"#%@", self.tagName];
    self.tagLabel.deFrameWidth = 200.f;
    [self.tagLabel sizeToFit];
    self.tagLabel.center = CGPointMake(0, 20);
    self.tagLabel.deFrameLeft = 15.f;
    
    if (!self.entityCountLabel) {
        _entityCountLabel = [[UILabel alloc] init];
        self.entityCountLabel.backgroundColor = [UIColor clearColor];
        self.entityCountLabel.font = [UIFont systemFontOfSize:12.f];
        self.entityCountLabel.textAlignment = NSTextAlignmentLeft;
        self.entityCountLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.entityCountLabel];
    }
    self.entityCountLabel.text = [NSString stringWithFormat:@"%ld件商品", self.entityCount];

    self.entityCountLabel.deFrameWidth = 100.f;
    [self.entityCountLabel sizeToFit];
    self.entityCountLabel.center = self.contentView.center;
    self.entityCountLabel.deFrameTop = self.tagLabel.deFrameBottom+4.f;
    self.entityCountLabel.deFrameLeft = 15.f;
    //self.entityCountLabel.deFrameLeft = self.tagLabel.deFrameRight + 8.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
