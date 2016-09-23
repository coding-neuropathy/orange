//
//  TodayViewCell.m
//  orange
//
//  Created by 谢 家欣 on 15/4/2.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "TodayViewCell.h"
//#import "core.h"

@interface TodayViewCell ()

@property (strong, nonatomic) UIImageView * entityImageView;


@end

@implementation TodayViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.textColor = UIColorFromRGB(0xffffff);
        self.textLabel.font = [UIFont boldSystemFontOfSize:17.];
        self.textLabel.numberOfLines = 1;
        
        self.detailTextLabel.textColor = UIColorFromRGB(0xebebeb);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.];
        self.detailTextLabel.numberOfLines = 2;
        
//        self.contentView.backgroundColor    = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.4];
        self.contentView.backgroundColor    = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)entityImageView;
{
    if (!_entityImageView) {
        _entityImageView                = [[UIImageView alloc] initWithFrame:CGRectZero];
        _entityImageView.deFrameSize    = CGSizeMake(76., 76.);
        _entityImageView.contentMode    = UIViewContentModeScaleAspectFill;
        _entityImageView.layer.masksToBounds = YES;
//        _entityImageView.image = [UIImage im]
        [self.contentView addSubview:_entityImageView];
    }
    return _entityImageView;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    self.entity = data[@"entity"];
    GKNote * note = data[@"note"];
    
    self.textLabel.text = self.entity.title;
    self.detailTextLabel.text = note.text;
    
    
    
//    [self.entityImageView sd_setImageWithURL:self.entity.imageURL_240x240
//                            placeholderImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f1f1f1"]
//                                                             andSize:self.entityImageView.deFrameSize] options:SDWebImageRetryFailed];
    
    NSData * imageData = [ImageCache readImageWithURL:self.entity.imageURL_240x240];
    
    if (imageData) {
        self.entityImageView.image = [UIImage imageWithData:imageData];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:self.entity.imageURL_240x240];
            UIImage *placeholder = [UIImage imageWithData:data];
            [ImageCache saveImageWhthData:data URL:self.entity.imageURL_240x240];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.entityImageView setImage:placeholder];
            });
        });
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.entityImageView.frame = CGRectMake(self.contentView.frame.size.width - 84., 9., 76., 76.);
    self.entityImageView.deFrameTop = 9.;
    self.entityImageView.deFrameRight = self.contentView.deFrameWidth - 9.;
    
    self.textLabel.frame = CGRectMake(10, 10., self.contentView.frame.size.width - 100., 20.);
    self.detailTextLabel.frame = CGRectMake(10., 40., self.contentView.frame.size.width - 100., 40.);

//    self.detailTextLabel.frame
}




@end
