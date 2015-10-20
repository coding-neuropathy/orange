//
//  AppDelegate.m
//  Guoku
//
//  Created by 回特 on 14-9-26.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "TabBarViewController.h"
#import "EntityViewController.h"
#import "UserViewController.h"
//#import "CategoryViewController.h"
#import "TagViewController.h"
//#import "IntruductionVC.h"
//#import "WelcomeVC.h"
//#import "WelcomeViewController.h"
#import "NewVersionController.h"
#import "APService.h"
#import "GKNotificationHUB.h"
#import "tipView.h"

int ddLogLevel;

@interface AppDelegate ()<WXApiDelegate>

@property (strong, nonatomic) TabBarViewcontroller * tabbarViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configLog];
    
    [AVOSCloud setApplicationId:@"laier6ulcszfjkn08448ng37nwc71ux4uv6yc6vi529v29a0" clientKey:@"6ad7o8urhbw4q5kx8hfoiaxjjtme205ohodgoy6ltwts8b1i"];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
//    [AVPush setProductionMode:YES];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    [AVAnalytics setCrashReportEnabled:YES];
//    [AVAnalytics setChannel:@"tongbu"];
    
    // umeng
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:@"tongbu"];
    [MobClick setLogEnabled:NO];
    [MobClick updateOnlineConfig];
   
    // wechat
    [WXApi registerApp:kGK_WeixinShareKey withDescription:NSLocalizedStringFromTable(@"guide to better living", kLocalizedFile, nil)];
    
    [[TaeSDK sharedInstance] setTaeSDKEnvironment:TaeSDKEnvironmentRelease];
    [[TaeSDK sharedInstance] setAppVersion:XcodeAppVersion];
    [[TaeSDK sharedInstance] setDebugLogOpen:NO];
    //sdk初始化
    [[TaeSDK sharedInstance] asyncInit:^{
        DDLogInfo(@"初始化成功");
    } failedCallback:^(NSError *error) {
        DDLogError(@"初始化失败:%@", error);
    }];
    
    //插件版登录状态监听
    id<ALBBLoginService> loginService = [[TaeSDK sharedInstance] getService:@protocol(ALBBLoginService)];
    [loginService setSessionStateChangedHandler:^(TaeSession *session) {
        if([session isLogin]){//未登录变为已登录
            NSLog(@"【插件版监听：用户login】");
        }else{//已登录变为未登录
            NSLog(@"【插件版监听：用户logout】");
        }
    }];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self customizeAppearance];

    // Override point for customization after application launch.

    // jpush config
    [APService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge| UIUserNotificationTypeSound categories:nil];
    [APService setupWithOption:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateJPushID:) name:kJPFNetworkDidLoginNotification object:nil];
    
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(0x2b2b2b)];
    [SVProgressHUD setForegroundColor:UIColorFromRGB(0xffffff)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabbarViewController = [[TabBarViewcontroller alloc] init];
//    self.window.rootViewController = [[TabBarViewcontroller alloc] init];
    self.window.rootViewController = self.tabbarViewController;
    
//    self.window.rootViewController.view.hidden = NO;
    [self.window makeKeyAndVisible];


    application.applicationIconBadgeNumber = 0;

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchV41"])
    {
        NewVersionController * vc = [NewVersionController new];
        [self.window.rootViewController addChildViewController:vc];
        __weak __typeof(&*vc)weakVC = vc;
        __weak __typeof(&*self.tabbarViewController.selectionController)weakSelection = self.tabbarViewController.selectionController;
        vc.finished = ^(void) {
            [weakVC removeFromParentViewController];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchV41"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelection setSelectedWithType:SelectionArticleType];
            
            tipView * tip = [[tipView alloc]init];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchV4.10"])
            {
                [self.window addSubview:tip];
            }
        };
        
        vc.closeAction = ^(void) {
            [weakVC removeFromParentViewController];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchV41"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [weakSelection setSelectedWithType:SelectionArticleType];
            
            tipView * tip = [[tipView alloc]init];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchV4.10"])
            {
                [self.window addSubview:tip];
            }
        };
        
        [self.window addSubview:vc.view];
        
//        self.window.rootViewController.view.hidden = YES;

    }
    else{
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchV4.10"])
        {
            tipView * tip = [[tipView alloc]init];
            [self.window addSubview:tip];
        }
    }

    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.windowLevel = 100;
    UIViewController *vc = [[UIViewController alloc] init];
    self.alertWindow.rootViewController = vc;
    
    
    [self refreshCategory];
    
    {
        NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:240.0f
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
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
//    if (currentInstallation.badge != 0) {
//        currentInstallation.badge = 0;
//        [currentInstallation saveEventually];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Save" object:nil userInfo:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if([[url absoluteString]hasPrefix:@"wx"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return [AVOSCloudSNS handleOpenURL:url];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DDLogInfo(@"user info %@", userInfo);
    NSString * url = [userInfo valueForKey:@"url"];
    if (url && application.applicationState != UIApplicationStateActive) {
        [self openLocalURL:[NSURL URLWithString:url]];
    }
    application.applicationIconBadgeNumber = 0;
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



- (void)onResp:(BaseResp *)resp
{
//    DDLogInfo(@"resp %@", resp);
//    NSInteger wechatType = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:kWechatType] integerValue];
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case 0:
            {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
                });
            }
                break;
                
            default:
            {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [SVProgressHUD showImage:nil status:@"分享失败\U0001F628"];
                });
            }
                break;
        }
    }
    
    if([resp isKindOfClass:[SendAuthResp class]]) {
//        DDLogInfo(@"resp %@", [(SendAuthResp *)resp code]);
        switch (resp.errCode) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WechatAuthResp" object:resp];
                break;
                
            default:
                break;
        }
        
    }

}

-(void)customizeAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(10, 10)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0xffffff) andSize:CGSizeMake(10, 10)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(kScreenWidth, 0.5)]];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage imageNamed:@"shadow.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x414243)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x414243)];
    //[[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"icon_back.png"]];
    UIFont* font = [UIFont boldSystemFontOfSize:17];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UIColorFromRGB(0x414243)}];
    [[UINavigationBar appearance] setAlpha:0.97];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back.png"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back.png"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];

    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x232323) andSize:CGSizeMake(kScreenWidth, 49)]];
    //[[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageWithColor:UIColorFromRGB(0x0f0f0f) andSize:CGSizeMake(kScreenWidth/4, 49)]];
//    [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xffffff)];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0xffffff)];
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0xffffff)];
    

}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([[url absoluteString]hasPrefix:@"wx"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if([[url absoluteString]hasPrefix:@"sinaweibosso"])
    {
        return [AVOSCloudSNS handleOpenURL:url];
    }
    
    if ([[url absoluteString] hasPrefix:@"tbopen23093827"]) {
        return [[TaeSDK sharedInstance] handleOpenURL:url];
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

    if([[url absoluteString] hasPrefix:@"guoku"])
    {
        NSString *absoluteString = [[url absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [absoluteString rangeOfString:@"entity/"];
        if (range.location != NSNotFound) {
            NSString *entityId = [absoluteString substringFromIndex:range.location+range.length];
            entityId = [entityId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
            EntityViewController *vc = [[EntityViewController alloc] init];
            vc.entity = [GKEntity modelFromDictionary:@{@"entityId":entityId}];
            vc.hidesBottomBarWhenPushed = YES;
            if (self.activeVC.navigationController) {
                [self.activeVC.navigationController pushViewController:vc animated:YES];
            }
        }
        else
        {
            NSRange range = [absoluteString rangeOfString:@"category/"];
            if (range.location != NSNotFound) {
                NSString *categoryId = [absoluteString substringFromIndex:range.location+range.length];
//                CategoryViewController * vc = [[CategoryViewController alloc]init];
//                vc.category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId.integerValue)}];
//                vc.hidesBottomBarWhenPushed = YES;
//                GKCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId.integerValue)}];
                [[OpenCenter sharedOpenCenter] openCategory:[GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId.integerValue)}]];
//                if (self.activeVC.navigationController) {
//                    [self.activeVC.navigationController pushViewController:vc animated:YES];
//                }
            }
            else{
                NSRange range = [absoluteString rangeOfString:@"tag/"];
                if (range.location != NSNotFound) {
                    NSString * tag = [[absoluteString substringFromIndex:range.location+range.length] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                    NSString *otherString = [absoluteString substringToIndex:range.location];
                    NSRange otherRange = [otherString rangeOfString:@"user"];
                    if (otherRange.location != NSNotFound) {
                        NSString *userId = [[otherString substringFromIndex:otherRange.location+otherRange.length]stringByReplacingOccurrencesOfString:@"/" withString:@""];
                        GKUser * user = [GKUser modelFromDictionary:@{@"userId":@(userId.integerValue)}];
                        TagViewController * vc = [[TagViewController alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.tagName = tag;
                        vc.user = user;
                        if (self.activeVC.navigationController) {
                            [self.activeVC.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }
                else
                {
                    NSRange range = [absoluteString rangeOfString:@"user/"];
                    if (range.location != NSNotFound) {
                        NSString *userId = [absoluteString substringFromIndex:range.location+range.length];
                        UserViewController * vc = [[UserViewController alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.user = [GKUser modelFromDictionary:@{@"userId":@(userId.integerValue)}];
                        if (self.activeVC.navigationController) {
                            [self.activeVC.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }
                
            }
        }
        
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
            if (dictionary[@"unread_message_count"]) {
                self.messageCount = [dictionary[@"unread_message_count"] unsignedIntegerValue];
            if (self.messageCount != 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBadge" object:nil userInfo:nil];
            }
        }
        } failure:^(NSInteger stateCode) {
        
        }];
    }
}

- (void)showNetworkStatus
{
    GKNotificationHUB * hub = [[GKNotificationHUB alloc]init];
    [hub show:[NSString stringWithFormat:@"%@  无网络链接",[NSString fontAwesomeIconStringForEnum:FAInfoCircle]]];
}

#pragma mark - config log
- (void)configLog
{
    ddLogLevel = DDLogLevelInfo;
//    ddLogLevel = DDLogLevelError;
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

#pragma mark - notification
- (void)UpdateJPushID:(NSNotification *)notifier
{
    if(!TARGET_IPHONE_SIMULATOR){
        UIDevice *device = [[UIDevice alloc] init];
        DDLogInfo(@"jpush rid %@ %@ %@", [APService registrationID], [device model], XcodeAppVersion);
    
        [API postRegisterID:[APService registrationID] Model:[device model] Version:XcodeAppVersion Success:^{
        
        } Failure:^(NSInteger stateCode) {
            DDLogError(@"error code %ld", stateCode);
        }];
    }
}

@end
