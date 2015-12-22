//
//  NotePostViewController.h
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotePostViewController : BaseViewController
//点评
@property (strong, nonatomic)GKNote * note;
//商品
@property (strong, nonatomic)GKEntity * entity;
//点评成功的回调
@property (nonatomic, copy) void (^successBlock)(GKNote *);
@end
