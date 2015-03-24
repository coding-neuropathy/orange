//
//  EditViewCell.m
//  orange
//
//  Created by 谢家欣 on 15/3/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EditViewCell.h"

@implementation EditViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        self.textLabel.textColor = UIColorFromRGB(0x414243);
        self.textLabel.highlightedTextColor = UIColorFromRGB(0x414243);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        self.detailTextLabel.textColor = UIColorFromRGB(0x9d9e9f);
        self.detailTextLabel.highlightedTextColor = UIColorFromRGB(0x9d9e9f);
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}



- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.textLabel.text = _dict[@"key"];
    self.detailTextLabel.text = _dict[@"value"];
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20., 0., 100., 44.);
    self.detailTextLabel.frame = CGRectMake(kScreenWidth - 200., 0., 150., 44.);
}

@end
