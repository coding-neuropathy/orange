//
//  SettingViewController.m
//  emojiii
//
//  Created by huiter on 14/12/10.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingsViewCell.h"
#import "SettingsFooterView.h"

#import "WXApi.h"
#import "API.h"
//#import "LoginView.h"
#import "AuthController.h"

//#import "GKWebVC.h"
#import "WebViewController.h"
#import "FeedBackViewController.h"
//#import "UpdateEmailController.h"
#import "VerifyEmailViewController.h"
#import "PasswordEditViewController.h"


static NSString *SettingTableIdentifier = @"SettingCell";


@interface SettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, SettingsFooterViewDelegate, WBHttpRequestDelegate>

@property (nonatomic,strong)VerifyEmailViewController * vc;
@property(nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISwitch * switch_notification;
@property (nonatomic, strong) UISwitch * switch_assistant;
@property (nonatomic, strong) SettingsFooterView * footerView;

@property (nonatomic, strong) UILabel * versionLabel;

@property (nonatomic, strong) id<ALBBLoginService> loginService;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = NSLocalizedStringFromTable(@"settings", kLocalizedFile, nil);
        self.dataArray = [NSMutableArray array];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_icon_setting"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.tabBarItem = item;
        
        _loginService = [[TaeSDK sharedInstance] getService:@protocol(ALBBLoginService)];
    }
    return self;
}

- (SettingsFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[SettingsFooterView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth - kTabBarWidth, 120.)];
        if (IS_IPHONE) {
            _footerView.frame = CGRectMake(0., 0., kScreenWidth, 120.);
        }
        
        _footerView.delegate = self;
        _footerView.is_login = k_isLogin;
//        _footerView.backgroundColor = [UIColor redColor];
//        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _footerView.autoresizesSubviews = YES;
    }
    return _footerView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        
        if (IS_IPHONE) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        } else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.autoresizesSubviews = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorFromRGB(0xebebeb);
    }
    return _tableView;
}

- (void)loadView
{
//    self.view = self.tableView;
    [super loadView];
    
    [self.view addSubview:self.tableView];
//    [self.footerView addSubview:self.versionLabel];
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);

//    self.versionLabel.deFrameBottom = self.footerView.deFrameHeight - 20.;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedStringFromTable(@"settings", kLocalizedFile, nil);
//    if (self.navigationController.viewControllers.count > 1) {
//        self.tabBarController.tabBar.hidden = YES;
//        self.tabBarController.tabBar.translucent = YES;
//    }
    
    /**
     *  账号安全
     */
    if (k_isLogin) {
        NSDictionary * accountSection = @{@"section": @"account",
                                      @"row": @[
                                          @"mail",
                                          @"password"
                                          ]};
        [self.dataArray addObject:accountSection];
    }

    NSDictionary *recommandSection = @{@"section" : @"recommandtion",
                                    @"row"     : @[
                                            @"share application to wechat",
                                            @"share application to weibo",
                                            @"app store review",
                                            ]};
    [self.dataArray addObject:recommandSection];
    
    // 其他
    NSDictionary *otherSection = @{@"section" : @"other",
                                   @"row"     : @[
//                                           @"about",
//                                           @"agreement",
                                           @"clear image cache",
                                           @"feedback",
//                                           @"version",
                                           ]};
    [self.dataArray addObject:otherSection];
    
    
    [self.tableView registerClass:[SettingsViewCell class] forCellReuseIdentifier:SettingTableIdentifier];
    self.tableView.tableFooterView = self.footerView;
//    self.versionLabel.deFrameBottom = self.footerView.deFrameHeight - 20.;
    
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.view.autoresizesSubviews = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [AVAnalytics beginLogPageView:@"SettingView"];
    [MobClick beginLogPageView:@"SettingView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [AVAnalytics endLogPageView:@"SettingView"];
    [MobClick endLogPageView:@"SettingView"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         // do whatever
         //         if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
         //             self.tableView.frame = CGRectMake(0., 0., size.width, size.height);
         //         } else {
         //             self.tableView.frame = CGRectMake(0., 0., size.width, size.height);
         //         }
         self.tableView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         //         self.tableView.contentSize = size;
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
//                  [self.tableView reloadData];
         //         DDLogInfo(@"info %f %f", size.width, size.height);
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section][@"row"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SettingsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier forIndexPath:indexPath];
    
    cell.text = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"row"] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    NSString * section = [[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"section"];
    
    /**
     *  分享
     */
    if ([section isEqualToString:@"link settings"]) {
        switch (indexPath.row) {
            case 0:
            {
                if ([Passport sharedInstance].user.sinaScreenName) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解除绑定" message:@"" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) otherButtonTitles:NSLocalizedStringFromTable(@"confirm", kLocalizedFile, nil), nil];
                    alertView.alertViewStyle = UIAlertViewStyleDefault;
                    alertView.tag = 40001;
                    [alertView show];
//                    break;
                }
            }
                break;
            case 1:
            {
            
            }
                break;
            default:
                break;
        }
    }
    
    /**
     *  账号
     */
    if ([section isEqualToString:@"account"]) {
        switch (indexPath.row) {
            case 0:
            {
                
                [self.navigationController pushViewController:self.vc animated:YES];
            }
                
                break;
            case 1:
            {
                PasswordEditViewController * VC = [[PasswordEditViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
    /**
     *  推荐果库
     */
    if ([section isEqualToString:@"recommandtion"])
    {
        if (indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享" message:@"" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil)  otherButtonTitles:@"分享给好友", @"分享到朋友圈", nil];
            alertView.alertViewStyle = UIAlertViewStyleDefault;
            alertView.tag =20007;
            [alertView show];
        }
        if (indexPath.row == 1) {
            [self weiboShare];
        }
        if (indexPath.row == 2) {
            NSString* url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    }
    
    
    if ([section isEqualToString:@"other"]) {
        switch (indexPath.row) {
//            case 0:
//            {
//                [self.navigationController pushViewController:[GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:@"http://www.guoku.com/about/"]] animated:YES];
//            }
//                break;
            case 0:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除图片缓存？" message:@"" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil)  otherButtonTitles:@"确认清除", nil];
//                alertView.alertViewStyle = UIAlertViewStyleDefault;
//                alertView.tag = 20008;
//                [alertView show];
                UIAlertController * clearCacheAlert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"clear image cache", kLocalizedFile, nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                }];
                UIAlertAction * confirm = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"confirm", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[SDImageCache sharedImageCache] clearMemory];
                    [[SDImageCache sharedImageCache] clearDisk];
                    [self performSelectorOnMainThread:@selector(showClearPicCacheFinish) withObject:nil waitUntilDone:YES];
                }];
                
                [clearCacheAlert addAction:cancel];
                [clearCacheAlert addAction:confirm];
                [self presentViewController:clearCacheAlert animated:YES completion:nil];
            }
                break;
            
            case 1:
            {
                
                [self presentViewController:[FeedBackViewController feedbackModalViewController] animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==20007)
    {
        if(buttonIndex == 1)
        {
            [self wxShare:0];
        }
        if(buttonIndex == 2)
        {
            [self wxShare:1];
        }
    }

    
    if (alertView.tag == 40001) {
        if (buttonIndex == 1) {
//            NSLog(@"unbind weibo %@", [Passport sharedInstance].user.sinaScreenName);
            [API unbindSNSWithUserId:[Passport sharedInstance].user.userId SNSUserName:[Passport sharedInstance].user.sinaScreenName setPlatform:GKSinaWeibo success:^(bool status) {
                if (status) {
//                    [Passport sharedInstance].screenName = nil;
                    [Passport sharedInstance].user.sinaScreenName = nil;
                    [Passport sharedInstance].screenName = nil;
                    DDLogInfo(@"sina screen name %@", [Passport sharedInstance].user.sinaScreenName);
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"unbind success", kLocalizedFile, nil)];
                    
                    [self.tableView reloadData];
                }
                
            } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
                [SVProgressHUD showErrorWithStatus:message];
            }];
        }
    }
}

- (void)clearPicCache
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [self performSelectorOnMainThread:@selector(showClearPicCacheFinish) withObject:nil waitUntilDone:YES];
}
- (void)showClearPicCacheFinish
{
    [SVProgressHUD showSuccessWithStatus:@"清空成功"];
}

- (void)handleSwith:(UISwitch *)sender
{
    if (sender == self.switch_notification) {
        
    }
}
#pragma mark - WX&Weibo
-(void)wxShare:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"果库 - 精英消费指南";
    message.description= @"帮助你发现互联网上最有趣、最人气、最实用的好商品，恪守选品标准和美学格调，开拓精英视野与生活想象。";
    [message setThumbImage:[UIImage imageNamed:@"wxshare.png"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];;
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

-(void)weiboShare
{
    WBMessageObject *message = [WBMessageObject message];
    //    message.text = self.title;
    WBImageObject *image = [WBImageObject object];
    message.text = @"果库 - 精英消费指南。帮助你发现互联网上最有趣、最人气、最实用的好商品，恪守选品标准和美学格调，开拓精英视野与生活想象。 http://www.guoku.com?from=weibo";
    image.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"weibo_share.jpg"], 1.0);
    message.imageObject = image;
    
    
    //    WBWebpageObject *webpage = [WBWebpageObject object];
    //    webpage.objectID = [self.title md5];
    //    webpage.title = self.title;
    ////    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
    ////    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
    //    webpage.thumbnailData = UIImageJPEGRepresentation(self.image, 0.5);
    //    webpage.webpageUrl = [self.url stringByAppendingString:@"?from=weibo"];
    //
    //    message.mediaObject = webpage;
    
    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kGK_WeiboRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    
//    [AVOSCloudSNS shareText:@"果库 - 精英消费指南。帮助你发现互联网上最有趣、最人气、最实用的好商品，恪守选品标准和美学格调，开拓精英视野与生活想象。" andLink:@"http://www.guoku.com" andImage:[UIImage imageNamed:@"weibo_share.jpg"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
//                
//    } andProgress:^(float percent) {
//        if (percent == 1) {
////            [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
//            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//        }
//    }];

}

#pragma mark - Setting Footer View Delegate

- (void)TapLoginBtnAction
{
//    LoginView * view = [[LoginView alloc] init];
//    [view show];
    AuthController * authVC = [[AuthController alloc] init];
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    [top presentViewController:authVC animated:YES completion: nil];
//    [self presentViewController:authVC animated:YES completion:nil];
}

- (void)TapLogoutBtnAction
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * cacnel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //        [altervc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"confirm", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self logout];
    }];
    
    [alert addAction:cacnel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logout
{
    NSString * wbtoken = [[NSUserDefaults standardUserDefaults] valueForKey:@"wbtoken"];
    [API logoutWithSuccess:^{
//        [AVUser logOut];
        [self.loginService logout];
        [WeiboSDK logOutWithToken:wbtoken delegate:self withTag:@"wb_sign_out"];
        [Passport logout];

//        [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@", smile, @"退出成功"]];
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        
    } failure:^(NSInteger stateCode) {
        if(stateCode == 500) {
        
        } else {
//            [AVUser logOut];
            [self.loginService logout];
            [WeiboSDK logOutWithToken:wbtoken delegate:self withTag:@"wb_sign_out"];
            [Passport logout];
        }
    }];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wbtoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//将邮箱验证界面设为单例模式
- (VerifyEmailViewController *)vc{
    if(!_vc){
        _vc =[[VerifyEmailViewController alloc]init];
    }
    return _vc;
}

@end
