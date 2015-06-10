//
//  OpenCenter.h
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenCenter : NSObject

DEFINE_SINGLETON_FOR_HEADER(OpenCenter);

- (void)openUser:(GKUser *)user;
- (void)openEntity:(GKEntity *)entity;
- (void)openNoteComment:(GKNote *)note;
- (void)openCategory:(GKEntityCategory *)category;

@end
