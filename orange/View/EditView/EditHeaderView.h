//
//  EditHeaderView.h
//  orange
//
//  Created by 谢家欣 on 15/3/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditHeaderViewDelegate <NSObject>

- (void)TapPhotoBtn:(id)sender;

@end

@interface EditHeaderView : UIView

@property (strong, nonatomic) NSURL * avatarURL;
@property (weak, nonatomic) id<EditHeaderViewDelegate> delegate;

@end
