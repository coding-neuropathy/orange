//
//  AppDelegate.m
//  Guoku
//
//  Created by 回特 on 14-9-26.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "AppDelegate.h"
#import <libWeChatSDK/WXApi.h>
#import "TabBarViewController.h"
#import "iPadRootViewController.h"

#import "TagViewController.h"
#import "LaunchController.h"

#import "JPUSHService.h"
#import "GKNotificationHUB.h"
#import "Appirater.h"
#import "ThreePartHandler.h"

#if DEBUG
#import <FLEX/FLEXManager.h>
#endif


int ddLogLevel;

@interface AppDelegate ()

@property (strong, nonatomic) TabBarViewcontroller * tabbarViewController;

@end

@implementation AppDelegate

/**
 *  config umeng track
 */
- (void)umengTrack {
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
#if DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    UMConfigInstance.appKey = UMENG_APPKEY;
    
    [MobClick startWithConfigure:UMConfigInstance];

}

/**
 *  config ali baichuan
 */
- (void)configBaiChuan
{
    [[ALBBSDK sharedInstance] setTaeSDKEnvironment:TaeSDKEnvironmentRelease];
    [[ALBBSDK sharedInstance] setAppVersion:XcodeAppVersion];
#if DEBUG
    [[ALBBSDK sharedInstance] setDebugLogOpen:YES];
#else
    [[ALBBSDK sharedInstance] setDebugLogOpen:NO];
#endif
    
    [[ALBBSDK sharedInstance] asyncInit:^{
        DDLogInfo(@"初始化成功");
    } failedCallback:^(NSError *error) {
        DDLogError(@"初始化失败:%@", error);
    }];
}

/**
 *  config appirater
 */
- (void)configAppirater
{
    [Appirater setAppId:kGK_AppID_iPhone];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

/**
 *  config SVProgressHUD
 */
- (void)configSVProgressHUD
{
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.];
}

#pragma mark - config appearance
-(void)customizeAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(10, 10)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance ] setBackgroundColor:[UIColor colorFromHexString:@"#ffffff"]];

    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#ebebeb"] andSize:CGSizeMake(kScreenWidth, 1)]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#414243"]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexString:@"#414243"]];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"icon_back.png"]];
    UIFont* font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName:font,
                                                            NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#212121"]
                                                            }];
    [[UINavigationBar appearance] setAlpha:0.97];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(kScreenWidth, 49)]];
    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(kScreenWidth/4, 49)]];
    [[UITabBar appearance] setTintColor:[UIColor colorFromHexString:@"#ffffff"]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#ffffff"]];
    
    
#pragma mark - status bar config
    if (IS_IPAD) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(kScreenWidth - kTabBarWidth, 44.)] forBarMetrics:UIBarMetricsDefault];
    }
}

//进程启动但还没进入状态保存
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
     *  配置日志
     */
    [self configLog];
    
    // umeng
    [self umengTrack];
    
    //SVProgressHUD
    [self configSVProgressHUD];
    
    // wechat
    [WXApi registerApp:kGK_WeixinShareKey withDescription:NSLocalizedStringFromTable(@"guide to better living", kLocalizedFile, nil)];
    
    // weibo sdk
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:kGK_WeiboAPPKey];
    
    /**
     *  taobao baichuan sdk init
     */
    [self configBaiChuan];

    
    //插件版登录状态监听
    id<ALBBLoginService> loginService = [[ALBBSDK sharedInstance] getService:@protocol(ALBBLoginService)];
    [loginService setSessionStateChangedHandler:^(TaeSession *session) {
        if([session isLogin]){//未登录变为已登录
            DDLogInfo(@"【插件版监听：用户login】");
        }else{//已登录变为未登录
            DDLogInfo(@"【插件版监听：用户logout】");
        }
    }];
    
    
    //  userInfo为收到远程通知的内容
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        // 有推送的消息，处理推送的消息
        NSString * url = [userInfo valueForKey:@"url"];
        if (url) {
            [self openLocalURL:[NSURL URLWithString:url]];
        }
        application.applicationIconBadgeNumber = 0;
    }
    
#if DEBUG
//    DDLogInfo(@"session %@", [Passport sharedInstance].session);
#endif
    
    return YES;
}

//启动基本完成程序准备开始运行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     *  set 3d touch
     */
    if (iOS9)
        [self setDynamicAction];
    
    /**
     *
     */
    [self configAppirater];
//    [Appirater appLaunched:YES];
    
    //设置整体风格
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self customizeAppearance];
    
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
    DDLogInfo(@"session id %@", [Passport sharedInstance].session);
#endif
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    
    if (IS_IPHONE) {
        self.tabbarViewController = [[TabBarViewcontroller alloc] init];
        self.window.rootViewController = self.tabbarViewController;
    } else {
        
        self.window.rootViewController = [[iPadRootViewController alloc] init];
    }
    
    
    [self.window makeKeyAndVisible];

    // jpush config
    [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge| UIUserNotificationTypeSound categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:@"f9e153a53791659b9541eb37"
                          channel:@"app store"
                 apsForProduction:YES
            advertisingIdentifier:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateJPushID:) name:kJPFNetworkDidLoginNotification object:nil];
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString * url = [userInfo valueForKey:@"url"];
    if (url) {
            [self openLocalURL:[NSURL URLWithString:url]];
        
        application.applicationIconBadgeNumber = 0;
        [JPUSHService handleRemoteNotification:userInfo];
    }

//        application.applicationIconBadgeNumber = 0;
    
    [API getLaunchImageWithSuccess:^(GKLaunch *launch) {
        
        LaunchController * vc = [[LaunchController alloc] initWithLaunch:launch SkipSeconds:3];
    
        [self.window.rootViewController addChildViewController:vc];
        __weak __typeof(&*vc)weakVC = vc;
        vc.finished = ^(void) {
            [weakVC removeFromParentViewController];
            [self openLocalURL:launch.actionURL];
        };
        
        vc.closeAction = ^(void) {
            [weakVC removeFromParentViewController];
        };
        
        [self.window.rootViewController.view addSubview:vc.view];
        [vc show];
        
    } failure:^(NSInteger stateCode) {
        
    }];


    
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.windowLevel = 100;
    UIViewController *vc = [[UIViewController alloc] init];
    self.alertWindow.rootViewController = vc;
    
    
    [self refreshCategory];
    
    {
        NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:300.0f
                                                             target:self
                                                           selector:@selector(checkNewMessage)
                                                           userInfo:nil
                                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [self performSelector:@selector(checkNewMessage) withObject:nil afterDelay:4];
    }
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showNetworkStatus)
     name:@"GKNetworkReachabilityStatusNotReachable"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    
    return YES;
}

#pragma mark - disable rotation in iphone
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (IS_IPHONE)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Save" object:nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Save" object:nil userInfo:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[url absoluteString]hasPrefix:@"wx"])
    {
        return [WXApi handleOpenURL:url delegate:[ThreePartHandler sharedThreePartHandler]];
    }
    return [WeiboSDK handleOpenURL:url delegate:[ThreePartHandler sharedThreePartHandler]];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DDLogInfo(@"user info %@", userInfo);
    NSString * url = [userInfo valueForKey:@"url"];
//    if (url && application.applicationState != UIApplicationStateActive) {
//        [self openLocalURL:[NSURL URLWithString:url]];
//    }
    if (url) {
        [self openLocalURL:[NSURL URLWithString:url]];
    }
    application.applicationIconBadgeNumber = 0;
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([[url absoluteString] hasPrefix:@"wx"])
    {
        return [WXApi handleOpenURL:url delegate:[ThreePartHandler sharedThreePartHandler]];
    }
    if([[url absoluteString] hasPrefix:@"wb1459383851"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[ThreePartHandler sharedThreePartHandler]];
    }
    
    if ([[url absoluteString] hasPrefix:@"tbopen23093827"]) {
        return [[ALBBSDK sharedInstance] handleOpenURL:url];
    }
    
    if ([sourceApplication isEqualToString:@"com.guoku.iphone"]) {
         [self openLocalURL:url];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openLocalURL:url];
        });
    }
    return YES;
}


- (void)openLocalURL:(NSURL *)url
{
    /**
     *  open entity page
     */
    if ([[url absoluteString] hasPrefix:@"guoku://entity/"]) {
        NSString *absoluteString = [[url absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * entityId = [absoluteString stringByReplacingOccurrencesOfString:@"guoku://entity/" withString:@""];
        entityId = [entityId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        GKEntity * entity = [GKEntity modelFromDictionary:@{@"entityId":entityId}];
        [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
    }
    
    /**
     *  open category page
     */
    if ([[url absoluteString] hasPrefix:@"guoku://category"]) {
        NSString *absoluteString = [[url absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *categoryId = [absoluteString stringByReplacingOccurrencesOfString:@"guoku://category" withString:@""];
        categoryId = [categoryId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId":categoryId}];
        [[OpenCenter sharedOpenCenter] openCategory:category];
    }
    
    /**
     *  open tag page
     */
    if ([[url absoluteString] hasPrefix:@"guoku://tag/"]) {
        NSString *absoluteString = [[url absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [absoluteString rangeOfString:@"tag/"];
        if (range.location != NSNotFound) {
            NSString * tag = [[absoluteString substringFromIndex:range.location+range.length] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSString *otherString = [absoluteString substringToIndex:range.location];
            NSRange otherRange = [otherString rangeOfString:@"user"];
            if (otherRange.location != NSNotFound) {
                NSString *userId = [[otherString substringFromIndex:otherRange.location+otherRange.length]stringByReplacingOccurrencesOfString:@"/" withString:@""];
                GKUser * user = [GKUser modelFromDictionary:@{@"userId":@(userId.integerValue)}];
                TagViewController * vc = [[TagViewController alloc]init];
                if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
                vc.tagName = tag;
                vc.user = user;
                if (self.activeVC.navigationController) {
                    [self.activeVC.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
    
    /**
     *  open user page
     */
    if ([[url absoluteString] hasPrefix:@"guoku://user/"]) {
        NSString *absoluteString = [[url absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * userId = [absoluteString stringByReplacingOccurrencesOfString:@"guoku://user/" withString:@""];
        userId = [userId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        GKUser * user = [GKUser modelFromDictionary:@{@"userId":userId}];
        [[OpenCenter sharedOpenCenter] openUser:user];
    }
    
    /**
     *  open user discover
     */
    if([[url absoluteString] hasPrefix:@"guoku://discover"]) {
        [self.tabbarViewController setSelectedIndex:1];
    }
    
    
    if ([[url absoluteString] hasPrefix:@"http"])
        [[OpenCenter sharedOpenCenter] openWebWithURL:url];
}



#pragma mark - 3d touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL succeeded))completionHandler
{
//    DDLogInfo(@"OKOKOKOKO");
    if ([shortcutItem.type isEqualToString:@"com.guoku.iphone.articles"]) {
        [self.tabbarViewController setSelectedIndex:0];
        [self.tabbarViewController.selectionController setSelectedWithType:SelectionArticleType];
        
    } else if ([shortcutItem.type isEqualToString:@"com.guoku.iphone.discover"]) {
        [self.tabbarViewController setSelectedIndex:1];
    } else {
        [self.tabbarViewController setSelectedIndex:0];
        [self.tabbarViewController.selectionController setSelectedWithType:SelectionEntityType];
    }
}

#pragma mark - spotlight search
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    
    NSString *searchID = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
    if([searchID hasPrefix:@"entity"]) {
        //        NSLog(@"entity id %@", searchID);
        NSArray * stringList = [searchID componentsSeparatedByString:@":"];
        NSString * entity_id = [stringList objectAtIndex:1];
        [self openLocalURL:[NSURL URLWithString:[NSString stringWithFormat:@"guoku://entity/%@", entity_id]]];
    } else {
//        NSLog(@"entity id %@", searchID);
        NSArray * stringList = [searchID componentsSeparatedByString:@":"];
        NSString * article_id = [stringList objectAtIndex:1];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.guoku.com/articles/%@/", article_id]];
        [[OpenCenter sharedOpenCenter] openWebWithURL:url];
    }
    
//    [self openLocalURL:[NSURL URLWithString:[NSString stringWithFormat:@"guoku://entity/%@", entityID]]];
    return YES;
}

#pragma mark - get init data
- (void)refreshCategory
{
    //获取全部分类信息
    [API getAllCategoryWithSuccess:^(NSArray *fullCategoryGroupArray) {
        
        NSMutableArray *categoryGroupArray = [NSMutableArray array];
        NSMutableArray *allCategoryArray = [NSMutableArray array];
        
        for (NSDictionary *groupDict in fullCategoryGroupArray) {
            NSArray *categoryArray = groupDict[@"CategoryArray"];
            
            NSMutableArray *filteredCategoryArray = [NSMutableArray array];
            for (GKEntityCategory *category in categoryArray) {
                [allCategoryArray addObject:category];
                
                if (category.status) {
                    [filteredCategoryArray addObject:category];
                }
            }
            NSDictionary *filteredGroupDict = @{@"GroupId"       : groupDict[@"GroupId"],
                                                @"GroupName"     : groupDict[@"GroupName"],
                                                @"Status"        : groupDict[@"Status"],
                                                @"Count"         : @(categoryArray.count),
                                                @"CategoryArray" : filteredCategoryArray};
            if ([groupDict[@"Status"] integerValue] > 0) {
                [categoryGroupArray addObject:filteredGroupDict];
            }
        }
        [categoryGroupArray saveToUserDefaultsForKey:CategoryGroupArrayWithStatusKey];
        [fullCategoryGroupArray saveToUserDefaultsForKey:CategoryGroupArrayKey];
        [allCategoryArray saveToUserDefaultsForKey:AllCategoryArrayKey];
        
        self.allCategoryArray = allCategoryArray;
        
    } failure:^(NSInteger stateCode) {
        
    }];

}

-(void)checkNewMessage
{
    if (!k_isLogin) {
        return;
    } else {
        [API getUnreadCountWithSuccess:^(NSDictionary *dictionary) {
            DDLogInfo(@"user stats %@", dictionary);
            
            if (dictionary[@"unread_message_count"]) {
                self.messageCount = [dictionary[@"unread_message_count"] unsignedIntegerValue];
                if (self.messageCount != 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBadge" object:nil userInfo:nil];
                }
            }
//            NSInteger selection_count = [dictionary[@"unread_selection_count"] unsignedIntegerValue];
//            if (selection_count > 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSelectedBadge" object:nil userInfo:nil];
//            }
            
        } failure:^(NSInteger stateCode) {
            DDLogError(@"error");
        }];
    }
}

- (void)showNetworkStatus
{
    GKNotificationHUB * hub = [[GKNotificationHUB alloc]init];
    [hub show:[NSString stringWithFormat:@"%@ 无网络链接",[NSString fontAwesomeIconStringForEnum:FAInfoCircle]]];
}

/** 3D-Touch */
- (void)setDynamicAction
{
    if ([UIApplication sharedApplication].shortcutItems.count > 0) {
    
        return;
    }
    
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"goods"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"article"];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"discover"];
    
    // create several (dynamic) shortcut items
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]
                                               initWithType:@"com.guoku.iphone.goods"
                                               localizedTitle:NSLocalizedStringFromTable(@"goods", kLocalizedFile, nil)
                                               localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]
                                               initWithType:@"com.guoku.iphone.articles"
                                               localizedTitle:NSLocalizedStringFromTable(@"articles", kLocalizedFile, nil)
                                               localizedSubtitle:nil icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc]
                                               initWithType:@"com.guoku.iphone.discover"
                                               localizedTitle:NSLocalizedStringFromTable(@"discover", kLocalizedFile, nil)
                                               localizedSubtitle:nil icon:icon3 userInfo:nil];
    
    // add all items to an array
    NSArray *items = @[item3, item2, item1];
    
    // add this array to the potentially existing static UIApplicationShortcutItems
    NSArray *existingItems = [UIApplication sharedApplication].shortcutItems;
    NSArray *updatedItems = [existingItems arrayByAddingObjectsFromArray:items];
//    [UIApplication sharedApplication].shortcutItems = updatedItems;
    [[UIApplication sharedApplication] setShortcutItems:updatedItems];
}

#pragma mark - notification
- (void)UpdateJPushID:(NSNotification *)notifier
{
    if(!TARGET_IPHONE_SIMULATOR){
        UIDevice *device = [[UIDevice alloc] init];
        DDLogInfo(@"jpush rid %@ %@ %@", [JPUSHService registrationID], [device model], XcodeAppVersion);
        
        [API postRegisterID:[JPUSHService registrationID] Model:[device model] Version:XcodeAppVersion Success:^{
            
        } Failure:^(NSInteger stateCode) {
            DDLogError(@"error code %ld", (long)stateCode);
        }];
    }
}

#pragma mark - config log
- (void)configLog
{
#if DEBUG
    ddLogLevel = DDLogLevelInfo;
#else
    ddLogLevel = DDLogLevelError;
#endif
    
    // 控制台输出
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].colorsEnabled = YES;
    // 设备输出
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    // 文件输出
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}


@end
