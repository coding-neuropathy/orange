//
//  CommentHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/3/13.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentHeaderViewDelegate <NSObject>

- (void)TapAvatarButtonAction:(id)sender;
- (void)TapPokeButtonAction:(id)sender;
@end

@interface CommentHeaderView : UIView

@property (strong, nonatomic) GKNote * note;
@property (strong, nonatomic) id<CommentHeaderViewDelegate> delegate;

+ (CGFloat)height:(GKNote *)note;

@end
