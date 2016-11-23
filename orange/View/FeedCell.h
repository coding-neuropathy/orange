//
//  FeedCell.h
//  orange
//
//  Created by huiter on 15/1/23.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FeedType) {
    /**
     *  默认类型
     */
    FeedTypeDefault = 0,
    FeedEntityNote,
    FeedUserFollower,
    FeedUserLike,
    FeedArticleDig,
};

@interface FeedCell : UITableViewCell

@property (strong, nonatomic)   NSDictionary *feed;

@property (copy, nonatomic)     void (^tapLinkBlock)(NSURL *url);
@property (copy, nonatomic)     void (^tapImageBlock)(FeedType type);


+ (CGFloat)height:(NSDictionary *)feed;

@end
