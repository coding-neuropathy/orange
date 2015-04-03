//
//  API.m
//  orange
//
//  Created by 谢家欣 on 15/4/4.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "API.h"
#import "HttpClient.h"

@implementation API

+ (void)getSelectionListWithTimestamp:(NSTimeInterval)timestamp
//                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *dataArray))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    NSParameterAssert(count > 0);
//    NSParameterAssert(cateId >= 0 && cateId <= 11);
    
    NSString *path = @"selection/";
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:@(timestamp) forKey:@"timestamp"];
    [paraDict setObject:@(count) forKey:@"count"];
//    [paraDict setObject:@(cateId) forKey:@"rcat"];
    
    [[HttpClient sharedClient] requestPath:path method:@"GET" parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *objectArray = (NSArray *)responseObject;
        
//        NSMutableArray *selectionArray = [NSMutableArray array];
//        for (NSDictionary *selectionDict in objectArray) {
//            NSString *type = selectionDict[@"type"];
//            NSTimeInterval timestamp = [selectionDict[@"post_time"] doubleValue];
//            NSDictionary *content;
//            NSDictionary *contentDict = selectionDict[@"content"];
//            if ([type isEqualToString:@"note_selection"]) {
//                // 点评精选
//                NSDictionary *noteDict = contentDict[@"note"];
//                GKNote *note = [GKNote modelFromDictionary:noteDict];
//                NSDictionary *entityDict = contentDict[@"entity"];
//                GKEntity *entity = [GKEntity modelFromDictionary:entityDict];
//                content = @{@"note"   : note,
//                            @"entity" : entity};
//            }
//            
//            NSParameterAssert(content);
//            
//            NSDictionary *selection = @{@"type"    : type,
//                                        @"time"    : @(timestamp),
//                                        @"content" : content};
//            [selectionArray addObject:selection];
//        }
        
        if (success) {
            success(objectArray);
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
//        
//        NSMutableArray *entityArray = [NSMutableArray array];
        NSArray *content = objectDict[@"content"];
//        for (NSDictionary *objectDict in content) {
//            GKEntity *entity = [GKEntity modelFromDictionary:objectDict[@"entity"]];
//            [entityArray addObject:entity];
//        }
        
        if (success) {
            success(content);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            NSInteger stateCode = operation.response.statusCode;
            failure(stateCode);
        }
    }];
}

@end
