//
//  ReportViewController.h
//  orange
//
//  Created by huiter on 15/2/2.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : BaseViewController
@property (strong, nonatomic)GKNote * note;
@property (strong, nonatomic)GKEntity * entity;
@property (strong, nonatomic)NSString * type;
@property (nonatomic, copy) void (^successBlock)(GKNote *);

@end
