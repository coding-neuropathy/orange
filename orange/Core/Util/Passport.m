//
//  Passport.m
//  Blueberry
//
//  Created by 魏哲 on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "Passport.h"
#import "KeyAndTag.h"


@interface Passport ()
@property (nonatomic, strong) id<ALBBLoginService> loginService;
@end

@implementation Passport

#pragma mark - class method
+ (Passport *)sharedInstance
{
    static Passport *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return  sharedInstance;
}

+ (void)logout
{
    [Passport sharedInstance].user = nil;
    [NSObject removeFromUserDefaultsByKey:CurrentUserKey];
    
    [Passport sharedInstance].session = nil;
    [NSObject removeFromUserDefaultsByKey:SessionKey];
    
    [Passport sharedInstance].sinaUserID = nil;
    [NSObject removeFromUserDefaultsByKey:SinaUserIDKey];
    
    [Passport sharedInstance].screenName = nil;
    
    [Passport sharedInstance].sinaToken = nil;

    
    [Passport sharedInstance].sinaExpirationDate = nil;

    
    [Passport sharedInstance].taobaoId = nil;

    
    [Passport sharedInstance].taobaoToken = nil;
    
    [[Passport sharedInstance] logout];

}

- (id)init
{
    self = [super init];
    if (self) {
        GKUser *user = (GKUser *)[NSObject objectFromUserDefaultsByKey:CurrentUserKey];
        if (user) {
            [user performSelector:@selector(saveToCenter)];
            self.user = [GKUser modelFromDictionary:@{@"userId":@(user.userId)}];
        }
        
        NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:SessionKey];
        self.session = session;
        
        NSString *sinaUserID = [[NSUserDefaults standardUserDefaults] objectForKey:SinaUserIDKey];
        self.sinaUserID = sinaUserID;
        NSString *sinaToken = [[NSUserDefaults standardUserDefaults] objectForKey:SinaTokenKey];
        self.sinaToken = sinaToken;
        NSDate *sinaExpirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:SinaExpirationDateKey];
        self.sinaExpirationDate = sinaExpirationDate;
        
        _loginService = [[TaeSDK sharedInstance] getService:@protocol(ALBBLoginService)];
    }
    return self;
}

- (void)logout
{
    [self.loginService logout];
    
    [AVUser logOut];
    if (![AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo]) {
        [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
    }
}

- (void)setSession:(NSString *)session
{
    _session = session;
    if (self.session) {
        [[NSUserDefaults standardUserDefaults] setValue:self.session forKey:SessionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setUser:(GKUser *)user
{
    _user = user;
    if (self.user) {
        [self.user saveToUserDefaultsForKey:CurrentUserKey];
    }
}

- (void)setSinaUserID:(NSString *)sinaUserID
{
    _sinaUserID = sinaUserID;
    if (self.sinaUserID) {
        [[NSUserDefaults standardUserDefaults] setValue:self.sinaUserID forKey:SinaUserIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setScreenName:(NSString *)sinaNickName
{
    _screenName = sinaNickName;
    if (self.screenName) {
        [[NSUserDefaults standardUserDefaults] setValue:self.screenName forKey:SinaNickNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [NSObject removeFromUserDefaultsByKey:SinaNickNameKey];
    }
}

- (void)setSinaAvatarURL:(NSString *)sinaAvatarURL
{
    _sinaAvatarURL = sinaAvatarURL;
    if (self.sinaAvatarURL) {
        [[NSUserDefaults standardUserDefaults] setValue:self.sinaAvatarURL forKey:SinaAvatarURLKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setSinaToken:(NSString *)sinaToken
{
    _sinaToken = sinaToken;
    if (self.sinaToken) {
        [[NSUserDefaults standardUserDefaults] setValue:self.sinaToken forKey:SinaTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setSinaExpirationDate:(NSDate *)sinaExpirationDate
{
    _sinaExpirationDate = sinaExpirationDate;
    if (self.sinaExpirationDate) {
        [[NSUserDefaults standardUserDefaults] setValue:self.sinaExpirationDate forKey:SinaExpirationDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setTaobaoId:(NSString *)taobaoId
{
    _taobaoId = taobaoId;
    if (self.taobaoId) {
        [[NSUserDefaults standardUserDefaults] setValue:self.taobaoId forKey:TaobaoIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setTaobaoToken:(NSString *)taobaoToken
{
    _taobaoToken = taobaoToken;
    if (self.taobaoToken) {
        [[NSUserDefaults standardUserDefaults] setValue:self.taobaoToken forKey:TaobaoTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
