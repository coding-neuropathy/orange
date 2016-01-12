//
//  SettingViewController.m
//  emojiii
//
//  Created by huiter on 14/12/10.
//  Copyright (c) 2014年 sensoro. All rights reserved.
//

#import "EditViewController.h"
#import "NSString+Helper.h"
//#import "WXApi.h"
#import "API.h"
//#import "LoginView.h"
//#import "GKWebVC.h"
#import "EditHeaderView.h"
#import "EditViewCell.h"
#import "EmailEditViewController.h"
#import "PasswordEditViewController.h"

NSString *SettingTableIdentifier = @"SettingCell";

@interface EditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, EditHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) UISwitch * switch_notification;
//@property (nonatomic, strong) UISwitch * switch_assistant;
@property (nonatomic, strong) UIPickerView * genderPickerView;
@property (nonatomic, strong) EditHeaderView * headerView;

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =NSLocalizedStringFromTable(@"edit your profile", kLocalizedFile, nil);
        self.dataArray = [NSMutableArray array];
        
//        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_icon_setting"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
//        self.tabBarItem = item;
        [self.navigationItem.backBarButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-100,-100) forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

- (EditHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[EditHeaderView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 162)];
        _headerView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _headerView.delegate = self;
    }
    return _headerView;
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
//    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xfafafa);
    
    self.view = self.tableView;
    //    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary * profileSection = @{
                                      @"section" : @"profile",
                                      @"row"     : @[@"nickname", @"gender", @"bio", @"location",]
                                      };
    
//    NSDictionary *accountSection = @{@"section" : @"帐号",
//                                      @"row"     : @[@"email", @"password"]};

//    NSLog(@"email %@", [Passport sharedInstance].user.email);
//    if (k_isLogin) {
//    [self.dataArray addObject:accountSection];
//    }
    
//    self.dataArray = [NSMutableArray arrayWithObjects:profileSection, accountSection, nil];
    self.dataArray= [NSMutableArray arrayWithObjects:profileSection, nil];
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.avatarURL = [Passport sharedInstance].user.avatarURL;
    
    [self.tableView registerClass:[EditViewCell class] forCellReuseIdentifier:SettingTableIdentifier];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [AVAnalytics beginLogPageView:@"EditView"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"EditView"];
}

#pragma mark - UITableViewDataSource

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 16.0;
//}

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
    
    EditViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier forIndexPath:indexPath];
//    cell.dict = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"row"] objectAtIndex:indexPath.row];
//    NSLog(@"string %@", [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"row"] objectAtIndex:indexPath.row]);
    cell.string = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"row"] objectAtIndex:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertView.tag = 20001;
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.text = [Passport sharedInstance].user.nickname;
                [alertView show];
            }
                break;
            case 1:
            {
                UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", @"其他", nil];
                actionSheet.tag = 20000;
                [actionSheet showInView:self.view];
            }
                break;
            case 2:
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"修改简介" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertView.tag = 20002;
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.text = [Passport sharedInstance].user.bio;
                [alertView show];
            }
                break;
            case 3:
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"修改所在地" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertView.tag = 20003;
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.text = [Passport sharedInstance].user.location;
                [alertView show];
            }
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                /*
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"修改邮箱" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertView.tag = 30000;
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.text = [Passport sharedInstance].user.email;
                [alertView show];
                 */
                EmailEditViewController * VC = [[EmailEditViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
                break;
            case 1:
            {
                /*
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertView.tag = 30001;
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.secureTextEntry = YES;
//                textField.text = [Passport sharedInstance].user.email;
                [alertView show];
                 */
                PasswordEditViewController * VC = [[PasswordEditViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 20001)
    {
        if(buttonIndex == 1)
        {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length==0 || tf.text.length <= 2) {
                [SVProgressHUD showImage:nil status:@"昵称不能为空且必须大于两个字符！"];
            }
            else
            {
                NSDictionary * dict = @{@"nickname": tf.text};
                [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
                    [Passport sharedInstance].user.nickname = user.nickname;
//                    [Passport sharedInstance].user = [Passport sharedInstance].user;
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self.tableView reloadData];
                } failure:^(NSInteger stateCode) {
                    [SVProgressHUD showErrorWithStatus:@"修改失败"];
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
                [SVProgressHUD showImage:nil status:@"不能为空"];
            }
            else
            {
                NSDictionary * dict = @{@"bio": tf.text};
                [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
                    [Passport sharedInstance].user.bio = user.bio;
                    [Passport sharedInstance].user = [Passport sharedInstance].user;
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self.tableView reloadData];
                    
                } failure:^(NSInteger stateCode) {
                    [SVProgressHUD showErrorWithStatus:@"修改失败"];
                }];
                
            }
        }
    }

    if(alertView.tag ==20003)
    {
        if(buttonIndex == 1)
        {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length == 0) {
                [SVProgressHUD showImage:nil status:@"不能为空"];
            }
            else
            {
                NSDictionary *dict = @{@"location":tf.text};
//                NSLog(@"location %@", tf.text);
                [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
//                    NSLog(@"update update %@", user.location);
                    [Passport sharedInstance].user.location = user.location;
                    [Passport sharedInstance].user = [Passport sharedInstance].user;
//                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self.tableView reloadData];
                } failure:^(NSInteger stateCode) {
                    [SVProgressHUD showImage:nil status:@"修改失败"];
                }];
            }
        }
    }
    
    if (alertView.tag == 30000) {
        if (buttonIndex == 1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if ([tf.text validateEmail]) {
//                NSDictionary *dict = @{@"email": tf.text};
//                [API updateaccountWithParameters:dict success:^(GKUser *user) {
//                    [Passport sharedInstance].user.email = user.email;
//                    [Passport sharedInstance].user = [Passport sharedInstance].user;
//                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
//                    [self.tableView reloadData];
//                } failure:^(NSInteger stateCode) {
//                    [SVProgressHUD showImage:nil status:@"修改失败"];
//                }];
            } else {
                [SVProgressHUD showImage:nil status:@"邮箱格式错误"];
            }
        }
    
    }
    
    if (alertView.tag == 30001) {
        if(buttonIndex == 1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length < 6) {
                [SVProgressHUD showImage:nil status:@"密码不能小于6位"];
            } else {
//                NSDictionary *dict = @{@"password":tf.text};
//                [API updateaccountWithParameters:dict success:^(GKUser *user) {
//                    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"\U0001F603 修改成功"]];
//                } failure:^(NSInteger stateCode) {
//                    [SVProgressHUD showImage:nil status:@"修改失败"];
//                }];
            }
        }
    }
}

#pragma mark - Header View Delegate

- (void)TapPhotoBtn:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
    
    [actionSheet showInView:kAppDelegate.window];
}

#pragma mark - avatar

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 修改头像
//    NSLog(@"index %lu", actionSheet.tag);
    
    if (actionSheet.tag == 20000) {
        NSString * gender = nil;
        switch (buttonIndex) {
            case 0:
                gender = @"M";
                break;
            case 1:
                gender = @"F";
                break;
                
            case 2:
                gender = @"O";
                break;
            default:
                return;
                break;
        }
//        NSLog(@"index index %lu", buttonIndex);
        NSDictionary * dict = @{@"gender": gender};
        [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
            [Passport sharedInstance].user.gender = user.gender;
            [Passport sharedInstance].user = [Passport sharedInstance].user;
            NSLog(@"geneder %@", user.gender);

            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.tableView reloadData];
        } failure:^(NSInteger stateCode) {

            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    
    } else {
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
    [API updateUserProfileWithParameters:nil imageData:[image imageData] success:^(GKUser *user) {
        self.headerView.avatarURL = user.avatarURL;
        [SVProgressHUD showImage:nil status:@"更新成功"];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"更新失败"];
    }];
    
    [Picker dismissViewControllerAnimated:YES completion:^{
//        [self.tableView reloadData];
    }];
}

@end
