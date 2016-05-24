//
//  MenuCell.m
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()

@property (strong, nonatomic) UIImageView * iconView;

@end

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = UIColorFromRGB(0x9d9e9f);
        self.textLabel.font = [UIFont systemFontOfSize:10.];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (UIImageView *)iconView
{
    if(!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        //        _iconView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (void)setText:(NSString *)text
{
    _text = text;
    //    self.ti.text = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
    self.textLabel.text = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
    //    self.iconView.image = [UIImage imageNamed:@"star.png"];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(32., 10., 20., 20.);
    self.textLabel.frame = CGRectMake(0., 0., 84, 20.);
    self.textLabel.deFrameTop = self.iconView.deFrameBottom + 5.;
    //    self.textLabel.deFrameLeft = 32.;
    
    if (self.isSelected) {
        NSString * imageName = [self.text stringByAppendingString:@"_ipad_press"];
        self.iconView.image = [UIImage imageNamed:imageName];
        self.textLabel.textColor = UIColorFromRGB(0xffffff);
    } else {
        NSString * imageName = [self.text stringByAppendingString:@"_ipad"];
        self.iconView.image = [UIImage imageNamed:imageName];
        self.textLabel.textColor = UIColorFromRGB(0x9d9e9f);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [self setNeedsLayout];
}

@end
