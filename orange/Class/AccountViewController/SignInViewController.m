//
//  SignInViewController.m
//  orange
//
//  Created by 谢 家欣 on 15/5/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInCell.h"

@interface SignInViewController ()

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UIVisualEffectView * effectview;
@property (strong, nonatomic) UIView * headerView;
@property (strong, nonatomic) UITextField * emailField;
@property (strong, nonatomic) UITextField * passwordField;


@end

@implementation SignInViewController

static NSString * CellIdentifer = @"SignInCell";

- (instancetype)initWithSuccessBlock:(void (^)())block
{
    self = [super init];
    if (self) {
        self.successBlock = block;
        
//        //        AccountViewController *__weak weakself = self;
//        // Custom initialization
//        _loginSuccessCallback=^(TaeSession *session){
//            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@",[session getUser],[session getLoginTime]];
//            NSLog(@"%@", tip);
//            //            [MBProgressHUD showTextOnly:weakself.view message:@"登录成功"];
//        };
//        
//        _loginFailedCallback=^(NSError *error){
//            NSString *tip=[NSString stringWithFormat:@"登录失败:%@",error];
//            NSLog(@"%@", tip);
//            //            [MBProgressHUD showTextOnly:weakself.view message:@"登录失败"];
//        };
    }
    return self;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];

        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44.;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, 202.)];
        
        UIImageView * logo = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"login_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        logo.tintColor = UIColorFromRGB(0xffffff);
        logo.center = CGPointMake(kScreenWidth / 2., 100.);
        [_headerView addSubview:logo];
        
        UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        tip.textColor = UIColorFromRGB(0xffffff);
        tip.font = [UIFont fontWithName:@"FultonsHand" size:16];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"Live Different";
        tip.deFrameTop = logo.deFrameBottom + 10.;
        [_headerView addSubview:tip];
    }
    return _headerView;
}

- (void)loadView
{
    [super loadView];
//    [self.view addSubview:self.tableView];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.effectview.frame = CGRectMake(0, 0, kScreenWidth ,kScreenHeight);
    self.effectview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.effectview.alpha = 0.9;
    
//    self.view = self.tableView;
    [self.view addSubview:self.effectview];
    [self.view addSubview:self.tableView];
//    [self.tableView addSubview:self.effectview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerClass:[SignInCell class] forCellReuseIdentifier:CellIdentifer];
    
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

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignInCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    //    cell
    switch (indexPath.row) {
        case 0:
            cell.type = JXUserSignStyleEmail;
            self.emailField = cell.textField;
            break;
        default:
            cell.type = JXUserSignStylePassword;
//            cell.delegate = self;
            self.passwordField = cell.textField;
            break;
    }
    
    return cell;
}

#pragma mark - appear or disappear view
- (void)fadeIn
{
    [UIView animateWithDuration:0.3 animations:^{
        //        self.blurView.blurRadius = 10;
//        self.accountView.alpha = 1.;
        //        self.blurfilter.rangeReductionFactor = 5.;
        //        self.tableView.frame = CGRectMake(0., 0., WIDTH, HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.3 animations:^{
        //        self.tableView.frame = CGRectMake(0., HEIGHT, WIDTH, HEIGHT);
        //        self.blurView.blurRadius = 0;
//        self.accountView.alpha = 0;
        //        self.blurfilter.rangeReductionFactor = 0.;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showViewWithAnimation:(BOOL)animated
{
    if (animated) {
        [self fadeIn];
    } else {
        //        self.tableView.frame = CGRectMake(0., 0., WIDTH, HEIGHT);
    }
}

- (void)dismissViewWithAnimation:(BOOL)animated
{
    if (animated) {
        [self fadeOut];
    } else {
        //        self.tableView.frame = CGRectMake(0., HEIGHT, WIDTH, HEIGHT);
        //        self
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

@end
