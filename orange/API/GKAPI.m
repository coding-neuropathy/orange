//
//  GKAPI.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-26.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKAPI.h"
#import "GKHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SettingManager.h"
#import "Passport.h"
@implementation GKAPI

/*
 *  更新 JPush Register ID
 */
+ (void)postRegisterID:(NSString *)rid Model:(NSString *)model Version:(NSString *)ver Success:(void (^)())success
               Failure:(void (^)(NSInteger stateCode))failure
{
    NSString * path = @"apns/token/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:rid forKey:@"rid"];
    [paraDict setValue:model forKey:@"model"];
    [paraDict setValue:ver forKey:@"version"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DDLogError(@"status code %lu", operation.response.statusCode);
        if (failure) {
            NSInteger statusCode = operation.response.statusCode;
            failure(statusCode);
        }
    }];
}

/**
 *  获取主页信息（banner、hotCategory、hotTag）
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getHomepageWithSuccess:(void (^)(NSDictionary *settingDict, NSArray *bannerArray, NSArray *hotCategoryArray, NSArray *hotTagArray))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"homepage/";
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        NSDictionary *settingDict = objectDict[@"config"];
        
        NSMutableArray *bannerArray = objectDict[@"banner"];
        if (objectDict[@"config"][@"jump_to_taobao"]) {
            [SettingManager sharedInstance].jumpToTaobao = [objectDict[@"config"][@"jump_to_taobao"]boolValue];
        }
        if (objectDict[@"config"][@"taobao_ban_count"]) {
            //[SettingManager sharedInstance].taobaoBanCount = [objectDict[@"config"][@"taobao_ban_count"]unsignedIntegerValue];
        }
        if (objectDict[@"config"][@"show_selection_only"]) {
            [SettingManager sharedInstance].hidesNote = [objectDict[@"config"][@"show_selection_only"]boolValue];
        }
        if (objectDict[@"config"][@"url_ban_list"]) {
            [SettingManager sharedInstance].urlBanList = objectDict[@"config"][@"url_ban_list"];
        }

        NSMutableArray *hotCategoryArray = [NSMutableArray array];
        {
            NSArray *itemArray = objectDict[@"discover"];
            for (NSDictionary *categoryDict in itemArray) {
                GKEntityCategory *category = [GKEntityCategory modelFromDictionary:categoryDict];
                [hotCategoryArray addObject:category];
            }
        }
        
        NSMutableArray *hotTagArray = [NSMutableArray array];
        {
            NSArray *itemArray = objectDict[@"hottag"];
            for (NSDictionary *Dict in itemArray) {
                GKUser * user = [GKUser modelFromDictionary:Dict[@"user"]];
                NSMutableArray *entityArray = [NSMutableArray array];
                for (NSDictionary *entityDict in Dict[@"entity_list"]) {
                    GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
                    [entityArray addObject:entity];
                }
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:Dict];
                [dic setObject:user forKey:@"user"];
                [dic setObject:entityArray forKey:@"entity_list"];
                [hotTagArray addObject:dic];
            }
        }
        if (success) {
            success(settingDict, bannerArray, hotCategoryArray, hotTagArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取全部分类信息
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getAllCategoryWithSuccess:(void (^)(NSArray *groupArray))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"category/";
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *objectArray = (NSArray *)responseObject;
            
            NSMutableArray *groupArray = [NSMutableArray array];
            for (NSDictionary *groupDict in objectArray) {
                NSInteger groupId = [groupDict[@"group_id"] integerValue];
                NSString *groupName = groupDict[@"title"];
                NSString *status = groupDict[@"status"];
                NSArray *content = groupDict[@"content"];
                
                NSMutableArray *categoryArray = [NSMutableArray array];
                for (NSDictionary *categoryDict in content) {
                    GKEntityCategory *category = [GKEntityCategory modelFromDictionary:categoryDict];
                    [categoryArray addObject:category];
                }
                
                NSDictionary *group = @{@"GroupId"       : @(groupId),
                                        @"GroupName"     : groupName,
                                        @"Status"        : status,
                                        @"Count"         : @(categoryArray.count),
                                        @"CategoryArray" : categoryArray};
                [groupArray addObject:group];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(groupArray);
                }
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取分类统计数据
 *
 *  @param categoryId 商品分类ID
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getCategoryStatByCategoryId:(NSUInteger)categoryId
                            success:(void (^)(NSInteger likeCount, NSInteger noteCount, NSInteger entityCount))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(categoryId > 0);
    
    NSString *path = [NSString stringWithFormat:@"category/%lu/stat", (long)categoryId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        NSInteger likeCount = [objectDict[@"like_count"] integerValue];
        NSInteger noteCount = [objectDict[@"entity_note_count"] integerValue];
        NSInteger entityCount = [objectDict[@"entity_count"] integerValue];
        
        if (success) {
            success(likeCount, noteCount, entityCount);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取推荐标签
 *
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getTagRecommendWithCount:(NSInteger)count
                          offset:(NSInteger)offset
                         success:(void (^)(NSArray *entityArray))success
                         failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = [NSString stringWithFormat:@"user/tag/recommend/"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *itemArray = (NSArray *)responseObject;
        NSMutableArray *tagArray = [NSMutableArray array];
        for (NSDictionary *Dict in itemArray) {
            GKUser * user = [GKUser modelFromDictionary:Dict[@"user"]];
            NSMutableArray *entityArray = [NSMutableArray array];
            for (NSDictionary *entityDict in Dict[@"entity_list"]) {
                GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
                [entityArray addObject:entity];
            }
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:Dict];
            [dic setObject:user forKey:@"user"];
            [dic setObject:entityArray forKey:@"entity_list"];
            [tagArray addObject:dic];
        }
        
        if (success) {
            success(tagArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取商品列表
 *
 *  @param categoryId 商品分类ID
 *  @param sort       排序规则(评价:"best" 时间:"new")
 *  @param reverse    是否倒序
 *  @param offset     偏移量
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getEntityListWithCategoryId:(NSUInteger)categoryId
                               sort:(NSString *)sort
                            reverse:(BOOL)reverse
                             offset:(NSInteger)offset
                              count:(NSInteger)count
                            success:(void (^)(NSArray *entityArray))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(categoryId > 0);
    NSParameterAssert(sort);
    NSParameterAssert(offset >= 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"category/%ld/entity/", categoryId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:sort forKey:@"sort"];
    [paraDict setObject:@(reverse) forKey:@"reverse"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *entityArray = [NSMutableArray array];
        for (NSDictionary *entityDict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取喜爱商品列表
 *
 *  @param categoryId 商品分类ID
 *  @param sort       排序规则(评价:"best" 时间:"new")
 *  @param reverse    正序、逆序
 *  @param offset     偏移量
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */

+ (void)getLikeEntityListWithCategoryId:(NSUInteger)categoryId
                                 userId:(NSUInteger)userId
                                   sort:(NSString *)sort
                                reverse:(BOOL)reverse
                                 offset:(NSInteger)offset
                                  count:(NSInteger)count
                                success:(void (^)(NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = [NSString stringWithFormat:@"category/%ld/user/%ld/like/", categoryId, userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:sort forKey:@"sort"];
    [paraDict setObject:@(reverse) forKey:@"reverse"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *entityArray = [[NSMutableArray alloc] init];
        for (NSDictionary *entityDict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        if (success) {
            success(entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取大家的点评列表
 *
 *  @param categoryId 商品分类ID
 *  @param sort       排序规则(评价:"best" 时间:"new")
 *  @param reverse    是否倒序
 *  @param offset     偏移量
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getNoteListWithCategoryId:(NSUInteger)categoryId
                             sort:(NSString *)sort
                          reverse:(BOOL)reverse
                           offset:(NSInteger)offset
                            count:(NSInteger)count
                          success:(void (^)(NSArray *dataArray))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(categoryId > 0);
    NSParameterAssert(sort);
    NSParameterAssert(offset >= 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"category/%ld/entity/note/", categoryId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:sort forKey:@"sort"];
    [paraDict setObject:@(reverse) forKey:@"reverse"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:dict[@"entity"]];
            GKNote *note = [GKNote modelFromDictionary:dict[@"note"]];
            
            NSDictionary *dataDict = @{@"entity" : entity,
                                       @"note"   : note};
            [dataArray addObject:dataDict];
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取分享列表
 *
 *  @param categoryId 商品分类ID
 *  @param sort       排序规则(评价:"best" 时间:"new")
 *  @param reverse    是否倒序
 *  @param offset     偏移量
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getShareListWithCategoryId:(NSUInteger)categoryId
                              sort:(NSString *)sort
                           reverse:(BOOL)reverse
                            offset:(NSInteger)offset
                             count:(NSInteger)count
                           success:(void (^)(NSArray *noteArray))success
                           failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(categoryId > 0);
    NSParameterAssert(sort);
    NSParameterAssert(offset >= 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"category/%ld/candidate/", categoryId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:dict[@"entity"]];
            GKNote *note = [GKNote modelFromDictionary:dict[@"note"]];
            
            NSDictionary *dataDict = @{@"entity" : entity,
                                       @"note"   : note};
            [dataArray addObject:dataDict];
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取商品详细
 *
 *  @param entityId 商品ID
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)getEntityDetailWithEntityId:(NSString *)entityId
                            success:(void (^)(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(entityId);
    
    NSString *path = [NSString stringWithFormat:@"entity/%@/", entityId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
        
        NSArray *likeUserDictArray = objectDict[@"like_user_list"];
        NSMutableArray *likeUserArray = [NSMutableArray array];
        for (NSDictionary *likeUserDict in likeUserDictArray) {
            GKUser *likeUser = [GKUser modelFromDictionary:likeUserDict];
            [likeUserArray addObject:likeUser];
        }
        
        NSArray *noteDictArray = objectDict[@"note_list"];
        NSMutableArray *noteArray = [NSMutableArray array];
        for (NSDictionary *noteDict in noteDictArray) {
            GKNote *note = [GKNote modelFromDictionary:noteDict];
            [noteArray addObject:note];
        }
        
        if (success) {
            success(entity, likeUserArray, noteArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  用户注册
 *
 *  @param email        邮箱
 *  @param password     密码
 *  @param nickname     昵称
 *  @param imageData    头像
 *  @param sinaUserId   新浪微博ID
 *  @param sinaToken    新浪微博Token
 *  @param taobaoUserId 淘宝ID
 *  @param taobaoToken  taobaoToken
 *  @param screenName   新浪/淘宝 昵称
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
                 nickname:(NSString *)nickname
                imageData:(NSData *)imageData
               sinaUserId:(NSString *)sinaUserId
                sinaToken:(NSString *)sinaToken
             taobaoUserId:(NSString *)taobaoUserId
             taobaoToken:(NSString *)taobaoToken
               screenName:(NSString *)screenName
                  success:(void (^)(GKUser *user, NSString *session))success
                  failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSParameterAssert(nickname);
    
    NSString *path = @"register/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:email forKey:@"email"];
    [paraDict setObject:password forKey:@"password"];
    [paraDict setObject:nickname forKey:@"nickname"];
    
    if (sinaUserId && screenName && sinaToken) {
        [paraDict setObject:sinaUserId forKey:@"sina_id"];
        [paraDict setObject:screenName forKey:@"screen_name"];
        [paraDict setObject:sinaToken forKey:@"sina_token"];
        path = @"sina/register/";
    } else if (taobaoUserId && screenName && taobaoToken) {
        [paraDict setObject:taobaoUserId forKey:@"taobao_id"];
        [paraDict setObject:screenName forKey:@"screen_name"];
        [paraDict setObject:taobaoToken forKey:@"taobao_token"];
        path = @"taobao/register/";
    }
    
    NSDictionary *dataParameters;
    if (imageData) {
        dataParameters = @{@"image":imageData};
    }
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        NSString *session = objectDict[@"session"];
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil userInfo:nil];
        if (success) {
            success(user, session);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *message, *type;
            
            switch (stateCode) {
                case 409:
                {
                    NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
                    NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                    //            NSDictionary *dict = [htmlString objectFromJSONString];
                    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
//                    NSDictionary *dict = [htmlString objectFromJSONString];
                    message = dict[@"message"];
                    type = dict[@"type"];
                    break;
                }
            }
            
            failure(stateCode, type, message);
        }
    }];
}

/**
 *  用户登录
 *
 *  @param email    邮箱
 *  @param password 密码
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(GKUser *user, NSString *session))success
               failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    
    NSString *path = @"login/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:email forKey:@"email"];
    [paraDict setObject:password forKey:@"password"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        NSString *session = objectDict[@"session"];
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil userInfo:nil];
        if (success) {
            success(user, session);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *message;
            NSString *type;
//            NSLog(@"%@", [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"]);
            switch (stateCode) {
                case 400:
                {
                    NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
                    
//                    NSDictionary *dict = [htmlString objectFromJSONString];
                    NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                    //            NSDictionary *dict = [htmlString objectFromJSONString];
                    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
                    message = dict[@"message"];
                    type = dict[@"type"];
                    break;
                }
            }
            
            failure(stateCode, type, message);
        }
    }];
}

/**
 *  新浪微博登录
 *
 *  @param sinaUserId 新浪微博用户ID
 *  @param sinaToken  新浪token
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)loginWithSinaUserId:(NSString *)sinaUserId
                    sinaToken:(NSString *)sinaToken
                    ScreenName:(NSString *)screenname
                    success:(void (^)(GKUser *user, NSString *session))success
                    failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(sinaUserId);
    NSParameterAssert(sinaToken);
    NSParameterAssert(screenname);
    
    NSString *path = @"weibo/login/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:sinaUserId forKey:@"sina_id"];
    [paraDict setObject:sinaToken forKey:@"sina_token"];
    [paraDict setObject:screenname forKey:@"screen_name"];
//    if ([Passport sharedInstance].screenName) {
//        [paraDict setObject:[Passport sharedInstance].screenName forKey:@"screen_name"];
//    }
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        NSString *session = objectDict[@"session"];
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil userInfo:nil];
        if (success) {
            success(user, session);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *message;
            NSString *type;
            
            switch (stateCode) {
                case 400:
                {
                    NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
//                    NSDictionary *dict = [htmlString objectFromJSONString];
                    NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                    //            NSDictionary *dict = [htmlString objectFromJSONString];
                    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
                    message = dict[@"message"];
                    type = dict[@"type"];
                    break;
                }
            }
            
            failure(stateCode, type, message);
        }
    }];
}

/**
 *  百川登录
 *
 *  @param taobaoUserId 淘宝用户ID
 *  @param nick         淘宝用户昵称
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)loginWithBaichuanUid:(NSString *)uid
                        nick:(NSString *)nick
                      success:(void (^)(GKUser *user, NSString *session))success
                      failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(uid);
    
    NSString * path = @"baichuan/login/";
    
    NSMutableDictionary * paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:uid forKey:@"user_id"];
    [paraDict setObject:nick forKey:@"nick"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        NSString *session = objectDict[@"session"];
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil userInfo:nil];
        if (success) {
            success(user, session);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *message;
            NSString *type;

            NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
            
            DDLogInfo(@"%@", htmlString);
            
            failure(stateCode, type, message);
        }
    }];
    
}

/**
 *  淘宝登录
 *
 *  @param taobaoUserId 淘宝用户ID
 *  @param taobaoToken  淘宝token
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)loginWithTaobaoUserId:(NSString *)taobaoUserId
                  taobaoToken:(NSString *)taobaoToken
                      success:(void (^)(GKUser *user, NSString *session))success
                      failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(taobaoUserId);
    NSParameterAssert(taobaoToken);
    
    NSString *path = @"taobao/login/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:taobaoUserId forKey:@"taobao_id"];
    [paraDict setObject:taobaoToken forKey:@"taobao_token"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        NSString *session = objectDict[@"session"];
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil userInfo:nil];
        if (success) {
            success(user, session);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *message;
            NSString *type;
            
            switch (stateCode) {
                case 400:
                {
                    NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
//                    NSDictionary *dict = [htmlString objectFromJSONString];
                    NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                    //            NSDictionary *dict = [htmlString objectFromJSONString];
                    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
                    message = dict[@"message"];
                    type = dict[@"type"];
                    break;
                }
            }
            
            failure(stateCode, type, message);
        }
    }];
}

/**
 *  新浪用户绑定果库账号
 *  @param userId           果库用户ID
 *  @param sinaUserId       新浪用户ID
 *  @param sinaScreenname   新浪用户名
 *  @param sinaToken        新浪token
 *  @param expires_in       token过期时间
 *  @param success          成功block
 *  @param failure          失败block
 */
+ (void)bindWeiboWithUserId:(NSInteger)user_id sinaUserId:(NSString *)sina_user_id
                sinaScreenname:(NSString *)screen_name
                accessToken:(NSString *)access_token
                ExpiresIn:(NSDate *)expires_in
                success:(void (^)(GKUser *user))success
                failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(user_id);
    NSParameterAssert(sina_user_id);
    NSParameterAssert(screen_name);
    NSParameterAssert(expires_in);
    NSParameterAssert(access_token);
    
    NSString * path = @"sina/bind/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:@(user_id) forKey:@"user_id"];
    [paraDict setValue:sina_user_id forKey:@"sina_id"];
    [paraDict setValue:screen_name forKey:@"screen_name"];
    [paraDict setValue:@((NSInteger)[expires_in timeIntervalSince1970]) forKey:@"expires_in"];
    [paraDict setValue:access_token forKey:@"sina_token"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        GKUser *user = [GKUser modelFromDictionary:objectDict];
//        NSLog(@"%@", responseObject);
        if (success) {
            success(user);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
//            NSLog(@"html %@", htmlString);
//            NSDictionary *dict = [htmlString objectFromJSONString];
            NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
            //            NSDictionary *dict = [htmlString objectFromJSONString];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
            NSString * message = dict[@"message"];
            NSString * type = dict[@"type"];

            failure(stateCode, type, NSLocalizedStringFromTable(message, kLocalizedFile, nil));
        }
    }];
}

/**
 *  果库账号解除SNS綁定
 *  @param userId           果库用户ID
 *  @param SNSUserId        SNS用户名
 *  @param platform         SNS平台
 *  @param success          成功block
 *  @param failure          失败block
 */
+ (void)unbindSNSWithUserId:(NSInteger)user_id
                    SNSUserName:(NSString *)sns_user_name
                    setPlatform:(GKSNSType)platform
                    success:(void (^)(bool status))success
                    failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(user_id);
    NSParameterAssert(sns_user_name);
    NSParameterAssert(platform);
    
    NSString * path;
    switch (platform) {
        case GKTaobao:
            path = @"taobao/unbind";
            break;
            
        default:
            path = @"sina/unbind/";
            break;
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:@(user_id) forKey:@"user_id"];
    [paraDict setValue:sns_user_name forKey:@"sns_user_name"];
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger stateCode = operation.response.statusCode;
        NSLog(@"html success %lu", stateCode);
        if (success) {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
//            NSLog(@"html %lu", stateCode);
            NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
            
            DDLogInfo(@"%@", objectData);
//            NSDictionary *dict = [htmlString objectFromJSONString];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
            NSString * message = dict[@"message"];
            NSString * type = dict[@"type"];
            
            failure(stateCode, type, NSLocalizedStringFromTable(message, kLocalizedFile, nil));
        }
    }];
    
}


/**
 *  用户注销
 *
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)logoutWithSuccess:(void (^)())success
                  failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"logout/";
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  忘记密码
 *
 *  @param email   注册时的Email
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)forgetPasswordWithEmail:(NSString *)email
                        success:(void (^)(BOOL success))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(email);
    
    NSString *path = @"forget/password/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:email forKey:@"email"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        BOOL state = [objectDict[@"success"] boolValue];
        
        if (success) {
            success(state);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  通过session获取用户基本信息
 *
 *  @param session 用户的登录session
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserInfoWithSession:(NSString *)session
                       success:(void (^)(GKUser *user))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"user/info/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:session forKey:@"session"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  喜欢商品
 *
 *  @param entityHash 商品Hash
 *  @param isLike     想要设置的喜爱状态
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)likeEntityWithEntityId:(NSString *)entityId
                        isLike:(BOOL)isLike
                       success:(void (^)(BOOL liked))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(entityId);
    
    NSString *path = [NSString stringWithFormat:@"entity/%@/like/%d/", entityId, isLike];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        BOOL liked = [objectDict[@"like_already"] boolValue];
        
        if (success) {
            success(liked);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  发点评
 *
 *  @param entityId  商品ID
 *  @param content   点评内容
 *  @param score     点评分数
 *  @param imageData 用户晒图
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)postNoteWithEntityId:(NSString *)entityId
                     content:(NSString *)content
                       score:(NSInteger)score
                   imageData:(NSData *)imageData
                     success:(void (^)(GKNote *note))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(entityId);
    NSParameterAssert(content);
    NSParameterAssert(score >= 0);
    
    NSString *path = [NSString stringWithFormat:@"entity/%@/add/note/", entityId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"note"];
    [paraDict setObject:@(score) forKey:@"score"];
    
    NSDictionary *dataParameters;
    if (imageData) {
        dataParameters = @{@"image":imageData};
    }
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKNote *note = [GKNote modelFromDictionary:objectDict];
        
        if (success) {
            success(note);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  修改点评
 *
 *  @param noteId    点评ID
 *  @param content   点评内容
 *  @param score     点评分数
 *  @param imageData 用户晒图
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)updateNoteWithNoteId:(NSUInteger)noteId
                     content:(NSString *)content
                       score:(NSInteger)score
                   imageData:(NSData *)imageData
                     success:(void (^)(GKNote *note))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    NSParameterAssert(content);
    NSParameterAssert(score >= 0);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/update/", noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"note"];
    [paraDict setObject:@(score) forKey:@"score"];
    
    NSDictionary *dataParameters;
    if (imageData) {
        dataParameters = @{@"image":imageData};
    }
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKNote *note = [GKNote modelFromDictionary:objectDict];
        
        if (success) {
            success(note);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  删除点评
 *
 *  @param noteId  点评ID
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)deleteNoteByNoteId:(NSUInteger)noteId
                   success:(void (^)())success
                   failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/del/", noteId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户的喜爱商品列表
 *
 *  @param userId    用户ID
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getUserLikeEntityListWithUserId:(NSUInteger)userId
                              timestamp:(NSTimeInterval)timestamp
                                  count:(NSInteger)count
                                success:(void (^)(NSTimeInterval timestamp, NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/like/", userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        NSTimeInterval timestamp = [objectDict[@"timestamp"] doubleValue];
        NSMutableArray *entityArray = [NSMutableArray array];
        for (NSDictionary *entityDict in [objectDict objectForKey:@"entity_list"]) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(timestamp, entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户的关注列表
 *
 *  @param userId  用户ID
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserFollowingListWithUserId:(NSUInteger)userId
                                offset:(NSInteger)offset
                                 count:(NSInteger)count
                               success:(void (^)(NSArray *userArray))success
                               failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(offset >= 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/following/", userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *userArray = [NSMutableArray array];
        for (NSDictionary *userDict in objectArray) {
            GKUser *user = [GKUser modelFromDictionary:userDict];
            [userArray addObject:user];
        }
        
        if (success) {
            success(userArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户的粉丝列表
 *
 *  @param userId  用户ID
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserFanListWithUserId:(NSUInteger)userId
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                         success:(void (^)(NSArray *userArray))success
                         failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(offset >= 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/fan/", userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *userArray = [NSMutableArray array];
        for (NSDictionary *userDict in objectArray) {
            GKUser *user = [GKUser modelFromDictionary:userDict];
            [userArray addObject:user];
        }
        
        if (success) {
            success(userArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户的新浪好友列表
 *
 *  @param sinaIds 新浪微博好友ID数组
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserSinaWeiboFriendListWithSinaIds:(NSArray *)sinaIds
                                      success:(void (^)(NSArray *userArray))success
                                      failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(sinaIds);
    
    NSString *path = [NSString stringWithFormat:@"sina/user/check/"];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:sinaIds forKey:@"sid"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *userArray = [NSMutableArray array];
        for (NSDictionary *userDict in objectArray) {
            GKUser *user = [GKUser modelFromDictionary:userDict];
            [userArray addObject:user];
        }
        
        if (success) {
            success(userArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户的点评列表
 *
 *  @param userId    用户ID
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getUserNoteListWithUserId:(NSUInteger)userId
                        timestamp:(NSTimeInterval)timestamp
                            count:(NSInteger)count
                          success:(void (^)(NSArray *dataArray))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/entity/note/", userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *dict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:dict[@"entity"]];
            GKNote *note = [GKNote modelFromDictionary:dict[@"note"]];
            
            NSDictionary *dataDict = @{@"entity" : entity,
                                       @"note"   : note};
            [dataArray addObject:dataDict];
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户的标签列表
 *
 *  @param userId  用户ID
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getTagListWithUserId:(NSUInteger)userId
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(GKUser *user, NSArray *tagArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/tag/", userId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        NSDictionary *userDict = objectDict[@"user"];
        NSArray *tagArray = objectDict[@"tags"];
        
        GKUser *user = [GKUser modelFromDictionary:userDict];
        
        if (success) {
            success(user, tagArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取用户某个标签下的商品列表
 *
 *  @param userId  用户ID
 *  @param tag     标签
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getEntityListWithUserId:(NSUInteger)userId
                            tag:(NSString *)tag
                         offset:(NSInteger)offset
                          count:(NSInteger)count
                        success:(void (^)(GKUser *user ,NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(tag);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/tag/%@/", userId, tag];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:[path encodedUrl] method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = [(NSDictionary *)responseObject objectForKey:@"entity_list"];
        GKUser *user = [GKUser modelFromDictionary:[(NSDictionary *)responseObject objectForKey:@"user"]];
        
        NSMutableArray *entityArray = [NSMutableArray array];
        
        for (NSDictionary *entityDict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(user,entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  搜索商品
 *
 *  @param string  搜索关键字
 *  @param type    类型(全部/喜爱)
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)searchEntityWithString:(NSString *)string
                          type:(NSString *)type
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(void (^)(NSDictionary *stat,NSArray *entityArray))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(string);
    
    NSString *path = @"entity/search/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:string forKey:@"q"];
    [paraDict setObject:type forKey:@"type"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = [(NSDictionary *)responseObject objectForKey:@"entity_list"];
        NSDictionary *stat = [(NSDictionary *)responseObject objectForKey:@"stat"];
        NSMutableArray *entityArray = [NSMutableArray array];
        for (NSDictionary *entityDict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(stat,entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  搜索点评
 *
 *  @param string  搜索关键字
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)searchNoteWithString:(NSString *)string
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *noteArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(string);
    
    NSString *path = @"note/search/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:string forKey:@"q"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *noteArray = [NSMutableArray array];
        for (NSDictionary *noteDict in objectArray) {
            GKNote *note = [GKNote modelFromDictionary:noteDict];
            [noteArray addObject:note];
        }
        
        if (success) {
            success(noteArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  搜索用户
 *
 *  @param string  搜索关键字
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)searchUserWithString:(NSString *)string
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *userArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(string);
    
    NSString *path = @"user/search/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:string forKey:@"q"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *userArray = [NSMutableArray array];
        for (NSDictionary *userDict in objectArray) {
            GKUser *user = [GKUser modelFromDictionary:userDict];
            [userArray addObject:user];
        }
        
        if (success) {
            success(userArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  关注用户
 *
 *  @param userId  目标用户
 *  @param state   要设置的关注状态
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)followUserId:(NSUInteger)userId
               state:(BOOL)state
             success:(void (^)(GKUserRelationType relation))success
             failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/follow/%d/", userId, state];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUserRelationType relation = [objectDict[@"relation"] integerValue];
        
        if (success) {
            success(relation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取动态
 *
 *  @param timestamp 时间戳
 *  @param type      返回的实体类型(entity/candidate)
 *  @param scale     好友动态/社区动态(friend/all)
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getFeedWithTimestamp:(NSTimeInterval)timestamp
                        type:(NSString *)type
                       scale:(NSString *)scale
                     success:(void (^)(NSArray *dataArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert([type isEqualToString:@"entity"] || [type isEqualToString:@"candidate"]);
    NSParameterAssert([scale isEqualToString:@"friend"] || [scale isEqualToString:@"all"]);
    
    NSString *path = @"feed/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:type forKey:@"type"];
    [paraDict setObject:scale forKey:@"scale"];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in objectArray) {
            NSDictionary *objectDict = [dict objectForKey:@"content"];
            NSTimeInterval timestamp = [[dict objectForKey:@"created_time"] doubleValue];
            NSString *type = [dict objectForKey:@"type"];
            
            if ([type isEqualToString:@"entity"]){
                GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
                GKNote *note = [GKNote modelFromDictionary:objectDict[@"note"]];
                NSDictionary *dataDict = @{@"object" :  @{@"entity"  : entity,
                                                      @"note"    : note},
                                       @"type"   :  type,
                                       @"time"   :  @(timestamp)};
                [dataArray addObject:dataDict];
            }
            if ([type isEqualToString:@"user_follow"]) {
//                NSLog(@"%@", objectDict);
                GKUser * user = [GKUser modelFromDictionary:objectDict[@"user"]];
                GKUser * target = [GKUser modelFromDictionary:objectDict[@"target"]];
                NSDictionary *dataDict = @{@"object" :  @{@"user"  : user,
                                                          @"target": target},
                                           @"type"   :  type,
                                           @"time"   :  @(timestamp)};
                [dataArray addObject:dataDict];
            }
            
            
            if ([type isEqualToString:@"user_like"]) {
                GKUser * user = [GKUser modelFromDictionary:objectDict[@"liker"]];
                GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
                NSDictionary *dataDict = @{@"object" :  @{@"entity"  : entity,
                                                          @"user"    : user},
                                           @"type"   :  type,
                                           @"time"   :  @(timestamp)};
                [dataArray addObject:dataDict];
            }
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取点评详细
 *
 *  @param noteId  点评ID
 *  @param success 成功block
 *  @param failure 失败block
 */

+ (void)getNoteDetailWithNoteId:(NSUInteger)noteId
                        success:(void (^)(GKNote *note, GKEntity *entity, NSArray *commentArray, NSArray *pokerArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/", noteId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKNote *note = [GKNote modelFromDictionary:objectDict[@"note"]];
        GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
        
        NSDictionary *commentDictArray = objectDict[@"comment_list"];
        NSMutableArray *commentArray = [NSMutableArray array];
        for (NSDictionary *commentDict in commentDictArray) {
            GKComment *comment = [GKComment modelFromDictionary:commentDict];
            [commentArray addObject:comment];
        }
        
        NSDictionary *pokerDictArray = objectDict[@"poker_list"];
        NSMutableArray *pokerArray = [NSMutableArray array];
        for (NSDictionary *pokerDict in pokerDictArray) {
            GKUser *poker = [GKUser modelFromDictionary:pokerDict];
            [pokerArray addObject:poker];
        }
        
        if (success) {
            success(note, entity, commentArray, pokerArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  对点评点赞
 *
 *  @param noteId  点评ID
 *  @param state   想要设置的赞状态
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)pokeWithNoteId:(NSUInteger)noteId
                 state:(BOOL)state
               success:(void (^)(NSString *entityId, NSUInteger noteId, BOOL state))success
               failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/poke/%d/", noteId, state];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        NSString *entityId = objectDict[@"entity_id"];
        NSUInteger noteId = [objectDict[@"note_id"] unsignedIntegerValue];
        BOOL state = [objectDict[@"poke_already"] boolValue];
        
        if (success) {
            success(entityId, noteId, state);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取个人主页详细信息
 *
 *  @param userId  用户ID
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserDetailWithUserId:(NSUInteger)userId
                        success:(void (^)(GKUser *user, GKEntity *lastLikeEntity, GKNote *lastNote))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/", userId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
        GKEntity *lastLikeEntity = [GKEntity modelFromDictionary:objectDict[@"last_like"]];
        GKNote *lastNote = nil;
        
        if (success) {
            success(user, lastLikeEntity, lastNote);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}


/**
 *  更新当前用户信息
 *
 *  @param nickname  昵称
 *  @param bio       简介
 *  @param gender    性别
 *  @param imageData 头像
 *  @param success   成功block
 *  @param failure   失败block
 */

+ (void)updateUserProfileWithParameters:(NSDictionary *)parameters
                                imageData:(NSData *)imageData
                                success:(void (^)(GKUser *user))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"user/update/";
    NSDictionary *dataParameters;
    if (imageData) {
        dataParameters = @{@"image":imageData};
    }
    
//    if (!parameters)
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    if (parameters)
        paraDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

///**
// *  更新当前用户账号信息
// *
// *  @param email     邮箱
// *  @param password  密码
// *  @param success   成功block
// *  @param failure   失败block
// */
//+ (void)updateaccountWithParameters:(NSDictionary *)parameters
//                                success:(void (^)(GKUser *user))success
//                                failure:(void (^)(NSInteger stateCode))failure
//{
//    NSString *path = @"user/update/account/";
//    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
//    if (parameters)
//        paraDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *objectDict = (NSDictionary *)responseObject;
//        
//        GKUser *user = [GKUser modelFromDictionary:objectDict];
//        
//        if (success) {
//            success(user);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            NSInteger stateCode = operation.response.statusCode;
//            failure(stateCode);
//        }
//    }];
//}

/**
 *  更新当前用户邮箱
 *
 *  @param email     邮箱
 *  @param password  密码
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)updateEmailWithParameters:(NSDictionary *)parameters
                            success:(void (^)(GKUser *user))success
                            failure:(void (^)(NSInteger stateCode, NSString *errorMsg))failure
{
    NSString *path = @"user/update/email/";
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    if (parameters)
        paraDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString * messageString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
            NSDictionary * messageObj = [NSJSONSerialization JSONObjectWithData:[messageString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            failure(stateCode, [messageObj valueForKeyPath:@"message"]);
        }
    }];
}


/**
 *  更新当前用户邮箱
 *
 *  @param password         密码
 *  @param new_passowrd     新密码
 *  @param confirm_password 确认密码
 *  @param success          成功block
 *  @param failure          失败block
 */
+ (void)resetPasswordWithParameters:(NSDictionary *)parameters
                          success:(void (^)(GKUser *user))success
                          failure:(void (^)(NSInteger stateCode, NSString *errorMsg))failure
{
    NSString *path = @"user/reset/password/";
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    if (parameters)
        paraDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString * messageString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
            NSDictionary * messageObj = [NSJSONSerialization JSONObjectWithData:[messageString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            failure(stateCode, [messageObj valueForKeyPath:@"message"]);
        }
    }];
}


/**
 *  更新当前用户信息
 *
 *  @param nickname  昵称
 *  @param email     邮箱
 *  @param password  密码
 *  @param imageData 头像
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)updateUserProfileWithNickname:(NSString *)nickname
                                email:(NSString *)email
                             password:(NSString *)password
                            imageData:(NSData *)imageData
                              success:(void (^)(GKUser *user))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"user/update/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    if (nickname) {
        [paraDict setObject:nickname forKey:@"nickname"];
    }
    if (email) {
        [paraDict setObject:email forKey:@"email"];
    }
    if (password) {
        [paraDict setObject:password forKey:@"password"];
    }
    
    NSDictionary *dataParameters;
    if (imageData) {
        dataParameters = @{@"image":imageData};
    }
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取新品列表
 *
 *  @param timestamp 时间戳
 *  @param cateId    旧版categoryId(0 ~ 11)
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getNewEntityListWithTimestamp:(NSTimeInterval)timestamp
                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *entityArray))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(count > 0);
    
    NSString *path = @"entity/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    [paraDict setObject:@(cateId) forKey:@"rcat"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *entityArray = [NSMutableArray array];
        for (NSDictionary *entityDict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  发评论
 *
 *  @param noteId   点评ID
 *  @param content  评论内容
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)postCommentWithNoteId:(NSUInteger)noteId
                      content:(NSString *)content
                      success:(void (^)(GKComment *comment))success
                      failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    NSParameterAssert(content);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/add/comment/", noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"comment"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKComment *comment = [GKComment modelFromDictionary:objectDict];
        
        if (success) {
            success(comment);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  回复评论
 *
 *  @param noteId    点评ID
 *  @param commentId 回复的评论ID
 *  @param commentId 回复的评论的创建者ID
 *  @param content   评论内容
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)replyCommentWithNoteId:(NSUInteger)noteId
                     commentId:(NSUInteger)commentId
              commentCreatorId:(NSUInteger)commentCreatorId
                       content:(NSString *)content
                       success:(void (^)(GKComment *comment))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    NSParameterAssert(commentId >= 0);
    NSParameterAssert(commentCreatorId >= 0);
    NSParameterAssert(content);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/add/comment/", noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"comment"];
    if (commentId != 0 && commentCreatorId != 0) {
        [paraDict setObject:@(commentId) forKey:@"reply_to_comment"];
        [paraDict setObject:@(commentCreatorId) forKey:@"reply_to_user"];
    }
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKComment *comment = [GKComment modelFromDictionary:objectDict];
        
        if (success) {
            success(comment);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  删除评论
 *
 *  @param noteId    点评ID
 *  @param commentId 评论ID
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)deleteCommentByNoteId:(NSUInteger)noteId
                    commentId:(NSUInteger)commentId
                      success:(void (^)())success
                      failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    NSParameterAssert(commentId >= 0);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/comment/%ld/del/", noteId, commentId];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取消息列表
 *
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getMessageListWithTimestamp:(NSTimeInterval)timestamp
                              count:(NSInteger)count
                            success:(void (^)(NSArray *messageArray))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(count > 0);
    
    NSString *path = @"message/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *messageArray = [NSMutableArray array];
        for (NSDictionary *messageDict in objectArray) {
            NSString *type = messageDict[@"type"];
            NSTimeInterval timestamp = [messageDict[@"created_time"] doubleValue];
            NSDictionary *contentDict = messageDict[@"content"];
            
            NSDictionary *content;
            if ([type isEqualToString:@"note_comment_reply_message"]) {
                // 评论被回复
                NSDictionary *noteDict = contentDict[@"note"];
                GKNote *note = [GKNote modelFromDictionary:noteDict];
                NSDictionary *userDict = contentDict[@"replying_user"];
                GKUser *user = [GKUser modelFromDictionary:userDict];
                NSDictionary *commentDict = contentDict[@"comment"];
                GKComment *comment = [GKComment modelFromDictionary:commentDict];
                NSDictionary *replying_commentDict = contentDict[@"replying_comment"];
                GKComment *replying_comment = [GKComment modelFromDictionary:replying_commentDict];
                content = @{@"note":note, @"user":user,@"comment":comment,@"replying_comment":replying_comment};
            } else if ([type isEqualToString:@"note_comment_message"]) {
                // 点评被评论
                NSDictionary *noteDict = contentDict[@"note"];
                GKNote *note = [GKNote modelFromDictionary:noteDict];
                NSDictionary *userDict = contentDict[@"comment_user"];
                GKUser *user = [GKUser modelFromDictionary:userDict];
                NSDictionary *commentDict = contentDict[@"comment"];
                GKComment *comment = [GKComment modelFromDictionary:commentDict];
                content = @{@"note":note, @"user":user,@"comment":comment};
            } else if ([type isEqualToString:@"user_follow"]) {
                // 被关注
                NSDictionary *userDict = contentDict[@"follower"];
                GKUser *user = [GKUser modelFromDictionary:userDict];
                content = @{@"user":user};
            } else if ([type isEqualToString:@"note_poke_message"]) {
                // 点评被赞
                NSDictionary *noteDict = contentDict[@"note"];
                GKNote *note = [GKNote modelFromDictionary:noteDict];
                NSDictionary *userDict = contentDict[@"poker"];
                GKUser *user = [GKUser modelFromDictionary:userDict];
                content = @{@"note":note, @"user":user};
            } else if ([type isEqualToString:@"entity_note_message"]) {
                // 商品被点评
                NSDictionary *noteDict = contentDict[@"note"];
                GKNote *note = [GKNote modelFromDictionary:noteDict];
                NSDictionary *entityDict = contentDict[@"entity"];
                GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
                content = @{@"note":note, @"entity":entity};
            } else if ([type isEqualToString:@"entity_like_message"]) {
                // 商品被喜爱
                NSDictionary *entityDict = contentDict[@"entity"];
                GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
                NSDictionary *userDict = contentDict[@"liker"];
                GKUser *user = [GKUser modelFromDictionary:userDict];
                content = @{@"entity":entity, @"user":user};
            } else if ([type isEqualToString:@"note_selection_message"]) {
                // 点评入精选
                NSDictionary *noteDict = contentDict[@"note"];
                GKNote *note = [GKNote modelFromDictionary:noteDict];
                NSDictionary *entityDict = contentDict[@"entity"];
                GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
                content = @{@"note":note, @"entity":entity};
            } else {
                type = @"undefined_type";
                content = @{};
            }
            
            NSDictionary *message = @{@"type"    : type,
                                      @"time"    : @(timestamp),
                                      @"content" : content};
            [messageArray addObject:message];
        }
        
        if (success) {
            success(messageArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取精选列表
 *
 *  @param timestamp 时间戳
 *  @param cateId    旧版categoryId(0 ~ 11)
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getSelectionListWithTimestamp:(NSTimeInterval)timestamp
                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *dataArray))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(count > 0);
    NSParameterAssert(cateId >= 0 && cateId <= 11);
    
    NSString *path = @"selection/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    [paraDict setObject:@(cateId) forKey:@"rcat"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *selectionArray = [NSMutableArray array];
        for (NSDictionary *selectionDict in objectArray) {
            NSString *type = selectionDict[@"type"];
            NSTimeInterval timestamp = [selectionDict[@"post_time"] doubleValue];
            NSDictionary *content;
            NSDictionary *contentDict = selectionDict[@"content"];
            if ([type isEqualToString:@"note_selection"]) {
                // 点评精选
                NSDictionary *noteDict = contentDict[@"note"];
                GKNote *note = [GKNote modelFromDictionary:noteDict];
                NSDictionary *entityDict = contentDict[@"entity"];
                GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
                content = @{@"note"   : note,
                            @"entity" : entity};
            }
            
            NSParameterAssert(content);
            
            NSDictionary *selection = @{@"type"    : type,
                                        @"time"    : @(timestamp),
                                        @"content" : content};
            [selectionArray addObject:selection];
        }
        
        if (success) {
            success(selectionArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取热门商品列表
 *
 *  @param type    类型(24小时/7天)
 *  @param success 成功block
 *  @param failure 失败block
 */
+(void)getHotEntityListWithType:(NSString *)type
                        success:(void (^)(NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert([type isEqualToString:@"daily"] || [type isEqualToString:@"weekly"]);
    
    NSString *path = @"popular/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:type forKey:@"scale"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        NSMutableArray *entityArray = [NSMutableArray array];
        NSArray *content = objectDict[@"content"];
        for (NSDictionary *objectDict in content) {
            GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取随机商品
 *
 *  @param categoryId 分类ID
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getRandomEntityListByCategoryId:(NSUInteger)categoryId
                               entityId:(NSString *)entityId
                                  count:(NSInteger)count
                                success:(void (^)(NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(categoryId >= 0);
//    NSParameterAssert(entityId > 0);
    NSParameterAssert(count > 0);
    
    NSString *path = @"entity/guess/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    if (categoryId != 0) {
        [paraDict setObject:@(categoryId) forKey:@"cid"];
    }
    [paraDict setObject:@(count) forKey:@"count"];
    [paraDict setObject:entityId forKey:@"eid"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *entityArray = [NSMutableArray array];
        for (NSDictionary *entityDict in objectArray) {
            GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
            [entityArray addObject:entity];
        }
        
        if (success) {
            success(entityArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  举报商品
 *
 *  @param entityId 商品ID
 *  @param comment  举报原因
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)reportEntityId:(NSString *)entityId
                  type:(NSInteger)type
               comment:(NSString *)comment
               success:(void (^)(BOOL success))success
               failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(entityId);
    NSParameterAssert(comment);
//    NSParameterAssert(type);
    
    NSString *path = [NSString stringWithFormat:@"entity/%@/report/", entityId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:comment forKey:@"comment"];
    [paraDict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        BOOL state = [objectDict[@"status"] boolValue];
        
        if (success) {
            success(state);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  举报点评
 *
 *  @param noteId  点评ID
 *  @param comment 举报原因
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)reportNoteId:(NSUInteger)noteId
             comment:(NSString *)comment
             success:(void (^)(BOOL success))success
             failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(noteId > 0);
    NSParameterAssert(comment);
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%lu/report/", noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:comment forKey:@"comment"];
    
    [[GKHTTPClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        BOOL state = [objectDict[@"status"] boolValue];
        
        if (success) {
            success(state);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取未读内容数值
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getUnreadCountWithSuccess:(void (^)(NSDictionary *dictionary))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"unread/";
    [[GKHTTPClient sharedClient] requestPath:path method:@"GET" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        if (success) {
            success(objectDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}
/**
 *  取消所有网络请求
 */
+ (void)cancelAllHTTPOperations
{
    [GKHTTPClient cancelAllHTTPOperations];
}
@end
