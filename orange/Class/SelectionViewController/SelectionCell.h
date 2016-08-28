//
//  SelectionCell.h
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

@protocol SelectionCellDelegate <NSObject>

- (void)TapEntityImage:(GKEntity *)entity;

@end

@interface SelectionCell : UICollectionViewCell


@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) NSDictionary * dict;

@property (nonatomic, strong) UIImageView *image;

@property (assign, nonatomic) id<SelectionCellDelegate> delegate;

+ (CGFloat)height:(GKNote *)note;



@end
