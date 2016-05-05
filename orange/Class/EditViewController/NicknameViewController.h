//
//  NicknameViewController.h
//  orange
//
//  Created by D_Collin on 16/5/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NicknameViewControllerDelegate <NSObject>

- (void)reloadData;

@end

@interface NicknameViewController : BaseViewController

@property (nonatomic , weak)id <NicknameViewControllerDelegate> delegate;

@end
