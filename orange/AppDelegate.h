//
//  AppDelegate.h
//  Guoku
//
//  Created by 回特 on 14-9-26.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * root;
@property (strong, nonatomic) UIViewController * activeVC;
@property (strong, nonatomic) NSMutableArray *allCategoryArray;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (assign, nonatomic) NSUInteger messageCount;

@property (strong, nonatomic) NSArray   *adDataArray;


@end

