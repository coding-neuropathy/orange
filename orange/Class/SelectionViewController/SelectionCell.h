//
//  SelectionCell.h
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//



@interface SelectionCell : UICollectionViewCell

@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) GKEntityCategory * category;
@property (nonatomic, strong) NSDate * date;

@property (nonatomic, strong) NSDictionary * dict;

+ (CGFloat)height:(GKNote *)note;

@end
