//
//  SelectionCell.h
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//



@interface SelectionCell : UITableViewCell

@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) GKEntityCategory * category;
@property (nonatomic, strong) NSDate * date;


+ (CGFloat)heightForEmojiText:(NSString*)emojiText;

@end
