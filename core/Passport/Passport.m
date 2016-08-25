//
//  Passport.m
//  Blueberry
//
//  Created by 魏哲 on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "Passport.h"
#import "KeyAndTag.h"
#import <SAMKeychain/SAMKeychain.h>

#define kBundleIdentifier [[NSBundle mainBundle] bundleIdentifier]

@implementation Passport

@synthesize session     = _session;
@synthesize sinaToken   = _sinaToken;

//static NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];

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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
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
        
        
//        self.session                    = [SAMKeychain passwordForService:kBundleIdentifier account:SessionKey];
        
//        NSString *sinaUserID            = [[NSUserDefaults standardUserDefaults] objectForKey:SinaUserIDKey];
//        self.sinaUserID                 = sinaUserID;
        self.sinaUserID                 = [SAMKeychain passwordForService:kBundleIdentifier account:SinaUserIDKey];
        
//        NSString *sinaToken             = [[NSUserDefaults standardUserDefaults] objectForKey:SinaTokenKey];
//        self.sinaToken = sinaToken;
//        self.sinaToken                  = [SAMKeychain passwordForService:kBundleIdentifier account:SinaTokenKey];
        
        NSDate *sinaExpirationDate      = [[NSUserDefaults standardUserDefaults] objectForKey:SinaExpirationDateKey];
        self.sinaExpirationDate         = sinaExpirationDate;
    }
    return self;
}

#pragma mark - lazy load
- (NSString *)session
{
    if (!_session) {
        _session                    = [SAMKeychain passwordForService:kBundleIdentifier account:SessionKey];
    }
    return _session;
}

- (NSString *)sinaToken
{
    if (!_sinaToken) {
        _sinaToken                  = [SAMKeychain passwordForService:kBundleIdentifier account:SinaTokenKey];
    }
    return _sinaToken;
}

- (void)setSession:(NSString *)session
{
    _session = session;
    if (_session) {
        [SAMKeychain setPassword:_session forService:kBundleIdentifier account:SessionKey];
    } else {
        [SAMKeychain deletePasswordForService:kBundleIdentifier account:SessionKey];
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
    if (_sinaUserID) {
        [SAMKeychain setPassword:_sinaUserID forService:kBundleIdentifier account:SinaUserIDKey];
//        [[NSUserDefaults standardUserDefaults] setValue:self.sinaUserID forKey:SinaUserIDKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [SAMKeychain deletePasswordForService:kBundleIdentifier account:SinaUserIDKey];
    }
}

- (void)setScreenName:(NSString *)sinaNickName
{
    _screenName = sinaNickName;
    if (_screenName) {
//        [[NSUserDefaults standardUserDefaults] setValue:self.screenName forKey:SinaNickNameKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [SAMKeychain setPassword:_screenName forService:kBundleIdentifier account:SinaNickNameKey];
    } else {
//        [NSObject removeFromUserDefaultsByKey:SinaNickNameKey];
        [SAMKeychain deletePasswordForService:kBundleIdentifier account:SinaNickNameKey];
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
    if (_sinaToken) {
        [SAMKeychain setPassword:_sinaToken forService:kBundleIdentifier account:SinaTokenKey];
//        [[NSUserDefaults standardUserDefaults] setValue:self.sinaToken forKey:SinaTokenKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [SAMKeychain deletePasswordForService:kBundleIdentifier account:SinaTokenKey];
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
    if (_taobaoToken) {
//        [[NSUserDefaults standardUserDefaults] setValue:self.taobaoToken forKey:TaobaoTokenKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [SAMKeychain setPassword:_taobaoToken forService:kBundleIdentifier account:TaobaoTokenKey];
    } else {
        [SAMKeychain deletePasswordForService:kBundleIdentifier account:TaobaoTokenKey];
        
    }
}


@end
