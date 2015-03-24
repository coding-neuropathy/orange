//
//  FeedCell.h
//  orange
//
//  Created by huiter on 15/1/23.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *feed;

+ (CGFloat)height:(NSDictionary *)feed;

@end
