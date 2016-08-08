//
//  EditViewController.m
//  orange
//
//  Created by D_Collin on 16/5/4.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EditViewController.h"
#import "EditViewCell.h"
#import "EditHeaderView.h"
#import "NicknameViewController.h"
#import "AddressPick/AddressPickView.h"
#import "BioViewController.h"


@interface EditViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                    UIActionSheetDelegate,
                                    NicknameViewControllerDelegate , BioViewControllerDelegate>

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) NSMutableArray * dataSource;

@property (strong, nonatomic) EditHeaderView * headerView;

@property (strong, nonatomic) AddressPickView * addressPickView;

@property (weak, nonatomic) UIApplication * app;

@end

NSString *NewSettingTableIdentifier = @"SettingCell";

@implementation EditViewController

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)showAddressPickView
{
    _addressPickView = [AddressPickView shareInstance];
    [self.view addSubview:_addressPickView];
    __weak __typeof(&*self)weakSelf = self;
    _addressPickView.block = ^(NSString *province,NSString *city,NSString *town){
        NSString * locationStr = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
        NSDictionary *dict = @{@"location":locationStr};
        
        [API updateUserProfileWithParameters:dict imageData:nil success:^(GKUser *user) {
            //                    NSLog(@"update update %@", user.location);
            [Passport sharedInstance].user.location = user.location;
            [Passport sharedInstance].user = [Passport sharedInstance].user;
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [weakSelf.tableView reloadData];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"修改失败"];
        }];
    };
}

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

- (EditHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[EditHeaderView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0,0, kScreenWidth, 70.) : CGRectMake(0,0, kScreenWidth - kTabBarWidth, 70.)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAvatar)];
        [self.headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (void)TapAvatar
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
    
//    [actionSheet showInView:kAppDelegate.window];
    [actionSheet showInView:self.view];
}

#pragma mark - avatar

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
//        NSLog(@"%@", imagePickerVC);
//        [self presentViewController:imagePickerVC animated:YES completion:nil];
//        [self.navigationController pushViewController:imagePickerVC animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickerVC animated:YES completion:NULL];
        });
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
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"更新失败"];
    }];
    
    [Picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.tableView.frame = CGRectMake((kScreenWidth - kScreenHeight)/2, 0., kScreenHeight - kTabBarWidth, kScreenHeight);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight || self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
             self.tableView.frame = CGRectMake(128., 0., 684., kScreenHeight);
         else
             self.tableView.frame = CGRectMake(0., 0., 684., kScreenHeight);
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary * profileSection = @{
                                      @"section" : @"profile",
                                      @"row"     : @[@"nickname", @"gender", @"location", @"bio",]
                                      };
    
    
    self.dataSource= [NSMutableArray arrayWithObjects:profileSection, nil];
    
    self.title = NSLocalizedStringFromTable(@"edit your profile", kLocalizedFile, nil);
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.headerView.avatarURL = [Passport sharedInstance].user.avatarURL;
    
    [self.tableView registerClass:[EditViewCell class] forCellReuseIdentifier:NewSettingTableIdentifier];
    
    
}

#pragma mark ------- 懒加载 ------------------
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorFromRGB(0xf8f8f8);
        _tableView.backgroundColor = UIColorFromRGB(0xfafafa);
    }
    return _tableView;
}


#pragma mark -------- tableView Delegate and dataSource ------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataSource[section][@"row"];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NewSettingTableIdentifier forIndexPath:indexPath];
    
    cell.string = [[[self.dataSource objectAtIndex:indexPath.section] objectForKey:@"row"] objectAtIndex:indexPath.row];
    
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
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                NicknameViewController * vc = [[NicknameViewController alloc]init];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
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
                [self showAddressPickView];
            }
                break;
            case 3:
            {
                BioViewController * vc = [[BioViewController alloc]init];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            default:
                break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
