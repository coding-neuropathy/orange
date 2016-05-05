//
//  Config.h
//
//  Created by huiter on 13-9-10.
//  Copyright (c) 2013年 huiter. All rights reserved.
//


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

//windowColor
#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

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
#define kGK_WeixinShareKey	@"wx59118ccde8270caa"		//REPLACE ME
#endif

#ifndef KGK_WeixinSecret
#define KGK_WeixinSecret    @"2200ad1c64775d37bcb0e7f74c8a0641"
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

#ifndef iOS9
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#endif

#ifndef iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif
//
//#ifndef iOS7
//#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//#endif


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
#define kSeparateLineWidth 1.f
#endif


#ifndef kLocalizedFile
#define kLocalizedFile @"guoku"
#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}
