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
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        //UIColorFromRGB(0x212121);
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = UIColorFromRGB(0x212121);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        self.detailTextLabel.textColor = UIColorFromRGB(0x9d9e9f);
        self.detailTextLabel.highlightedTextColor = UIColorFromRGB(0x9d9e9f);
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.adjustsFontSizeToFitWidth = NO;
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}



- (void)setString:(NSString *)string
{
    _string = string;
    self.textLabel.text = NSLocalizedStringFromTable(string, kLocalizedFile, nil);
    
    if ([_string isEqualToString:@"nickname"])
        self.detailTextLabel.text  = [Passport sharedInstance].user.nickname;
    if ([_string isEqualToString:@"gender"])
    {
        if([[Passport sharedInstance].user.gender isEqualToString:@"M"])
            self.detailTextLabel.text = @"男";
        else if ([[Passport sharedInstance].user.gender isEqualToString:@"F"])
            self.detailTextLabel.text = @"女";
        else
            self.detailTextLabel.text = @"其他";
    }
    if ([_string isEqualToString:@"bio"])
        self.detailTextLabel.text = [Passport sharedInstance].user.bio;
    if ([_string isEqualToString:@"location"])
        self.detailTextLabel.text = [Passport sharedInstance].user.location;
    if ([_string isEqualToString:@"email"])
        self.detailTextLabel.text = [Passport sharedInstance].user.email;
    if ([_string isEqualToString:@"password"])
        self.detailTextLabel.text = @"修改密码";
    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20., 0., 100., 44.);
//    self.detailTextLabel.frame = IS_IPHONE ? CGRectMake(kScreenWidth - 250., 0., 200., 44.) : CGRectMake(kScreenWidth - kTabBarWidth - 250., 0., 200., 44.);
    self.detailTextLabel.frame = CGRectMake(0., 0., 200., 44.);
    self.detailTextLabel.deFrameRight = self.contentView.deFrameRight;
}

@end
