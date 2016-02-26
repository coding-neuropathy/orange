//
//  OpenCenter.m
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "OpenCenter.h"
#import "UserViewController.h"
#import "authorizedUserViewController.h"
#import "EntityViewController.h"
#import "NoteViewController.h"
//#import "CategoryViewController.h"
#import "SubCategoryEntityController.h"
#import "TagViewController.h"
#import "TagArticlesController.h"

#import "WebViewController.h"

#import "AppDelegate.h"

@interface OpenCenter ()

@property (strong, nonatomic) UIViewController * controller;

@end

@implementation OpenCenter

DEFINE_SINGLETON_FOR_CLASS(OpenCenter);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _controller = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    return self;
}

- (void)openUser:(GKUser *)user
{
    if (user.authorized_author == NO) {
        UserViewController * VC = [[UserViewController alloc]init];
        VC.user = user;
        VC.hidesBottomBarWhenPushed = YES;
        [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        authorizedUserViewController * vc = [[authorizedUserViewController alloc]initWithUser:user];
        vc.user = user;
        vc.hidesBottomBarWhenPushed = YES;
        [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
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
    vc.hidesBottomBarWhenPushed = hide;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

- (void)openCategory:(GKEntityCategory *)category
{
    SubCategoryEntityController *vc = [[SubCategoryEntityController alloc] initWithSubCategory:category];
//    vc.category = category;
    //    [controller.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

- (void)openNoteComment:(GKNote *)note
{
    NoteViewController * VC = [[NoteViewController alloc]init];
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
    vc.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

@end
