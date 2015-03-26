//
//  FeedBackViewController.m
//  orange
//
//  Created by 谢家欣 on 15/3/26.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UMFeedback.h"
#import "JSQMessages.h"



@interface FeedBackViewController () <UMFeedbackDataDelegate>

@property (strong, nonatomic) UMFeedback *feedback;
@property (strong, nonatomic) UIView * containerView;

@end

@implementation FeedBackViewController

+ (UINavigationController *)feedbackModalViewController
{
    FeedBackViewController * controller = [[FeedBackViewController alloc] init];
    controller.type = FeedBackTypeModal;
    UINavigationController * nav  = [[UINavigationController alloc] initWithRootViewController:controller];
    //    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(diss:)];
    return nav;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"意见反馈";
        self.view.backgroundColor = UIColorFromRGB(0xfafafa);
    }
    return self;
}

- (void)dealloc
{
    self.feedback.delegate = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UMFeedback setAppkey:UMENG_APPKEY];
    [UMFeedback setLogEnabled:NO];
//    [UMFeedback setVersion:XcodeAppVersion];
    self.feedback = [UMFeedback sharedInstance];
    [self.feedback get];
    self.feedback.delegate = self;
    
//    self.inputToolbar.sendButtonOnRight = NO;
    self.inputToolbar.contentView.leftBarButtonItem = nil;

}

- (void)setType:(FeedBackType)type
{
    _type = type;
//    NSLog(@"type %lu", self.type);
    switch (_type) {
        case FeedBackTypeModal:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
            break;
        default:
            break;
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    NSLog(@"text %@ sender id %@", text, senderId);
    
    NSDictionary *postContent = @{@"content":text,
                                  @"gender": [Passport sharedInstance].user.gender,
                                  @"age_group":@"3",
                                  @"type": @"user_reply",
                                  };
    [[UMFeedback sharedInstance] post:postContent];
    [self finishSendingMessageAnimated:YES];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UMFeedback Delegate

- (void)getFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"feed back %@", self.feedback.topicAndReplies);
    }
}

- (void)postFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"post post %@", self.feedback.topicAndReplies);
    }
}

@end
