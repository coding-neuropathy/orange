//
//  SettingViewController.m
//  emojiii
//
//  Created by huiter on 14/12/10.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "SettingViewController.h"
#import "WXApi.h"
#import "GKAPI.h"
#import "LoginView.h"
#import "GKWebVC.h"

@interface SettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISwitch * switch_notification;
@property (nonatomic, strong) UISwitch * switch_assistant;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        self.dataArray = [NSMutableArray array];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_icon_setting"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSDictionary *locationSection = @{@"section" : @"账号",
                                      @"row"     : @[
                                              @"修改头像",
                                              @"修改昵称",
                                              @"修改邮箱",
                                              @"修改密码"
                                              ]};
    
    if (k_isLogin) {
      //  [self.dataArray addObject:locationSection];
    }

    
    NSDictionary *recommandSection = @{@"section" : @"推荐",
                                    @"row"     : @[
                                            @"微信分享",
                                            @"App Store 评分",
                                            ]};
    [self.dataArray addObject:recommandSection];
    
    // 其他
    NSDictionary *otherSection = @{@"section" : @"其他",
                                   @"row"     : @[
                                           @"关于我们",
                                           @"清空图片缓存",
                                           @"意见反馈",
                                           @"版本",
                                           ]};
    [self.dataArray addObject:otherSection];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight -kNavigationBarHeight -kStatusBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGB(0xebebeb);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xfafafa);
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];

    
    [self configFooter];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"SettingView"];
    /*
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xffffff)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageWithColor:UIColorFromRGB(0x2b2b2b) andSize:CGSizeMake(2, 2)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
     */
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"SettingView"];
}

#pragma mark - UITableViewDataSource

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* bgView = [[UIView alloc] init];
//    bgView.backgroundColor = [UIColor clearColor];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 32)];
//    titleLabel.textColor=UIColorFromRGB(0x9d9e9f);
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
//    titleLabel.text = [[self.dataArray objectAtIndex:section]objectForKey:@"section"];
//    [bgView addSubview:titleLabel];
//    return bgView;
//}

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
    NSString *SettingTableIdentifier = [NSString stringWithFormat:@"Setting%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingTableIdentifier];
    }
    
    cell.textLabel.text = [[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"row"]objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    cell.textLabel.textColor = UIColorFromRGB(0X666666);
    cell.textLabel.highlightedTextColor = UIColorFromRGB(0X666666);
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"账号"]) {
        
        switch (indexPath.row) {

            case 0:
                {
                    cell.textLabel.textAlignment = NSTextAlignmentRight;
                    
                    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1001];
                    
                    if (!imageView) {
                        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 7.f,30.f, 30.f)];
                        imageView.tag = 1001;
                        imageView.layer.cornerRadius = 15;
                        imageView.layer.masksToBounds = YES;
                        [cell.contentView addSubview:imageView];
                    }
                    [imageView sd_setImageWithURL:[Passport sharedInstance].user.avatarURL placeholderImage:nil options:SDWebImageRetryFailed ];
                    break;
                }
                
            case 1:
                {
                    cell.textLabel.textAlignment = NSTextAlignmentRight;
                    
                    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1002];
                    
                    if (!label) {
                        label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, 200.f, 44.f)];
                        label.tag = 1002;
                        label.textAlignment = NSTextAlignmentLeft;
                        label.backgroundColor = [UIColor clearColor];
                        label.font = [UIFont systemFontOfSize:15];
                        label.textColor = UIColorFromRGB(0X666666);
                        label.highlightedTextColor = UIColorFromRGB(0X666666);
                        [cell.contentView addSubview:label];
                    }
                    label.text =[Passport sharedInstance].user.nickname;
                    break;
                }
            case 2:
            {
                cell.textLabel.textAlignment = NSTextAlignmentRight;
                
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:1003];
                
                if (!label) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, 200.f, 44.f)];
                    label.tag = 1003;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = UIColorFromRGB(0X666666);
                    label.highlightedTextColor = UIColorFromRGB(0X666666);
                    [cell.contentView addSubview:label];
                }
                label.text = [Passport sharedInstance].user.email;
                
                break;
            }
            case 3:
            {
                cell.textLabel.textAlignment = NSTextAlignmentRight;
                
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:1004];
                
                if (!label) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, 200.f, 44.f)];
                    label.tag = 1004;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = UIColorFromRGB(0X666666);
                    label.highlightedTextColor = UIColorFromRGB(0X666666);
                    [cell.contentView addSubview:label];
                }
                label.text = @"密码";
                break;
            }
            case 4:{
            
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(75, 1, 44, 44)];
                button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
                [button setTitle:[NSString fontAwesomeIconStringForEnum:FASignOut] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor clearColor];
                //[cell addSubview:button];
            }
        }
    }
    
    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"推荐"]) {
        if (indexPath.row == 2) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FAWeibo] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            //[cell addSubview:button];
        }
        if (indexPath.row == 0) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FAwechat] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            //[cell addSubview:button];
        }
        if (indexPath.row == 1) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FAStar] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            //[cell addSubview:button];
        }
    }
    
    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"其他"]) {
        if (indexPath.row == 3) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *accessoryV = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, cell.frame.size.height)];
            [accessoryV setBackgroundColor:[UIColor clearColor]];
            accessoryV.clipsToBounds = NO;
            
            UILabel *currentVersionL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.00f, cell.frame.size.height)];
            [currentVersionL setBackgroundColor:[UIColor clearColor]];
            [currentVersionL setTextAlignment:NSTextAlignmentRight];
            currentVersionL.text = [NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            currentVersionL.font = [UIFont fontWithName:@"Helvetica" size:15];;
            currentVersionL.textColor = UIColorFromRGB(0x9d9e9f);
            [accessoryV addSubview:currentVersionL];
            cell.accessoryView = accessoryV;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"账户"]) {
        if(indexPath.row == 0)
        {
            [self photoButtonAction];
        }
        if(indexPath.row == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag =20001;
            [alertView show];
        }
        if(indexPath.row == 2)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改邮箱" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag =20002;
            [alertView show];
        }
        if(indexPath.row == 3)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alertView.tag =20003;
            [alertView show];
        }
        if(indexPath.row == 4)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认退出登录？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.alertViewStyle = UIAlertViewStyleDefault;
            alertView.tag =20007;
            [alertView show];
        }
    }
    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"推荐"])
    {
        if (indexPath.row == 2) {
            [self weiboShare];
        }
        if (indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享给好友", @"分享到朋友圈", nil];
            alertView.alertViewStyle = UIAlertViewStyleDefault;
            alertView.tag =20005;
            [alertView show];
        }
        if (indexPath.row == 1) {
            NSString* url = [NSString stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8", kGK_AppID_iPhone];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    }
    if ([[[self.dataArray objectAtIndex:indexPath.section]objectForKey:@"section"] isEqualToString:@"其他"]) {
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
                alertView.tag =20006;
                [alertView show];
            }
                break;
            case 2:
            {
                AVUserFeedbackAgent *agent = [AVUserFeedbackAgent sharedInstance];
                [agent showConversations:self title:@"意见反馈" contact:@""];
            }
                break;
            default:
                break;
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==20001)
    {
        if(buttonIndex == 1)
        {
        UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length==0) {
                [SVProgressHUD showImage:nil status:@"昵称不能为空"];
            }
            else
            {
                [GKAPI updateUserProfileWithNickname:nil email:nil password:nil imageData:nil success:^(GKUser *user) {
                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                } failure:^(NSInteger stateCode) {
                    [SVProgressHUD showImage:nil status:@"修改失败"];
                }];
            }
        }
    }
    
    if(alertView.tag ==20002)
    {
        if(buttonIndex == 1)
        {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length==0) {
                [SVProgressHUD showImage:nil status:@"邮箱不能为空"];
            }
            else
            {
                [GKAPI updateUserProfileWithNickname:nil email:nil password:nil imageData:nil success:^(GKUser *user) {
                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                } failure:^(NSInteger stateCode) {
                    [SVProgressHUD showImage:nil status:@"修改失败"];
                }];
                
            }
        }
    }

    if(alertView.tag ==20003)
    {
        if(buttonIndex == 1)
        {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length<6) {
                [SVProgressHUD showImage:nil status:@"密码不能少于6位"];
            }
            else
            {
                [GKAPI updateUserProfileWithNickname:nil email:nil password:nil imageData:nil success:^(GKUser *user) {
                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                } failure:^(NSInteger stateCode) {
                    [SVProgressHUD showImage:nil status:@"修改失败"];
                }];
                
            }
        }
    }
    
    if(alertView.tag ==20005)
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
    
    if(alertView.tag ==20006)
    {
        if(buttonIndex == 1)
        {
            [self clearPicCache];
        }
    }
    if(alertView.tag == 20007)
    {
        if(buttonIndex == 1)
        {
            [AVUser logOut];
            if (![AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo]) {
                [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
            }
           [Passport logout];
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"退出成功"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
            
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
    [SVProgressHUD showSuccessWithStatus:@"已清除"];
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
    if([AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo ])
    {
        [AVOSCloudSNS refreshToken:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            [AVOSCloudSNS shareText:@"果库 - 精英消费指南" andLink:@"http://www.guoku.com" andImage:[UIImage imageNamed:@"weiboshare.jpg"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
                
            } andProgress:^(float percent) {
                if (percent == 1) {
                    [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
                }
            }];
        }];
    }
    else
    {
        [AVOSCloudSNS shareText:@"果库 - 精英消费指南" andLink:@"http://www.guoku.com" andImage:[UIImage imageNamed:@"logo.png"] toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            
        } andProgress:^(float percent) {
            if (percent == 1) {
                [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
            }
        }];
    }
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



- (void)configFooter
{
    
    UIView * view  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    if (k_isLogin) {
        UIButton * logout = [[UIButton alloc]initWithFrame:CGRectMake(20,20 , kScreenWidth-40, 44)];
        logout.backgroundColor = UIColorFromRGB(0xcd1841);
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:logout];
    }
    else
    {
        UIButton * login = [[UIButton alloc]initWithFrame:CGRectMake(20,20 , kScreenWidth-40, 44)];
        login.backgroundColor = UIColorFromRGB(0x427ec0);
        [login setTitle:@"登录" forState:UIControlStateNormal];
        [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:login];
    }
    
    self.tableView.tableFooterView = view;
}

- (void)logout
{
    [AVUser logOut];
    if (![AVOSCloudSNS doesUserExpireOfPlatform:AVOSCloudSNSSinaWeibo]) {
        [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
    }
    [Passport logout];
    [SVProgressHUD showImage:nil status:[NSString stringWithFormat: @"%@%@",smile,@"退出成功"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
}

- (void)login
{
    LoginView * view = [[LoginView alloc]init];
    [view show];
}

@end
