//
//  OpenCenter.m
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "OpenCenter.h"
#import "UserViewController.h"
#import "AuthUserViewController.h"
#import "EntityViewController.h"
#import "NoteViewController.h"
//#import "CategoryViewController.h"
#import "SubCategoryEntityController.h"
#import "TagViewController.h"
#import "TagArticlesController.h"

#import "WebViewController.h"
#import "ArticleWebViewController.h"
#import "AppDelegate.h"

#import "AuthController.h"

@interface OpenCenter ()

@property (strong, nonatomic) UIViewController * controller;

@end

@implementation OpenCenter

DEFINE_SINGLETON_FOR_CLASS(OpenCenter);

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _controller = [[UIApplication sharedApplication] keyWindow].rootViewController;
//    }
//    return self;
//}

- (UIViewController *)controller
{
    if (!_controller) {
        _controller = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    return _controller;
}

- (void)openAuthPage
{
    AuthController * vc = [[AuthController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.controller presentViewController:nav animated:YES completion:nil];
}

- (void)openAuthUser:(GKUser *)user
{
    AuthUserViewController * vc = [[AuthUserViewController alloc] initWithUser:user];
    if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
    
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

- (void)openNormalUser:(GKUser *)user
{
    UserViewController * VC = [[UserViewController alloc]init];
    VC.user = user;
    if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

- (void)openUser:(GKUser *)user
{
    if (!user.nickname)
    {
        [API getUserDetailWithUserId:user.userId success:^(GKUser *user, NSArray *lastLikeEntities, NSArray *lastNotes, NSArray *lastArticles) {
            
            user.authorized_author ? [self openAuthUser:user] : [self openNormalUser:user];

        } failure:^(NSInteger stateCode) {
            [self openNormalUser:user];
        }];
    }
    else
    {
        user.authorized_author ? [self openAuthUser:user] : [self openNormalUser:user];

    }
}

- (void)openEntity:(GKEntity *)entity
{
    [self openEntity:entity hideButtomBar:NO];
//    EntityViewController * vc = [[EntityViewController alloc] initWithEntity:entity];
//    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)openEntity:(GKEntity *)entity hideButtomBar:(BOOL)hide
{
    EntityViewController * vc = [[EntityViewController alloc] initWithEntity:entity];
//    vc.title = NSLocalizedStringFromTable(@"entity", kLocalizedFile, nil);
    if (IS_IPHONE) vc.hidesBottomBarWhenPushed = hide;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

- (void)openCategory:(GKEntityCategory *)category
{
    SubCategoryEntityController *vc = [[SubCategoryEntityController alloc] initWithSubCategory:category];
//    vc.category = category;
    //    [controller.navigationController pushViewController:vc animated:YES];
    if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

- (void)openNoteComment:(GKNote *)note
{
    NoteViewController * VC = [[NoteViewController alloc] init];
    VC.note = note;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

#pragma mark - tag viewcontroller
- (void)openTagWithName:(NSString *)tname User:(GKUser *)user
{
    TagViewController * vc = [[TagViewController alloc]init];
    vc.tagName = tname;
    vc.user = user;
//    vc.user = self.note.creator;
    if (kAppDelegate.activeVC.navigationController) {
        [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)openArticleTagWithName:(NSString *)name
{
    TagArticlesController * vc = [[TagArticlesController alloc] initWithTagName:name];
    
    if (kAppDelegate.activeVC.navigationController) {
        [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)openWebWithURL:(NSURL *)url
{
    WebViewController * vc = [[WebViewController alloc] initWithURL:url];
    if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
//    vc.hidesBottomBarWhenPushed = NO;
}

- (void)openArticleWebWithArticle:(GKArticle *)article
{
    ArticleWebViewController * vc = [[ArticleWebViewController alloc] initWithArticle:article];
//    if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
    if (IS_IPAD) vc.tabBarController.tabBar.hidden = YES;
//    vc.hidesBottomBarWhenPushed = NO;
}


@end
