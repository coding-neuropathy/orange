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
@property (strong, nonatomic) JSQMessagesBubbleImageFactory * bubbleFactory;

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
        self.title = NSLocalizedStringFromTable(@"feedback", kLocalizedFile, nil);
        self.view.backgroundColor = UIColorFromRGB(0xfafafa);
        self.messageData = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
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
//    [self.feedback get];
    self.feedback.delegate = self;
    self.senderId = @"user_reply";
    self.senderDisplayName = [Passport sharedInstance].user.nickname ? [Passport sharedInstance].user.nickname : @"Anonymous" ;
    
    if (k_isLogin){
        [[UMFeedback sharedInstance] updateUserInfo:@{@"contact": @{
                                                                    @"email": [Passport sharedInstance].user.email,}}];
    }
    
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
//    self.inputToolbar.sendButtonOnRight = NO;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    self.inputToolbar.contentView.textView.layer.borderWidth = 0;
//    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (IS_IPAD) self.tabBarController.tabBar.hidden = YES;
    [super viewDidAppear:animated];
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
                                  @"type": self.senderId,
                                  };
    [[UMFeedback sharedInstance] post:postContent];
    JSQMessage * message = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:@"user" date:[NSDate date] text:postContent[@"content"]];
    
    [self.messageData addObject:message];
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
//    JSQMessagesBubbleImageFactory * bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    if ([message.senderId isEqualToString:self.senderId]) {
        return [self.bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
    }
    return [self.bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"row %lu", [self.messageData count]);
    return [self.messageData count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell * cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messageData objectAtIndex:indexPath.item];

    if ([msg.senderId isEqualToString:self.senderId]) {
        
    } else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                                                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    return cell;
}


#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.;
    /**
     *  iOS7-style sender name labels
     */
//    JSQMessage *currentMessage = [self.messageData objectAtIndex:indexPath.item];
//    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
//        return 0.0f;
//    }
//    
//    if (indexPath.item - 1 > 0) {
//        JSQMessage *previousMessage = [self.messageData objectAtIndex:indexPath.item - 1];
//        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
//            return 0.0f;
//        }
//    }
//    
//    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

#pragma mark - UMFeedback Delegate

- (void)getFinishedWithError:(NSError *)error {
    if (error != nil) {
//        NSLog(@"%@", error);
    } else {
//        NSLog(@"feed back %@", self.feedback.topicAndReplies);
        for(NSDictionary * row in self.feedback.topicAndReplies) {
            DDLogInfo(@"row %@", row);

            JSQMessage * message = [[JSQMessage alloc] initWithSenderId:row[@"type"] senderDisplayName:row[@"reply_id"] date:[NSDate dateWithTimeIntervalSince1970:[row[@"create_at"] integerValue]] text:row[@"content"]];
            
            [self.messageData addObject:message];
        }
//        [self finishReceivingMessageAnimated:YES];        
    }
}

- (void)postFinishedWithError:(NSError *)error {
    if (error != nil) {
        DDLogError(@"Error: %@", error);
    } else {
//        DDLogInfo(@"%@", self.feedback.topicAndReplies);
        [self finishSendingMessageAnimated:YES];
    }
}

@end
