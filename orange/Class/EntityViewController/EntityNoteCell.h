//
//  EntityNoteCell.h
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EntityNoteCellDelegate <NSObject>

- (void)tapPokeNoteBtn:(id)sender Note:(GKNote *)note;
@optional
- (void)swipLeftWithContentView:(UIView *)view;
- (void)handleCellEditBtn:(GKNote *)note;

@end

@interface EntityNoteCell : UICollectionViewCell

@property (strong, nonatomic) GKNote * note;
@property (weak, nonatomic) id<EntityNoteCellDelegate> delegate;

+ (CGFloat)height:(GKNote *)note;

@end
