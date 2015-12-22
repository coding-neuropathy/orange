//
//  API.m
//  orange
//
//  Created by 谢家欣 on 15/4/4.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "API.h"
#import "HttpClient.h"
#import "GKModel.h"
#import "NSString+Helper.h"
#import "Passport.h"

@implementation API

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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DDLogError(@"status code %lu", operation.response.statusCode);
        if (failure) {
            NSInteger statusCode = operation.response.statusCode;
            failure(statusCode);
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取启动画面
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getLaunchImageWithSuccess:(void (^)(GKLaunch * launch))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSString * path = @"launch/";
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GKLaunch * launch = [GKLaunch modelFromDictionary:responseObject];
        if (success) {
            success(launch);
        }
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
    
    NSString *path = [NSString stringWithFormat:@"category/%ld/stat", (unsigned long)categoryId];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取大分类列表
 *
 *  success block
 *  failure block
 */
+ (void)getGroupCategoryWithSuccess:(void (^)(NSArray * categories))success
                    failure:(void (^)(NSInteger stateCode))failure
{
    NSString * path = @"category/group/";
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * categories = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * row in responseObject) {
            GKCategory * category = [GKCategory modelFromDictionary:row];
            [categories addObject:category];
        }
        
        if (success) {
            success(categories);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}


/**
 *  获取分类商品列表
 *  
 *  @param gid 一级分类 id
 */
+ (void)getGroupEntityWithGroupId:(NSInteger)gid Page:(NSInteger)page
                            Sort:(NSString *)sort
                            success:(void (^)(NSArray * entities))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(gid > 0);
    NSString *path = [NSString stringWithFormat:@"category/%ld/selection/", (unsigned long)gid];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:@(page) forKey:@"page"];
    [paraDict setValue:sort forKey:@"sort"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * entities = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary * row in responseObject)
        {
            GKEntity * entity = [GKEntity modelFromDictionary:row];
            [entities addObject:entity];
        }
        if (success) {
            success(entities);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

#pragma mark - Entity API
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取商品喜爱用户
 *
 *  @param entity_id  商品ID
 *  @param page       页码page
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getEntityLikerWithEntityId:(NSString *)entity_id
                              Page:(NSInteger)page
                           success:(void (^)(NSArray *dataArray, NSInteger page))success
                           failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(entity_id);
    
    NSString *path = [NSString stringWithFormat:@"entity/%@/liker/", entity_id];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:@(page) forKey:@"page"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        
        NSMutableArray * dataArray = [NSMutableArray array];
        NSInteger page = [[responseObject objectForKey:@"page"] integerValue];
        page += 1;
        for (NSDictionary * row in responseObject[@"data"]) {
            GKUser * user = [GKUser modelFromDictionary:row];
            [dataArray addObject:user];
        }
        
        if (success) {
            success(dataArray, page);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%ld %@", operation.response.statusCode,  [error userInfo]);
        NSInteger statusCode = operation.response.statusCode;
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark - get Article data
/**
 *  获取标签下 图文列表
 *  @param  name    标签名称
 *  @param  page    页数
 *  @param  size    每页数量
 *  @param  success   成功block
 *  @param  failure   失败block
 */
+ (void)getArticlesWithTagName:(NSString *)name
                          Page:(NSInteger)page
                          Size:(NSInteger)size
                       success:(void (^)(NSArray *dataArray))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSString * path = [NSString stringWithFormat:@"articles/tags/%@", [name encodedUrl]];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(page) forKey:@"page"];
    [paraDict setObject:@(size) forKey:@"size"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@", responseObject);
        
        NSMutableArray * articleList = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in responseObject)
        {
            //            NSLog(@"%@", dict);
            GKArticle * article = [GKArticle modelFromDictionary:dict];
            [articleList addObject:article];
            NSLog(@"url %@", article.title);
        }
        if (success){
            success([NSArray arrayWithArray:articleList]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark - get main list
/**
 *  获取首页信息
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getHomeWithSuccess:(void (^)(NSArray  * banners, NSArray * articles, NSArray * categories, NSArray * entities))success
                   failure:(void (^)(NSInteger stateCode))failure
{
    NSString * path = @"home/";
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSArray *banners = responseObject[@"banner"];
//        NSLog(@"%@", responseObject[@"articles"]);
        
        NSMutableArray * articles = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary * row in responseObject[@"articles"]) {
            GKArticle * article = [GKArticle modelFromDictionary:row];
            [articles addObject:article];
        }
        
        NSMutableArray * categories = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * row in responseObject[@"categories"]) {
//            [categories addObject:row]
            GKCategory * category = [GKCategory modelFromDictionary:row];
            [categories addObject:category];
        }
        
        NSMutableArray * entities = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * row in responseObject[@"entities"]){
            GKEntity * entity = [GKEntity modelFromDictionary:row[@"entity"]];
            GKNote * note = [GKNote modelFromDictionary:row[@"note"]];
            [entities addObject:@{
                                  @"entity":entity,
                                  @"note": note,
                }];
            
        }
        
        if (success) {
            success(banners, articles, categories, entities);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger statusCode = operation.response.statusCode;
            if (failure) {
                failure(statusCode);
            }
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
//        NSLog(@"%@", responseObject);
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
 *  获取图文列表
 *  @param timestamp 时间戳
 *  @param page 翻页
 *  @param size 每页数量
 */
+ (void)getArticlesWithTimestamp:(NSTimeInterval)timestamp
            Page:(NSInteger)page
            Size:(NSInteger)size
            success:(void (^)(NSArray *articles))success
            failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"articles/";
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(page) forKey:@"page"];
    [paraDict setObject:@(size) forKey:@"size"];
//    [paraDict setObject:@(cateId) forKey:@"rcat"];
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionaryWithDictionary:paraDict] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * articleList = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in responseObject)
        {
//            NSLog(@"%@", dict);
            GKArticle * article = [GKArticle modelFromDictionary:dict];
            [articleList addObject:article];
//            NSLog(@"url %ld", article.articleId);
        }
        if (success){
            success([NSArray arrayWithArray:articleList]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

/**
 *  获取发现数据
 */
+ (void)getDiscoverWithsuccess:(void (^)(NSArray *banners, NSArray * entities, NSArray * categories, NSArray * artilces))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    NSString * path = @"discover/";

    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *bannerArray = responseObject[@"banner"];
        
        NSMutableArray * categories = [NSMutableArray arrayWithCapacity:0];
//        NSArray * categoryContent = responseObject[@"categories"];
        for (NSDictionary * objectDict in responseObject[@"categories"])
        {
            GKCategory * category = [GKCategory modelFromDictionary:objectDict[@"category"]];
//            NSLog(@"url %@", category.coverURL);
            [categories addObject:category];
        }
        
        NSMutableArray * entityArray = [NSMutableArray arrayWithCapacity:0];
        NSArray * content = responseObject[@"entities"];
        for (NSDictionary *objectDict in content) {
            GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
            [entityArray addObject:entity];
        }
        
        NSMutableArray * articles = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * row in responseObject[@"articles"])
        {
            GKArticle * article = [GKArticle modelFromDictionary:row[@"article"]];
            [articles addObject:article];
        }

        
        if (success) {
            success(bannerArray, entityArray, categories, articles);
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
//    NSParameterAssert(sort);
    NSParameterAssert(offset >= 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"category/%lu/entity/", (long)categoryId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    if (sort)
        [paraDict setObject:sort forKey:@"sort"];
    [paraDict setObject:@(reverse) forKey:@"reverse"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取用户的喜爱商品列表
 *
 *  @param userId    用户ID
 *  @param categoryId   分类ID
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getUserLikeEntityListWithUserId:(NSUInteger)userId
                             categoryId:(NSInteger)categoryId
                              timestamp:(NSTimeInterval)timestamp
                                  count:(NSInteger)count
                                success:(void (^)(NSTimeInterval timestamp, NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/like/", (unsigned long)userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    if (categoryId != 0) {
        [paraDict setObject:@(categoryId) forKey:@"cid"];
    }
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSString *path = [NSString stringWithFormat:@"category/%ld/user/%ld/like/", (unsigned long)categoryId, (long)userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:sort forKey:@"sort"];
    [paraDict setObject:@(reverse) forKey:@"reverse"];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                          success:(void (^)(NSArray *dataArray, NSTimeInterval timestamp))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    NSParameterAssert(count > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%lu/notes/", (unsigned long)userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *objectArray = (NSArray *)responseObject;
        NSTimeInterval timestamp = [responseObject[@"timestamp"] doubleValue];
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary * row in responseObject[@"notes"]) {
            GKNote *note = [GKNote modelFromDictionary:row];
            [dataArray addObject:note];
        }
        
        if (success) {
            success(dataArray, timestamp);
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
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/tag/", (unsigned long)userId];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSMutableDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"user/%lu/tag/%@/", (unsigned long)userId, tag];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[HttpClient sharedClient] requestPath:[path encodedUrl] method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/", (unsigned long)noteId];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - entity note
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/update/", (unsigned long)noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"note"];
    [paraDict setObject:@(score) forKey:@"score"];
    
    NSDictionary *dataParameters;
    if (imageData) {
        dataParameters = @{@"image":imageData};
    }
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/del/", (unsigned long)noteId];
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
};

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
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/poke/%d/", (unsigned long)noteId, state];
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/add/comment/", (unsigned long)noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"comment"];
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"entity/note/%ld/add/comment/", (unsigned long)noteId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:content forKey:@"comment"];
    if (commentId != 0 && commentCreatorId != 0) {
        [paraDict setObject:@(commentId) forKey:@"reply_to_comment"];
        [paraDict setObject:@(commentCreatorId) forKey:@"reply_to_user"];
    }
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - send tip off
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - get notification
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - user relation
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
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/follow/%d/", (unsigned long)userId, state];
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/following/", (unsigned long)userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/fan/", (unsigned long)userId];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(offset) forKey:@"offset"];
    [paraDict setObject:@(count) forKey:@"count"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - account
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    NSData *objectData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                case 409:
                {
                    NSData *objectData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            NSData *objectData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
            message = dict[@"message"];
            type = dict[@"type"];
            failure(stateCode, type, message);
        }
    }];
}

/**
 *  微信登录
 *
 *  @param unionid      微信用户 UNIONID
 *  @param nickname     微信用户昵称
 *  @param headimgurl   微信用户头像
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)loginWithWeChatWithUnionid:(NSString *)unionid Nickname:(NSString *)nickname HeaderImgURL:(NSString *)headimgurl
                           success:(void (^)(GKUser *user, NSString *session))success
                           failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    NSParameterAssert(unionid);
    NSString * path = @"wechat/login/";
    
    NSMutableDictionary * paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:unionid forKey:@"unionid"];
    [paraDict setObject:nickname forKey:@"nickname"];
    [paraDict setObject:headimgurl forKey:@"headimgurl"];
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            NSData *objectData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"error %@", [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"]);
            NSString * string = [[NSString alloc] initWithData:[[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSASCIIStringEncoding];
            NSLog(@"error %@", string);
            
            message = dict[@"message"];
            type = dict[@"type"];
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            
            failure(stateCode, type, message);
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
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSInteger stateCode = operation.response.statusCode;
//        NSLog(@"html success %lu", (long)stateCode);
        if (success) {
            success(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSString *htmlString = [[error userInfo] valueForKey:@"NSLocalizedRecoverySuggestion"];
            //            NSLog(@"html %lu", stateCode);
            NSData *objectData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
            
//            DDLogInfo(@"%@", objectData);
            //            NSDictionary *dict = [htmlString objectFromJSONString];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:nil];
            NSString * message = dict[@"message"];
            NSString * type = dict[@"type"];
            
            failure(stateCode, type, message);
        }
    }];
    
}

#pragma mark - user profile
/**
 *  获取个人主页详细信息
 *
 *  @param userId  用户ID
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserDetailWithUserId:(NSUInteger)userId
                        success:(void (^)(GKUser *user, NSArray *lastLikeEntities, NSArray  *lastNotes))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(userId > 0);
    
    NSString *path = [NSString stringWithFormat:@"user/%ld/", (unsigned long)userId];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        
        NSMutableArray * entities = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * row in objectDict[@"last_user_like"]) {
            GKEntity * entity = [GKEntity modelFromDictionary:row];
            [entities addObject:entity];
        }
        
        NSMutableArray * notes = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * row in objectDict[@"last_post_note"]) {
            GKNote * note = [GKNote modelFromDictionary:row];
            [notes addObject:note];
        }
        
        GKUser *user = [GKUser modelFromDictionary:objectDict[@"user"]];
//        NSLog(@"user %ld", user.relation);
        if (success) {
            success(user, entities, notes);
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict dataParameters:dataParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
//            NSLog(@"error %@", [[error userInfo] allKeys]);
            NSData * resData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSDictionary * messageObj = [NSJSONSerialization JSONObjectWithData:resData options:0 error:nil];
            failure(stateCode, [messageObj valueForKeyPath:@"message"]);
        }
    }];
}

/**
 *  验证邮用户箱
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)verifiedEmailWithParameters:(NSDictionary *)parameters
                            success:(void (^)(NSInteger stateCode))success
                            failure:(void (^)(NSInteger stateCode, NSString *errorMsg))failure
{
    NSString *path = @"user/email/verified/";
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;

        NSLog(@"%@", objectDict);
        NSInteger statecode = [[objectDict objectForKey:@"error"] integerValue];
        if (success) {
            success(statecode);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            
            NSData * resData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSDictionary * messageObj = [NSJSONSerialization JSONObjectWithData:resData options:0 error:nil];
            failure(stateCode, [messageObj valueForKeyPath:@"message"]);
        }
    }];
}

/**
 *  更新当前用户密码
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
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *objectDict = (NSDictionary *)responseObject;
        
        GKUser *user = [GKUser modelFromDictionary:objectDict];
        
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            NSData * resData = [[error userInfo] valueForKey:@"com.alamofire.serialization.response.error.data"];
            NSDictionary * messageObj = [NSJSONSerialization JSONObjectWithData:resData options:0 error:nil];
//            NSLog(@"message %@", messageObj);
            failure(stateCode, [messageObj valueForKeyPath:@"message"]);
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
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  用户注销
 *
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)logoutWithSuccess:(void (^)())success
                  failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"logout/";
    
    [[HttpClient sharedClient] requestPath:path method:@"POST" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - Search API
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  搜索图文
 *
 *  @param  string      搜索关键词
 *  @param  page        翻页
 *  @param  size        长度
 *  @param  succes      成功block
 *  @param  failure     失败block
 */
+ (void)searchArticlesWithString:(NSString *)string
                            Page:(NSInteger)page
                            Size:(NSInteger)size
                         success:(void (^)(NSArray * articles))success
                         failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(string);
    
    NSString *path = @"articles/search/";
    
    NSMutableDictionary * paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:string forKey:@"q"];
    [paraDict setObject:@(page) forKey:@"page"];
    [paraDict setObject:@(size) forKey:@"size"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSMutableArray *articles = [NSMutableArray array];
        
        for(NSDictionary * row in responseObject[@"articles"]) {
            GKArticle * article = [GKArticle modelFromDictionary:row];
            [articles addObject:article];
        }

        if (success) {
            success(articles);
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
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
 *  获取未读内容数值
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getUnreadCountWithSuccess:(void (^)(NSDictionary *dictionary))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"unread/";
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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


#pragma mark - get wechat open_uid
/**
 *  获取微信用户 OPEN ID
 *  @param weixin app key
 *  @param weixin app secret
 *  @param
 */
+ (NSDictionary *)getWeChatAuthWithAppKey:(NSString *)appkey Secret:(NSString *)secret Code:(NSString *)code
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", appkey, secret, code];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSError * error = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error) {
//        DDLogError(@"Error: %@", error.localizedDescription);
        return nil;
    }
    
    //    NSString * responseObj = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    DDLogInfo(@"%@", responseObj);
    id JSON = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
//    DDLogInfo(@"json %@", JSON);
    return JSON;
}

/**
 *  获取微信用户信息
 *
 *  @param accesstoken
 *  @param open_id
 */
+ (NSDictionary *)getWeChatUserInfoWithAccessToken:(NSString *)access_token OpenID:(NSString *)open_id
{
    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",  access_token, open_id];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSError * error = nil;
//    DDLogInfo(@"url %@", urlString);
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
//        DDLogError(@"Error: %@", error.localizedDescription);
        return nil;
    }
    
    //    NSString * responseObj = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    DDLogInfo(@"%@", responseObj);
    id JSON = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
    //    DDLogInfo(@"json %@", JSON);
    return JSON;
}

#pragma mark - today
/**
 *  获取 24小时 Top 10 商品列表
 *
 *  @param count   获取商品个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getTopTenEntityCount:(NSInteger)count
                     success:(void (^)(NSArray * array))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    NSString *path = @"toppopular/";
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(count) forKey:@"count"];
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
        NSMutableArray *dataArray = [NSMutableArray array];
        //        NSArray *content = responseObject[@"content"];
        for (NSDictionary *objectDict in objectArray) {
            GKEntity * entity = [GKEntity modelFromDictionary:objectDict[@"content"][@"entity"]];
            GKNote * note = [GKNote modelFromDictionary:objectDict[@"content"][@"note"]];
            //            GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
            //            [entityArray addObject:entity];
            [dataArray addObject:@{
                                   @"entity":entity,
                                   @"note":note
                                   }];
        }
        
        if (success) {
            success(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //            NSLog(@"%@", [[error userInfo] allKeys]);
            //            NSLog(@"url %@", [[error userInfo] valueForKey:@"NSErrorFailingURLKey"]);
            
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

#pragma mark - cancel all requet
/**
 *  取消所有网络请求
 */
+ (void)cancelAllHTTPOperations
{
    [HttpClient cancelAllHTTPOperations];
}

@end
