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

- (void)openAuthPage;
- (void)openAuthPageWithSuccess:(void (^)())success;

- (void)openWithController:(UIViewController *)controller User:(GKUser *)user;
- (void)openUser:(GKUser *)user;
- (void)openAuthUser:(GKUser *)user;

- (void)openEntity:(GKEntity *)entity;
- (void)openWithController:(UIViewController *)controller Entity:(GKEntity *)entity;
- (void)openEntity:(GKEntity *)entity hideButtomBar:(BOOL)hide;

- (void)openNoteComment:(GKNote *)note;
- (void)openCategory:(GKEntityCategory *)category;

- (void)openTagWithName:(NSString *)tname User:(GKUser *)user;
- (void)openTagWithName:(NSString *)tname User:(GKUser *)user Controller:(UIViewController *)controller;

- (void)openArticleTagWithName:(NSString *)name;

/**
 *  open webview with URL
 */
- (void)openStoreWithURL:(NSURL *)url;
- (void)openWebWithURL:(NSURL *)url;

- (void)openArticleWebWithArticle:(GKArticle *)article;

@end
