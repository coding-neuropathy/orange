//
//  NoteSingleListCell.h
//  Blueberry
//
//  Created by huiter on 13-10-23.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteSingleListCell : UITableViewCell

@property (nonatomic, strong) GKNote *note;

+ (CGFloat)height:(GKNote *)note;

@end
