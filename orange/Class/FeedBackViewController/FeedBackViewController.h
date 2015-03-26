//
//  FeedBackViewController.h
//  orange
//
//  Created by 谢家欣 on 15/3/26.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"


typedef NS_ENUM(NSInteger, FeedBackType) {
    /**
     *  默认类型
     */
    FeedBackTypeDefault = 0,
    FeedBackTypeModal,
};

@interface FeedBackViewController : JSQMessagesViewController

@property (assign, nonatomic) FeedBackType type;

+ (UINavigationController *)feedbackModalViewController;

@end
