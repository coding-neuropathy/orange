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
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:12.];
        self.textLabel.numberOfLines = 2;
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
    NSString * urlstring =  _data[@"content"][@"entity"][@"chief_image"];
    
    [self.entityImageView sd_setImageWithURL:[NSURL URLWithString:[self imageURLWithURLString:urlstring Size:180]]];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.entityImageView.frame = CGRectMake(10., 10., 60., 60.);
    self.textLabel.frame = CGRectMake(74., 10., 200., 44);
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
