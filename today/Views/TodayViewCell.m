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
@property (strong, nonatomic) GKEntity * entity;

@end

@implementation TodayViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.textColor = UIColorFromRGB(0xffffff);
        self.textLabel.font = [UIFont systemFontOfSize:19.];
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
//        _entityImageView.image = [UIImage im]
        [self.contentView addSubview:_entityImageView];
    }
    return _entityImageView;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
//    self.textLabel.text = _data[@"content"][@"entity"][@"title"];
//    self.detailTextLabel.text = _data[@"content"][@"note"][@"content"];
//    NSString * urlstring =  _data[@"content"][@"entity"][@"chief_image"];
    self.entity = data[@"entity"];
    GKNote * note = data[@"note"];
    
    self.textLabel.text = self.entity.title;
    self.detailTextLabel.text = note.text;
    


    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.entityImageView.frame = CGRectMake(kScreenWidth - 84., 9., 76., 76.);
    self.textLabel.frame = CGRectMake(10, 10., kScreenWidth - 100., 20.);
    self.detailTextLabel.frame = CGRectMake(10., 40., kScreenWidth - 100., 40.);

    
    NSData * imageData = [self readImageWithURL:self.entity.imageURL_120x120];
    
    if (imageData) {
        self.entityImageView.image = [UIImage imageWithData:imageData];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:self.entity.imageURL_120x120];
            UIImage *placeholder = [UIImage imageWithData:data];
            [self saveImageWhthData:data URL:self.entity.imageURL_120x120];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.entityImageView setImage:placeholder];
            });
        });
    }
//    self.detailTextLabel.frame
}

- (BOOL)saveImageWhthData:(NSData *)data URL:(NSURL *)url
{
//    NSError * err = nil;
    NSString * imagefile = [url.absoluteString md5];
    
    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.guoku.iphone"];
//    NSLog(@"url %@", containerURL);
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", imagefile]];
    BOOL result = [data writeToURL:containerURL atomically:YES];
    return result;
}

- (NSData *)readImageWithURL:(NSURL *)url
{
    NSString * imagefile = [url.absoluteString md5];
    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.guoku.iphone"];
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", imagefile]];
    
    return [NSData dataWithContentsOfURL:containerURL];
//    return data;
}

//- (NSString *)imageURLWithURLString:(NSString *)urlstring Size:(NSInteger)size
//{
//    
//    if ([urlstring hasPrefix:@"http://imgcdn.guoku.com/"]) {
//        NSString * uri_string = [urlstring stringByReplacingOccurrencesOfString:@"http://imgcdn.guoku.com/" withString:@""];
//        
//        NSMutableArray * array = [NSMutableArray arrayWithArray:[uri_string componentsSeparatedByString:@"/"]];
//        
//        [array insertObject:[NSNumber numberWithInteger:size] atIndex:1];
//        //        NSLog(@"%@", array);
//        NSString * image_uri_string = [[array valueForKey:@"description"] componentsJoinedByString:@"/"];
//        //    NSLog(@"%@", image_uri_string);
//        
//        return [NSString stringWithFormat:@"http://imgcdn.guoku.com/%@", image_uri_string];
//    }
//    return urlstring;
//}

@end
