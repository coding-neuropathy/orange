//
//  AppDelegate.h
//  Guoku
//
//  Created by 回特 on 14-9-26.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * root;
@property (strong, nonatomic) UIViewController * activeVC;
@property (strong, nonatomic) NSMutableArray *allCategoryArray;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (assign, nonatomic) NSUInteger messageCount;
//
//// 被管理对象上下文 （数据管理器）
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//// 被管理对象模型 （数据模型器）
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//// 持久化储存助理 （数据链接器）
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//// 临时数据库中进行的改变进行永久保存
//- (void)saveContext;
//// 获取真实文件的存储路径
//- (NSURL *)applicationDocumentsDirectory;

@end

