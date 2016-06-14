//
//  SettingsViewCell.m
//  orange
//
//  Created by 谢家欣 on 15/3/30.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SettingsViewCell.h"

@implementation SettingsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        self.textLabel.textColor = UIColorFromRGB(0X666666);
        self.textLabel.highlightedTextColor = UIColorFromRGB(0X666666);
//        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        self.backgroundColor = [UIColor redColor];
        self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];;
        self.detailTextLabel.textColor = UIColorFromRGB(0x9d9e9f);
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
//        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
    
//    if([_text isEqualToString:@"version"]) {
////        DDLogInfo(@"version %@", [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]);
//        [self setAccessoryType:UITableViewCellAccessoryNone];
//        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
    if ([_text isEqualToString:@"weibo"] && [Passport sharedInstance].user.sinaScreenName) {
//        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.detailTextLabel.text = [NSString stringWithFormat:@"@%@", [Passport sharedInstance].user.sinaScreenName];
//        NSLog(@"weibo screen name %@", [Passport sharedInstance].user.sinaScreenName);
    }
    else if ([_text isEqualToString:@"taobao"] && [Passport sharedInstance].user.taobaoScreenName){
//        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Passport sharedInstance].user.taobaoScreenName];
    }
    else if ([_text isEqualToString:@"mail"] && k_isLogin) {
        NSString * mail = [[Passport sharedInstance].user email];
        if ([[Passport sharedInstance].user mail_verified])
            self.detailTextLabel.text = [NSString stringWithFormat:@"%@", mail];
        else
            self.detailTextLabel.text = [NSString stringWithFormat:@"%@ (未验证)", mail];
        
    } else if ([_text isEqualToString:@"password"] && k_isLogin) {
//        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.detailTextLabel.text = NSLocalizedStringFromTable(@"reset password", kLocalizedFile, nil);
    }
    else {
//        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.detailTextLabel.text = nil;
    }

    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    DDLogInfo(@"frame %@", self.textLabel);
    
    self.textLabel.frame = CGRectMake(15., 0., self.deFrameWidth - 130., self.deFrameHeight);
    
    if ([self.text isEqualToString:@"mail"] || [self.text isEqualToString:@"password"]) {
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.frame = CGRectMake(self.deFrameWidth - 260., 0., 220., self.deFrameHeight);
    }
    else
        self.detailTextLabel.frame = CGRectMake(self.deFrameWidth - 115., 0., 100, self.deFrameHeight);
//    NSLog(@"%@", self.accessoryView);
//    self.accessoryView = self.detailTextLabel;
    
}

@end
