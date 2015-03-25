//
//  Config.h
//
//  Created by huiter on 13-9-10.
//  Copyright (c) 2013年 huiter. All rights reserved.
//

#define kBaseURL @"http://api.guoku.com/mobile/v4/"
//#define kBaseURL @"http://127.0.0.1:8000/mobile/v4/"
#define kApiKey @"0b19c2b93687347e95c6b6f5cc91bb87"
#define kApiSecret @"47b41864d64bd46"

//#ifndef kAppID_iPhone
//#define kAppID_iPhone @"939493680"
//#endif

#ifndef kTTID_IPHONE
#define kTTID_IPHONE @"400000_12313170@guoku_iphone"
#endif

#ifndef kGK_AppID_iPhone
#define kGK_AppID_iPhone @"477652209"
#endif

// umeng
#define UMENG_APPKEY @"5219f06856240bd4ab01407a"


// weibo
#ifndef kGK_WeiboAPPKey
#define kGK_WeiboAPPKey @"1459383851"
#endif

#ifndef kGK_WeiboSecret
#define kGK_WeiboSecret @"bfb2e43c3fa636f102b304c485fa2110"
#endif

#ifndef kGK_WeiboRedirectURL
#define kGK_WeiboRedirectURL @"http://www.guoku.com/sina/auth"
#endif

//weixin
#ifndef kGK_WeixinShareKey
#define kGK_WeixinShareKey	@"wx728e94cbff8094df"		//REPLACE ME
#endif

#ifndef kGK_WeixinShareURL
#define kGK_WeixinShareURL @"http://www.guoku.com/detail/"  //apisent
#endif

//taobaoke
#ifndef kGK_TaobaoKe_PID
#define kGK_TaobaoKe_PID @"mm_28514026_4132785_24810648"
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

#ifndef k_isLogin
#define k_isLogin [Passport sharedInstance].user
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

#define CategoryGroupArrayKey @"CategoryGroupArray"
#define CategoryGroupArrayWithStatusKey @"CategoryGroupArrayWithStatus"
#define AllCategoryArrayKey @"AllCategoryArray"

#ifndef kSeparateLineWidth
#define kSeparateLineWidth 0.5f
#endif
