//
//  Config.h
//
//  Created by huiter on 13-9-10.
//  Copyright (c) 2013年 huiter. All rights reserved.
//

#define kBaseURL @"http://api.guoku.com/mobile/v3/"
#define kApiKey @"0b19c2b93687347e95c6b6f5cc91bb87"
#define kApiSecret @"47b41864d64bd46"

#ifndef kAppID_iPhone
#define kAppID_iPhone @"939493680"
#endif
// Display
// Screen Height
#ifndef kScreenHeight
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

// Screen Width
#ifndef kScreenWidth
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

// Status Bar Height
#ifndef kStatusBarHeight
#define kStatusBarHeight 20.f
#endif

// Navigation Bar Height
#ifndef kNavigationBarHeight
#define kNavigationBarHeight 44.f
#endif

// Tool Bar Height
#ifndef kToolBarHeight
#define kToolBarHeight 44.f
#endif

// Tab Bar Height
#ifndef kTabBarHeight
#define kTabBarHeight 49.f
#endif


#ifndef iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif

#ifndef iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif


#define kAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifndef smile
#define smile @"\U0001F603"
#endif

#ifndef sad
#define sad @"\U0001F628"
#endif

