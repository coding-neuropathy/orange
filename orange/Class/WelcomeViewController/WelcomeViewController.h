//
//  WelcomeViewController.h
//  pomelo
//
//  Created by 谢家欣 on 15/6/2.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import "IFTTTJazzHands.h"

@interface WelcomeViewController : IFTTTAnimatedScrollViewController <IFTTTAnimatedScrollViewControllerDelegate>

@property (nonatomic, copy) void (^finished)();

@end
