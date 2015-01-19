//
//  MessageCell.h
//  orange
//
//  Created by huiter on 15/1/18.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *message;

+ (CGFloat)height:(NSDictionary *)message;
@end
