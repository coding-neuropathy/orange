//
//  ReportViewController.h
//  orange
//
//  Created by huiter on 15/2/2.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TipOffType) {
    /*
     * 商品下架
     */
    SoldOutType,
    
    /*
     * 分类错误
     */
    MissCategoryType,
    
    /*
     * 垃圾或诈骗信息
     */
    MeaningLessInfoType,
    
    /*
     * 不良信息
     */
    MalicaiousInfoType,
};

@interface ReportViewController : BaseViewController
@property (strong, nonatomic)GKNote * note;
@property (strong, nonatomic)GKEntity * entity;
@property (strong, nonatomic)NSString * type;
@property (nonatomic, copy) void (^successBlock)(GKNote *);

@end
