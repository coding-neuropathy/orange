//
//  TodayViewCell.m
//  orange
//
//  Created by 谢 家欣 on 15/4/2.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "TodayViewCell.h"
#import "core.h"

@interface TodayViewCell ()

@property (strong, nonatomic) UIImageView * entityImageView;

@end

@implementation TodayViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.textColor = UIColorFromRGB(0xffffff);
        self.textLabel.font = [UIFont systemFontOfSize:16.];
        self.textLabel.numberOfLines = 1;
        
        self.detailTextLabel.textColor = UIColorFromRGB(0x9c9c9c);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.];
        self.detailTextLabel.numberOfLines = 2;
//        self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
//        self.backgroundColor = [UIColor redColor];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)entityImageView;
{
    if (!_entityImageView) {
        _entityImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _entityImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_entityImageView];
    }
    return _entityImageView;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    self.textLabel.text = _data[@"content"][@"entity"][@"title"];
    self.detailTextLabel.text = _data[@"content"][@"note"][@"content"];
    NSString * urlstring =  _data[@"content"][@"entity"][@"chief_image"];
    
//    [self.entityImageView sd_setImageWithURL:[NSURL URLWithString:[self imageURLWithURLString:urlstring Size:120.]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[self imageURLWithURLString:urlstring Size:120.]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *placeholder = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.entityImageView setImage:placeholder];
        });
    });

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.entityImageView.frame = CGRectMake(kScreenWidth - 50, 10., 40, 40.);
    self.textLabel.frame = CGRectMake(10, 10., kScreenWidth - 60., 20.);
    self.detailTextLabel.frame = CGRectMake(10., 30., kScreenWidth - 60., 20.);
//    self.detailTextLabel.frame
}

- (NSString *)imageURLWithURLString:(NSString *)urlstring Size:(NSInteger)size
{
    
    if ([urlstring hasPrefix:@"http://imgcdn.guoku.com/"]) {
        NSString * uri_string = [urlstring stringByReplacingOccurrencesOfString:@"http://imgcdn.guoku.com/" withString:@""];
        
        NSMutableArray * array = [NSMutableArray arrayWithArray:[uri_string componentsSeparatedByString:@"/"]];
        
        [array insertObject:[NSNumber numberWithInteger:size] atIndex:1];
        //        NSLog(@"%@", array);
        NSString * image_uri_string = [[array valueForKey:@"description"] componentsJoinedByString:@"/"];
        //    NSLog(@"%@", image_uri_string);
        
        return [NSString stringWithFormat:@"http://imgcdn.guoku.com/%@", image_uri_string];
    }
    return urlstring;
}

@end
