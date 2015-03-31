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
#import "GKAPI.h"
#import "LoginView.h"

#import "GKWebVC.h"
#import "FeedBackViewController.h"


static NSString *SettingTableIdentifier = @"SettingCell";


@interface SettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, SettingsFooterViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISwitch * switch_notification;
@property (nonatomic, strong) UISwitch * switch_assistant;
@property (nonatomic, strong) SettingsFooterView * footerView;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedStringFromTable(@"settings", kLocalizedFile, nil);
        self.dataArray = [NSMutableArray array];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"settings", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_setting"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        self.tabBarItem = item;
    }
    return self;
}

- (SettingsFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[SettingsFooterView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, 100.)];
        _footerView.delegate = self;
        _footerView.is_login = k_isLogin;
    }
    return _footerView;
}

- (void)loadView
{
    [super loadView];
    
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight -kNavigationBarHeight -kStatusBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGB(0xebebeb);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xfafafa);
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (k_isLogin) {
        NSDictionary * linkSection = @{@"section"   :   @"link settings",
                                   @"row"       :   @[
                                           @"weibo",
                                           @"taobao",
//                                           @"wechat",
                                           ]};
    
        [self.dataArray addObject:linkSection];
    }
    
    NSDictionary *recommandSection = @{@"section" : @"recommandtion",
                                    @"row"     : @[
                                            @"share application to wechat",
                                            @"share application to weibo",
                                            @"App Store 评分",
                                            ]};
    [self.dataArray addObject:recommandSection];
    
    // 其他
    NSDictionary *otherSection = @{@"section" : @"other",
                                   @"row"     : @[
                                           @"about",
//                                           @"agreement",
                                           @"clear image cache",
                                           @"feedback",
                                           @"version",
                                           ]};
    [self.dataArray addObject:otherSection];
    
    
    [self.tableView registerClass:[SettingsViewCell class] forCellReuseIdentifier:SettingTableIdentifier];
    self.tableView.tableFooterView = self.footerView;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"SettingView"];
    [MobClick beginLogPageView:@"SettingView"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"SettingView"];
    [MobClick endLogPageView:@"SettingView"];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0;
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
//    NSString *SettingTableIdentifier = [NSString stringWithFormat:@"Setting%ld%ld",indexPath.section,indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingTableIdentifier];
//    }
//
    SettingsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier forIndexPath:indexPath];
    
    cell.text = [[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"row"]objectAtIndex:indexPath.row];
//    cell.textLabel.text = [[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"row"]objectAtIndex:indexPath.row];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
//    cell.textLabel.textColor = UIColorFromRGB(0X666666);
//    cell.textLabel.highlightedTextColor = UIColorFromRGB(0X666666);
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    
//    
//    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"推荐"]) {
//
//    }
//    
//    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"其他"]) {
//        if (indexPath.row == 4) {
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            UIView *accessoryV = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, cell.frame.size.height)];
//            [accessoryV setBackgroundColor:[UIColor clearColor]];
//            accessoryV.clipsToBounds = NO;
//            
//            UILabel *currentVersionL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.00f, cell.frame.size.height)];
//            [currentVersionL setBackgroundColor:[UIColor clearColor]];
//            [currentVersionL setTextAlignment:NSTextAlignmentRight];
//            currentVersionL.text = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//            currentVersionL.font = [UIFont fontWithName:@"Helvetica" size:15];;
//            currentVersionL.textColor = UIColorFromRGB(0x9d9e9f);
//            [accessoryV addSubview:currentVersionL];
//            cell.accessoryView = accessoryV;
//        }
//    }
    
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
    
    if ([section isEqualToString:@"link settings"]) {
        switch (indexPath.row) {
            case 0:
            {
                if ([Passport sharedInstance].user.sinaScreenName) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解除绑定" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    alertView.alertViewStyle = UIAlertViewStyleDefault;
                    alertView.tag =40001;
                    [alertView show];
                    break;
                }
                
                [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kGK_WeiboAPPKey andAppSecret:kGK_WeiboSecret andRedirectURI:kGK_WeiboRedirectURL];
                [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
                    NSLog(@"%@", object);
                    if (!error) {
                        [GKAPI bindWeiboWithUserId:[Passport sharedInstance].user.userId sinaUserId:object[@"id"] sinaScreenname:object[@"username"] accessToken:object[@"access_token"] success:^(GKUser *user) {
                        
                        } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
                            [SVProgressHUD showErrorWithStatus:message];
                        }];
                    }
                } toPlatform:AVOSCloudSNSSinaWeibo];
                
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
    
    if ([section isEqualToString:@"recommandtion"])
    {
        if (indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享给好友", @"分享到朋友圈", nil];
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
            case 0:
            {
                [self.navigationController pushViewController:[GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:@"http://www.guoku.com/about/"]] animated:YES];
            }
                break;
            case 1:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除图片缓存？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认清除", nil];
                alertView.alertViewStyle = UIAlertViewStyleDefault;
                alertView.tag =20008;
                [alertView show];
            }
                break;
            
            case 2:
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
    
    if(alertView.tag ==20008)
    {
        if(buttonIndex == 1)
        {
            [self clearPicCache];
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
    ext.Url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];;
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

-(void)weiboShare
{

    [AVOSCloudSNS shareText:@"果库 - 精英消费指南。帮助你发现互联网上最有趣、最人气、最实用的好商品，恪守选品标准和美学格调，开拓精英视野与生活想象。" andLink:@"http://www.guoku.com" andImage:[UIImage imageNamed:@"weibo_share.jpg"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
                
    } andProgress:^(float percent) {
        if (percent == 1) {
            [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
        }
    }];

}
#pragma mark - AVATAR

- (void)photoButtonAction{
    
    // 设置头像
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
    
    [actionSheet showInView:kAppDelegate.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 修改头像
    switch (buttonIndex) {
        case 0:
        {
            // 拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self showImagePickerToTakePhoto];
            }
            break;
        }
            
        case 1:
        {
            // 照片库
            [self showImagePickerFromPhotoLibrary];
            break;
        }
    }
}
- (void)showImagePickerFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.delegate = self;
        [self presentViewController:imagePickerVC animated:YES completion:NULL];
    }
}

- (void)showImagePickerToTakePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.delegate = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentViewController:imagePickerVC animated:YES completion:NULL];
        });

    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)Picker {
    [Picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)Picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = (UIImage *)[info valueForKey:UIImagePickerControllerEditedImage];
    [GKAPI updateUserProfileWithNickname:nil email:nil password:nil imageData:[image imageData] success:^(GKUser *user) {
        [SVProgressHUD showImage:nil status:@"更新成功"];
            } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"更新失败"];
    }];
    
    [Picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}



//- (void)configFooter
//{
//    
//    UIView * view  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
//    
//    if (k_isLogin) {
//        UIButton * logout = [[UIButton alloc]initWithFrame:CGRectMake(20,20 , kScreenWidth-40, 44)];
//        logout.backgroundColor = UIColorFromRGB(0xcd1841);
//        logout.layer.cornerRadius = 5;
//        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
//        [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:logout];
//    }
//    else
//    {
//        UIButton * login = [[UIButton alloc]initWithFrame:CGRectMake(20,20 , kScreenWidth-40, 44)];
//        login.backgroundColor = UIColorFromRGB(0x427ec0);
//        login.layer.cornerRadius = 5;
//        [login setTitle:@"登录" forState:UIControlStateNormal];
//        [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:login];
//    }
//    
//    self.tableView.tableFooterView = view;
//}

#pragma mark - Setting Footer View Delegate

- (void)TapLoginBtnAction
{
    LoginView * view = [[LoginView alloc]init];
    [view show];
}

- (void)TapLogoutBtnAction
{
    [AVUser logOut];
    if (![AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo]) {
        [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
    }
    [Passport logout];
    [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"退出成功"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
}

//- (void)logout
//{
//    [AVUser logOut];
//    if (![AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo]) {
//        [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
//    }
//    [Passport logout];
//    [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"退出成功"]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
//}

//- (void)login
//{
//    LoginView * view = [[LoginView alloc]init];
//    [view show];
//}


@end
