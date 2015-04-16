//
//  AppDelegate.m
//  Guoku
//
//  Created by 回特 on 14-9-26.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "AppDelegate.h"
//#import "EmojiOne.h"
#import "WXApi.h"
#import "TabBarViewController.h"
#import "GKAPI.h"
#import "EntityViewController.h"
#import "UserViewController.h"
#import "CategoryViewController.h"
#import "TagViewController.h"
#import "IntruductionVC.h"
#import "WelcomeVC.h"

int ddLogLevel;

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configLog];
    
    [AVOSCloud setApplicationId:@"laier6ulcszfjkn08448ng37nwc71ux4uv6yc6vi529v29a0" clientKey:@"6ad7o8urhbw4q5kx8hfoiaxjjtme205ohodgoy6ltwts8b1i"];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
    [AVPush setProductionMode:YES];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVAnalytics setCrashReportEnabled:YES];
//    [AVAnalytics setChannel:@"91"];
    
    // umeng
    [MobClick setLogEnabled:NO];
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];

    [MobClick updateOnlineConfig];
//    
//    [UMOpus setAudioEnable:YES];
//    [UMFeedback setAppkey:UMENG_APPKEY];
//    [UMFeedback setLogEnabled:YES];
//    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
//    
    // wechat
    [WXApi registerApp:kGK_WeixinShareKey];
    
    [[TaeSDK sharedInstance] setTaeSDKEnvironment:TaeSDKEnvironmentRelease];
    [[TaeSDK sharedInstance] setAppVersion:@"4.0.0"];
    [[TaeSDK sharedInstance] setDebugLogOpen:YES];
    //sdk初始化
    [[TaeSDK sharedInstance] asyncInit:^{
        NSLog(@"初始化成功");
    } failedCallback:^(NSError *error) {
        NSLog(@"初始化失败:%@",error);
    }];
    
    //插件版登录状态监听
    id<ALBBLoginService> loginService = [[TaeSDK sharedInstance]getService:@protocol(ALBBLoginService)];
    [loginService setSessionStateChangedHandler:^(TaeSession *session) {
        if([session isLogin]){//未登录变为已登录
            NSLog(@"【插件版监听：用户login】");
        }else{//已登录变为未登录
            NSLog(@"【插件版监听：用户logout】");
        }
    }];

    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedV4"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedV4"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchV4"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self customizeAppearance];

    // Override point for customization after application launch.
    
    if (iOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:[NSSet setWithObjects:nil]];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }else{
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(0x2b2b2b)];
    [SVProgressHUD setForegroundColor:UIColorFromRGB(0xffffff)];
    

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[TabBarViewcontroller alloc]init];
    self.window.rootViewController.view.hidden = YES;
    [self.window makeKeyAndVisible];
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo)
    {
        application.applicationIconBadgeNumber = 0;
        self.window.rootViewController.view.hidden = NO;
    }
    else
    {
        self.window.rootViewController.view.hidden = YES;
        WelcomeVC * welcomeVc = [[WelcomeVC alloc] init];
        [self.window.rootViewController presentViewController: welcomeVc animated:NO completion:NULL];
    }
    
    
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.windowLevel = 100;
    UIViewController *vc = [[UIViewController alloc] init];
    self.alertWindow.rootViewController = vc;
    
    
    [self refreshCategory];
    
    {    NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:240.0f
                                                             target:self
                                                           selector:@selector(checkNewMessage)
                                                           userInfo:nil
                                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [self performSelector:@selector(checkNewMessage) withObject:nil afterDelay:4];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Save" object:nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Save" object:nil userInfo:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if([[url absoluteString]hasPrefix:@"wx"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return [AVOSCloudSNS handleOpenURL:url];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[AVUser currentUser] forKey:@"owner"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}



- (void)onResp:(BaseResp *)resp
{
    if(resp.errCode == 0)
    {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
        });
        
    } else {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showImage:nil status:@"分享失败\U0001F628"];
        });
        
    }
}

-(void)customizeAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"nav_bar_bg.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(1, 0.5)] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage imageNamed:@"shadow.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
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
    [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xffffff)];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0xffffff)];
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0xffffff)];

}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    NSLog(@"url url %@", url);
    
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
    
    if([[url absoluteString]hasPrefix:@"guoku"])
    {
        NSString *absoluteString = [[url absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [absoluteString rangeOfString:@"entity/"];
        if (range.location != NSNotFound) {
            NSString *entityId = [absoluteString substringFromIndex:range.location+range.length];
            EntityViewController *vc = [[EntityViewController alloc]init];
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
                CategoryViewController * vc = [[CategoryViewController alloc]init];
                vc.category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId.integerValue)}];
                vc.hidesBottomBarWhenPushed = YES;
                if (self.activeVC.navigationController) {
                    [self.activeVC.navigationController pushViewController:vc animated:YES];
                }
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
    
    return YES;
}



- (void)refreshCategory
{
    
    [GKAPI getAllCategoryWithSuccess:^(NSArray *fullCategoryGroupArray) {
        
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
    }
    
    [GKAPI getUnreadCountWithSuccess:^(NSDictionary *dictionary) {
        if (dictionary[@"unread_message_count"]) {
            self.messageCount = [dictionary[@"unread_message_count"] unsignedIntegerValue];
            if (self.messageCount != 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBadge" object:nil userInfo:nil];
            }
        }
    } failure:^(NSInteger stateCode) {
        
    }];
}

#pragma mark - config log
- (void)configLog
{
    ddLogLevel = LOG_LEVEL_VERBOSE;
    //ddLogLevel = LOG_LEVEL_OFF;
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
