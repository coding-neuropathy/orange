//
//  SignInCell.m
//  orange
//
//  Created by 谢 家欣 on 15/5/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SignInCell.h"

@implementation SignInCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(JXUserSignStyle)type
{
    _type = type;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
