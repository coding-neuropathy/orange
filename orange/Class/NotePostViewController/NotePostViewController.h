//
//  NotePostViewController.h
//  orange
//
//  Created by huiter on 15/1/30.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotePostViewController : BaseViewController
@property (strong, nonatomic)GKNote * note;
@property (strong, nonatomic)GKEntity * entity;
@property (nonatomic, copy) void (^successBlock)(GKNote *);
@end
