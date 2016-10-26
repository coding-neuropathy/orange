//
//  GKOfflineStore.m
//  orange
//
//  Created by 谢家欣 on 2016/10/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKOfflineStore.h"
#import "NSString+Helper.h"

@implementation GKOfflineStore

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"store_id"    : @"storeId",
                             @"store_name"  : @"storeName",
                             @"store_desc"  : @"storeDesc",
                             @"store_link"  : @"storeLink",
                             @"chief_image" : @"storeImage"
                            };
    
    return keyDic;
}

- (void)setStoreLink:(NSURL *)storeLink
{
    if ([storeLink isKindOfClass:[NSURL class]]) {
        _storeLink  = storeLink;
    } else if ([storeLink isKindOfClass:[NSString class]]){
        _storeLink  = [NSURL URLWithString:(NSString *)storeLink];
    }
}

- (void)setStoreImage:(NSURL *)storeImage
{
    if ([storeImage isKindOfClass:[NSURL class]]) {
        _storeImage  = storeImage;
    } else if ([storeImage isKindOfClass:[NSString class]]){
        _storeImage  = [NSURL URLWithString:(NSString *)storeImage];
    }
}

- (NSURL *)storeImageURL_300
{
    //    NSLog(@"image url %@", self.imageURL.absoluteString);
    if ([self.storeImage.absoluteString hasPrefix:@"http://imgcdn.guoku.com/"]) {
        return [NSURL URLWithString:[self.storeImage.absoluteString imageURLWithSize:300]];
    }
    return self.storeImage;
    
//    return [NSURL URLWithString:[self.storeImage.absoluteString stringByAppendingString:@"_640x640.jpg"]];
}



@end
