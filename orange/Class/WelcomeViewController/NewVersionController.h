//
//  NewVersionController.h
//  orange
//
//  Created by 谢家欣 on 15/9/21.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "IFTTTAnimatedScrollViewController.h"

@interface NewVersionController : IFTTTAnimatedScrollViewController <IFTTTAnimatedScrollViewControllerDelegate>

@property (nonatomic, copy) void (^finished)();

@property (nonatomic, copy) void (^closeAction)();

@end
