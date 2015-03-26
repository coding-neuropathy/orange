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
//#import "JSQMessagesCollectionViewCell.h"
#import "NSString+Helper.h"


@interface FeedBackViewController () <UMFeedbackDataDelegate>

@property (strong, nonatomic) UMFeedback *feedback;
@property (strong, nonatomic) UIView * containerView;
@property (strong, nonatomic) NSMutableArray *messageData;

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
        self.messageData = [[NSMutableArray alloc] initWithCapacity:0];
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
    
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
//    self.inputToolbar.sendButtonOnRight = NO;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
//    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;

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
//    NSLog(@"text %@ sender id %@ gender %@", text, senderId, [Passport sharedInstance].user.gender);
    NSString * gender = @"0";
    if ([[Passport sharedInstance].user.gender isEqualToString:@"M"]) {
        gender = @"1";
    }
    
    NSDictionary *postContent = @{@"content":text,
                                  @"gender": gender,
                                  @"type": @"user_reply",
                                  };
    [[UMFeedback sharedInstance] post:postContent];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messageData objectAtIndex:indexPath.item];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return nil;
    JSQMessage *message = [self.messageData objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:@"dev_reply"]) {
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"wxshare.png"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    }
    return nil;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageData objectAtIndex:indexPath.item];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    if ([message.senderId isEqualToString:@"dev_reply"]) {
        return [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
}

//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    JSQMessage *message = [self.messageData objectAtIndex:indexPath.item];
//    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"row %lu", [self.messageData count]);
    return [self.messageData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell * cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
//    JSQMessage *msg = [self.messageData objectAtIndex:indexPath.item];

    cell.textView.textColor = [UIColor blackColor];
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                                                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    return cell;
}

#pragma mark - UMFeedback Delegate

- (void)getFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
//        NSLog(@"feed back %@", self.feedback.topicAndReplies);
        for(NSDictionary * row in self.feedback.topicAndReplies) {
            NSLog(@"row %@", row);

            JSQMessage * message = [[JSQMessage alloc] initWithSenderId:row[@"type"] senderDisplayName:row[@"reply_id"] date:[NSDate dateWithTimeIntervalSince1970:[row[@"create_at"] integerValue]] text:row[@"content"]];
            
            [self.messageData addObject:message];
        }
        NSLog(@"%@", self.messageData);
        [self finishReceivingMessageAnimated:YES];
        [self.collectionView reloadData];
        
    }
}

- (void)postFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
//        NSLog(@"post post %@", self.feedback.topicAndReplies);
//        for (NSDictionary * dict in self.feedback.topicAndReplies ) {
//            NSLog(@"post post %@")
//        }
        
        
//        self.messageData = self.feedback.topicAndReplies;
    }
}

@end
