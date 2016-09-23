//
//  MessagesViewController.m
//  imessage
//
//  Created by 谢家欣 on 16/9/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageCell.h"
#import "GKSelectionArticle.h"

@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView  *tableView;
@property (strong, nonatomic) GKSelectionArticle    *articles;
@property (strong, nonatomic) UIRefreshControl      *rfControl;

@end

@implementation MessagesViewController

static NSString *MessageIdentified    = @"messageCell";

- (void)dealloc
{
    [self.articles removeTheObserverWithObject:self];
}

- (GKSelectionArticle *)articles
{
    if (!_articles) {
        _articles   = [[GKSelectionArticle alloc] init];
        [_articles addTheObserverWithObject:self];
    }
    return _articles;
}

#pragma mark - lazy load view
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView                  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame            = CGRectMake(0., 0., kScreenWidth, kScreenHeight);
        _tableView.rowHeight        = 120.;
        _tableView.dataSource       = self;
        _tableView.delegate         = self;
//        UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//        _tableView.separatorEffect  = [UIVibrancyEffect effectForBlurEffect:(UIBlurEffect*)blur.effect];
        _tableView.separatorColor   = [UIColor colorFromHexString:@"#e6e6e6"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];

    
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:MessageIdentified];
    
    [self.articles getDataFromWomhole];
}

- (void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell       = [tableView dequeueReusableCellWithIdentifier:MessageIdentified forIndexPath:indexPath];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.article            = [self.articles objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self.activeConversation]
    
    MSMessage   *message    = [[MSMessage alloc] init];
    MSMessageTemplateLayout *layout     = [[MSMessageTemplateLayout alloc] init];
//    layout.image                            
    layout.imageTitle   = cell.article.title;
    layout.trailingCaption  = cell.article.digest;
//    layout.caption      = [NSString stringWithFormat:@"guoku://article/%ld", cell.article.articleId];
    layout.image    = cell.coverImage;
    message.layout  = layout;
    [self.activeConversation insertMessage:message completionHandler:^(NSError * _Nullable error) {

    }];
    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isRefreshing"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.articles.error) {
                [self.tableView reloadData];
            } else {
   
            }
        }
    }
    if ([keyPath isEqualToString:@"isLoading"]) {
        if( ![[change valueForKeyPath:@"new"] integerValue])
        {
            if (!self.articles.error) {
                [self.tableView reloadData];
            } else {

            }
        }
    }
    
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

@end
