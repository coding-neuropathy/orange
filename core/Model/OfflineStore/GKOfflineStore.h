//
//  GKOfflineStore.h
//  orange
//
//  Created by 谢家欣 on 2016/10/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKOfflineStore : GKBaseModel

@property (assign, nonatomic) NSInteger storeId;
@property (strong, nonatomic) NSString  *storeName;
@property (strong, nonatomic) NSString  *storeDesc;
@property (strong, nonatomic) NSURL     *storeLink;
@property (strong, nonatomic) NSURL     *storeImage;
@property (strong, nonatomic) NSURL     *storeImageURL_300;

@end
