//
//  MenuController.h
//  orange
//
//  Created by 谢家欣 on 16/5/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuController;

@protocol MenuControllerDelegate <NSObject>

@optional
- (void)MenuController:(MenuController *)menucontroller didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MenuController : UIViewController

@property (nonatomic, weak) id<MenuControllerDelegate> delegate;

@end
