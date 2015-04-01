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
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];;
        self.detailTextLabel.textColor = UIColorFromRGB(0x9d9e9f);
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
//    NSLog(@"text %@", [Passport sharedInstance].user.taobaoScreenName);
    self.textLabel.text = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
    
    if([_text isEqualToString:@"version"]) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    if ([_text isEqualToString:@"weibo"] && [Passport sharedInstance].user.sinaScreenName) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.detailTextLabel.text = [NSString stringWithFormat:@"@%@", [Passport sharedInstance].user.sinaScreenName];
//        NSLog(@"weibo screen name %@", [Passport sharedInstance].user.sinaScreenName);
    } else {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.detailTextLabel.text = nil;
    }
    
    
    if ([_text isEqualToString:@"taobao"] && [Passport sharedInstance].user.taobaoScreenName){
        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Passport sharedInstance].user.taobaoScreenName];
    }
    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15., 0., kScreenWidth - 130., self.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(kScreenWidth - 115., 0., 100, self.frame.size.height);
//    NSLog(@"%@", self.accessoryView);
//    self.accessoryView = self.detailTextLabel;
}

@end
