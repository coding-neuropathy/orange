//
//  EmojiOne.h
//  emojiii
//
//  Created by 回特 on 14-10-4.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiOne : NSObject
@property (nonatomic, strong)NSDictionary * config;

+ (EmojiOne *)shareInstance;
- (NSArray *)allImage;
- (UIImage *)toImage:(NSString *)string;

@end
