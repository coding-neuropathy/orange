//
//  NoteCell.h
//  orange
//
//  Created by huiter on 15/1/27.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface NoteCell : UITableViewCell<RTLabelDelegate>
@property (nonatomic, strong) UIView *H;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *pokeButton;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) GKNote *note;


+ (CGFloat)height:(GKNote *)note;
@end
