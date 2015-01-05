//
//  EmojiOne.m
//  emojiii
//
//  Created by 回特 on 14-10-4.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "EmojiOne.h"

@implementation EmojiOne

+ (EmojiOne *)shareInstance{
    static dispatch_once_t once;
    static EmojiOne *emojione;
    dispatch_once(&once, ^ { emojione = [[self alloc] init]; });
    return emojione;
}

- (instancetype)init{
    if (!self) {
        self = [super init];
    }
    self.config = [self config];
    
    return self;
}

- (NSArray *)allImage{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"]];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return [json allKeys];
}

- (NSDictionary *)config{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"]];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}

- (UIImage *)toImage:(NSString *)string{
    NSDictionary * dic = [self.config objectForKey:string];
    NSString * imageName = [dic objectForKey:@"unicode"];
    return [UIImage imageNamed:imageName];
}
@end
