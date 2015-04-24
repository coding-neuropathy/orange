//
//  EntityViewController.m
//  orange
//
//  Created by huiter on 15/1/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityViewController.h"
#import "GKAPI.h"
#import "NoteCell.h"
#import "EntityThreeGridCell.h"
#import "UserViewController.h"
#import "NotePostViewController.h"
#import "CategoryViewController.h"
#import "WXApi.h"
#import "GKWebVC.h"
#import "ReportViewController.h"
#import "LoginView.h"
#import "IBActionSheet.h"
#import "EntityHeaderView.h"


static NSString *NoteCellIdentifier = @"NoteCell";
static NSString *EntityCellIdentifier = @"EntityCell";

@interface EntityViewController ()<IBActionSheetDelegate, EntityHeaderViewDelegate>
@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *noteButton;

@property (nonatomic, strong) EntityHeaderView * header;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIView *likeUserView;

@property (nonatomic, strong) NSMutableArray *dataArrayForlikeUser;
@property (nonatomic, strong) NSMutableArray *dataArrayForNote;
@property (nonatomic, strong) NSMutableArray *dataArrayForRecommend;

@property(nonatomic, strong) id<ALBBItemService> itemService;

//@property (nonatomic) OneSDKItemType itemType;

@end

@implementation EntityViewController
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

- (instancetype)init
{
    if (self = [super init]) {
//        self.itemType = OneSDKItemType_TAOBAO1;
        self.itemService=[[TaeSDK sharedInstance] getService:@protocol(ALBBItemService)];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    
    NSMutableArray * array = [NSMutableArray array];
    
    
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
        button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [button setTitle:[NSString fontAwesomeIconStringForEnum:FAEllipsisH] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
        button.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
        [array addObject:item];
    }
    
//    {
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
//        button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
//        [button setTitle:[NSString fontAwesomeIconStringForEnum:FAPencilSquareO] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(noteButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
//        button.backgroundColor = [UIColor clearColor];
//        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
//        //[array addObject:item];
//    }
    
    
    
    self.navigationItem.rightBarButtonItems = array;
    
    
    self.title = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
//    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -kNavigationBarHeight - kStatusBarHeight);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;

    [self.tableView registerClass:[NoteCell class] forCellReuseIdentifier:NoteCellIdentifier];
    [self.tableView registerClass:[EntityThreeGridCell class] forCellReuseIdentifier:EntityCellIdentifier];
    [self.view addSubview:self.tableView];
    
    UIView * header =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    header.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.tableHeaderView = header;
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 240, 240)];
    
    [self configFooter];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"EntityView"];
    [MobClick beginLogPageView:@"EntityView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"EntityView"];
    [MobClick endLogPageView:@"EntityView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setEntity:(GKEntity *)entity
{
    if (self.entity) {
        [self removeObserver];
    }
    _entity = entity;
    [self addObserver];
}

- (EntityHeaderView *)header
{
    if (!_header) {
        _header = [[EntityHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth + 75)];
        _header.delegate = self;
        _header.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _header;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.dataArrayForlikeUser) {
        [self refresh];
    }
}

- (void)refresh
{
    [GKAPI getEntityDetailWithEntityId:self.entity.entityId success:^(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray) {
        [self.image sd_setImageWithURL:self.entity.imageURL_640x640];
        self.entity = entity;
        self.header.entity = entity;
        self.dataArrayForlikeUser = [NSMutableArray arrayWithArray:likeUserArray];
        self.dataArrayForNote = [NSMutableArray arrayWithArray:noteArray];
        for (GKNote *note in self.dataArrayForNote) {
            if (note.creator.userId == [Passport sharedInstance].user.userId) {
                self.note = note;
                break;
            }
        }
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        
    }];
    
    [GKAPI getRandomEntityListByCategoryId:self.entity.categoryId
                                  entityId:self.entity.entityId
                                     count:9 success:^(NSArray *entityArray) {
        self.dataArrayForRecommend = [NSMutableArray arrayWithArray:entityArray];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.dataArrayForNote.count;
    }
    if (section == 4) {
        return ceil(self.dataArrayForRecommend.count / (CGFloat)3);
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        
//        static NSString *CellIdentifier = @"Cell";
        NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellIdentifier forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[NoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
        cell.note = self.dataArrayForNote[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 4) {
        EntityThreeGridCell *cell = [tableView dequeueReusableCellWithIdentifier:EntityCellIdentifier forIndexPath:indexPath];
        NSArray *entityArray = self.dataArrayForRecommend;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSUInteger offset = indexPath.row * 3;
        for (NSUInteger i = 0; i < 3 && offset < entityArray.count; i++) {
            [array addObject:entityArray[offset++]];
        }
        cell.entityArray = array;
        cell.backgroundColor = UIColorFromRGB(0xfafafa);
        return cell;
    }
    else
    {
        return [UITableViewCell new];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
            return [NoteCell height:self.dataArrayForNote[indexPath.row]];
    }
    if (indexPath.section == 4) {
        return [EntityThreeGridCell height];
    }
    if (indexPath.section == 1) {
        return 0;
    }
    return 0;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return kScreenWidth+105;
    }
    else if (section == 1) {
        if (self.dataArrayForlikeUser.count == 0) {
            return 0.01;
        }
        else
        {
            return 50;
        }
    }
    else if (section == 2) {
        return 50;
    }
    else if (section == 3) {
        return 50;
    }
    else if (section == 4) {
        return 50;
    }
    else
    {
        return 0.01;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        self.header.entity = self.entity;
        return self.header;
    }
    else if (section == 1) {
        
        if (self.dataArrayForlikeUser.count == 0) {
            return nil;
        }
        
        if(!self.likeUserView)
        {
            self.likeUserView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            self.likeUserView.backgroundColor = UIColorFromRGB(0xffffff);
        }
        
        for (UIView * view in self.likeUserView.subviews) {
            [view removeFromSuperview];
        }
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            [self.likeUserView addSubview:H];
        }
        
        {
            UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,49, kScreenWidth, 0.5)];
            H.backgroundColor = UIColorFromRGB(0xebebeb);
            [self.likeUserView addSubview:H];
        }
        
        
        int i = 0;
        
        for (GKUser * user in self.dataArrayForlikeUser) {
            UIButton * avatar;
            if (kScreenWidth == 320.) {
                if (32 + i*42 > kScreenWidth) {
                    break;
                }
                avatar = [[UIButton alloc] initWithFrame:CGRectMake(16 + 42.f * i , 6.f, 36.f, 36.f)];
            } else if (kScreenWidth == 375.) {
                if (32 + i*44 > kScreenWidth) {
                    break;
                }
                avatar = [[UIButton alloc] initWithFrame:CGRectMake(16 + 44.f * i , 6.f, 36.f, 36.f)];
            } else {
                if (32 + i*47 > kScreenWidth) {
                    break;
                }
                avatar = [[UIButton alloc] initWithFrame:CGRectMake(16 + 47.f * i , 6.f, 36.f, 36.f)];
            }

            avatar.layer.cornerRadius = avatar.frame.size.width / 2.;
            avatar.layer.masksToBounds = YES;
            [avatar sd_setImageWithURL:user.avatarURL forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf1f1f1) andSize:CGSizeMake(72, 72)]];
            avatar.tag = i;
            [avatar addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.likeUserView addSubview:avatar];
            i++;
        }
        
        return self.likeUserView;
    }
    
    else if (section == 2) {
        if(!self.categoryButton)
        {
            self.categoryButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FAAngleRight] forState:UIControlStateNormal];
            button.deFrameRight = kScreenWidth -17;
            button.backgroundColor = [UIColor clearColor];
            [self.categoryButton addSubview:button];
            
            [self.categoryButton addTarget:self action:@selector(categoryButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }
    
        GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
        [self.categoryButton setTitle:[NSString stringWithFormat:@"%@「%@」",
                                       NSLocalizedStringFromTable(@"from", kLocalizedFile, nil),
                                       [category.categoryName componentsSeparatedByString:@"-"][0]]
                             forState:UIControlStateNormal];
        [self.categoryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.categoryButton setBackgroundColor:UIColorFromRGB(0xfafafa)];
        self.categoryButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.categoryButton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        
        return self.categoryButton;
    }
    else if (section == 3) {
        if(!self.noteButton)
        {
            self.noteButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            self.noteButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
            [self.noteButton addTarget:self action:@selector(noteButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            {
                UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,49, kScreenWidth, 0.5)];
                H.backgroundColor = UIColorFromRGB(0xebebeb);
                [self.noteButton addSubview:H];
            }
        }
        if (self.note) {
            [self.noteButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAPencilSquareO], NSLocalizedStringFromTable(@"update note", kLocalizedFile, nil)] forState:UIControlStateNormal];
        }
        else
        {
            [self.noteButton setTitle:[NSString stringWithFormat:@"%@ 写点评",[NSString fontAwesomeIconStringForEnum:FAPencilSquareO]] forState:UIControlStateNormal];
        }
        [self.noteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.noteButton setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.noteButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
        return self.noteButton;
    }
    else if (section == 4) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 20.f, CGRectGetWidth(tableView.frame)-20, 20.f)];
//        label.text = @"相似推荐";
        label.text = NSLocalizedStringFromTable(@"recommendation", kLocalizedFile, nil);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = UIColorFromRGB(0x414243);
        label.font = [UIFont systemFontOfSize:14];
        [label sizeToFit];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50)];
        view.backgroundColor = UIColorFromRGB(0xfafafa);
        [view addSubview:label];
        
        return view;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView  editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath;
{
    if (indexPath.section == 2) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        GKNote *note = self.dataArrayForNote[indexPath.row];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            ReportViewController * VC = [[ReportViewController alloc]init];
            VC.note = note;
            [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
            [self.navigationController pushViewController:VC animated:YES];

        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"举报";
}

#pragma mark - KVO

- (void)addObserver
{

}

- (void)removeObserver
{

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark
#pragma mark - Entity Header View Delegate
- (void)TapLikeBtnAction:(id)sender
{
    self.likeButton = (UIButton *)sender;
    [self likeButtonAction];
}

- (void)TapBuyBtnAction:(id)sender
{
    self.buyButton = (UIButton *)sender;
    [self buyButtonAction];
}

#pragma mark - Action
- (void)likeButtonAction
{
    
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    
    [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];
    [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
    
    [GKAPI likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
        if (liked == self.likeButton.selected) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        }
        self.likeButton.selected = liked;
        self.entity.liked = liked;
        if (liked) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
            self.entity.likeCount = self.entity.likeCount+1;
        } else {
            self.entity.likeCount = self.entity.likeCount-1;
            [SVProgressHUD dismiss];
        }
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@ %ld", NSLocalizedStringFromTable(@"like", kLocalizedFile, nil), self.entity.likeCount] forState:UIControlStateNormal];
        self.header.entity = self.entity;
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"喜爱失败"];
        
    }];
}

- (void)noteButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    NotePostViewController * VC = [[NotePostViewController alloc]init];
    VC.entity = self.entity;
    VC.note = self.note;
    VC.successBlock = ^(GKNote *note) {
        if (![self.dataArrayForNote containsObject:note]) {
            [self.dataArrayForNote insertObject:note atIndex:self.dataArrayForNote.count];
        }
        
        //[self.noteButton setTitle:@"修改" forState:UIControlStateNormal];
        self.note = note;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)shareButtonAction
{
    if (!self.note) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil)
                                                    destructiveButtonTitle:nil
                                                    otherButtonTitles:@"分享到微信", @"分享到朋友圈", @"分享到新浪微博", @"举报商品", nil];
        actionSheet.backgroundColor = UIColorFromRGB(0xffffff);
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil)
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:@"分享到微信",@"分享到朋友圈",@"分享到新浪微博", @"删除点评", @"举报商品", nil];
        actionSheet.backgroundColor = UIColorFromRGB(0xffffff);
        [actionSheet showInView:self.view];
    }

}

- (void)buyButtonAction
{
    if (self.entity.purchaseArray.count >0) {
        GKPurchase * purchase = self.entity.purchaseArray[0];
//        NSLog(@"%@ %@", purchase.origin_id, purchase.source);
        if ([purchase.source isEqualToString:@"taobao.com"])
        {
            NSNumber  *_itemId = [[[NSNumberFormatter alloc] init] numberFromString:purchase.origin_id];
            TaeTaokeParams *taoKeParams = [[TaeTaokeParams alloc] init];
            taoKeParams.pid = kGK_TaobaoKe_PID;
            [_itemService showTaoKeItemDetailByItemId:self
                                           isNeedPush:YES
                                    webViewUISettings:nil
                                               itemId:_itemId
                                             itemType:1
                                               params:nil
                                          taoKeParams:taoKeParams
                          tradeProcessSuccessCallback:_tradeProcessSuccessCallback
                           tradeProcessFailedCallback:_tradeProcessFailedCallback];
//            [[TaeSDK sharedInstance] showTaoKeItemDetailByItemId:self isNeedPush:YES webViewUISettings:nil itemId:_itemId itemType:1 params:nil taoKeParams:nil tradeProcessSuccessCallback:_tradeProcessSuccessCallback tradeProcessFailedCallback:_tradeProcessFailedCallback];
        }
        else
            [self showWebViewWithTaobaoUrl:[purchase.buyLink absoluteString]];
        
        [AVAnalytics event:@"buy action" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.lowestPrice];
        [MobClick event:@"purchase" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.lowestPrice];
    }
}

- (void)showWebViewWithTaobaoUrl:(NSString *)taobao_url
{
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    NSString * TTID = [NSString stringWithFormat:@"%@_%@",kTTID_IPHONE,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sid = @"";
    taobao_url = [taobao_url stringByReplacingOccurrencesOfString:@"&type=mobile" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@&sche=com.guoku.iphone&ttid=%@&sid=%@&type=mobile&outer_code=IPE",taobao_url, TTID,sid];
    GKUser *user = [Passport sharedInstance].user;
    if(user)
    {
        url = [NSString stringWithFormat:@"%@%lu",url,user.userId];
    }

    GKWebVC * VC = [GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:url]];
    VC.hidesBottomBarWhenPushed = YES;
    VC.title = @"宝贝详情";
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)categoryButtonAction
{
    CategoryViewController * VC = [[CategoryViewController alloc]init];
    VC.category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    
    [AVAnalytics event:@"entity_forward_categoty"];
    [MobClick event:@"entity_forward_categoty"];
}

- (void)avatarButtonAction:(UIButton *)button;
{
    UserViewController * VC = [[UserViewController alloc]init];
    VC.user = [self.dataArrayForlikeUser objectAtIndex:button.tag];
    [self.navigationController pushViewController:VC animated:YES];
    
    [AVAnalytics event:@"entity_forward_user"];
    [AVAnalytics event:@"entity_forward_user"];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"分享到微信"]) {
        [self wxShare:0];
    }else if ([buttonTitle isEqualToString:@"分享到朋友圈"]) {
        [self wxShare:1];
    }
    else if ([buttonTitle isEqualToString:@"分享到新浪微博"]) {
        [self weiboShare];
    }
    else if ([buttonTitle isEqualToString:@"举报商品"]) {
        ReportViewController * VC = [[ReportViewController alloc]init];
        VC.entity = self.entity;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"写点评"]) {
        [self noteButtonAction];
    }
    else if ([buttonTitle isEqualToString:@"修改点评"]) {
        [self noteButtonAction];
    }
    else if ([buttonTitle isEqualToString:@"删除点评"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除点评？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [GKAPI deleteNoteByNoteId:self.note.noteId success:^{
            __block NSInteger noteIndex = -1;
            [self.dataArrayForNote enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GKNote *note = obj;
                if (note.noteId == self.note.noteId) {
                    noteIndex = (NSInteger)idx;
                }
            }];
            
            if (noteIndex != -1) {
                [self.dataArrayForNote removeObjectAtIndex:noteIndex];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:noteIndex inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            self.note = nil;
        } failure:nil];
    }
}


- (void)wxShare:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    UIImage *image = [self.image.image  imageWithSize:CGSizeMake(220.f, 220.f)];
    NSData *oldData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat size = oldData.length / 1024;
    if (size > 25.0f) {
        CGFloat f = 25.0f / size;
        NSData *datas = UIImageJPEGRepresentation(image, f);
        //            float s = datas.length / 1024;
        //            GKLog(@"s---%f",s);
        UIImage *smallImage = [UIImage imageWithData:datas];
        [message setThumbImage:smallImage];
    }
    else{
        [message setThumbImage:image];
    }
    
    WXWebpageObject *webPage = [WXWebpageObject object];
    webPage.webpageUrl = [NSString stringWithFormat:@"%@%@/?from=wechat",kGK_WeixinShareURL,self.entity.entityHash];
    message.mediaObject = webPage;
    if(scene ==1)
    {
        message.title = [NSString stringWithFormat:@"%@ %@",self.entity.brand,self.entity.title];
        message.description = @"";
    }
    else
    {
        message.title = @"果库 - 精英消费指南";
        message.description = [NSString stringWithFormat:@"%@ %@",self.entity.brand,self.entity.title];
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =scene;
    
    if ([WXApi sendReq:req]) {
        
    }
    else{
        [SVProgressHUD showImage:nil status:@"图片太大，请关闭高清图片按钮"];
    }
}

- (void)weiboShare
{

        [AVOSCloudSNS shareText:[NSString stringWithFormat:@"%@ %@",self.entity.brand,self.entity.title] andLink:[NSString stringWithFormat:@"%@%@/?from=weibo",kGK_WeixinShareURL,self.entity.entityHash] andImage:[self.image.image  imageWithSize:CGSizeMake(460.f, 460.f)]  toPlatform:AVOSCloudSNSSinaWeibo withCallback:^(id object, NSError *error) {
            
        } andProgress:^(float percent) {
            if (percent == 1) {
                [SVProgressHUD showImage:nil status:@"分享成功\U0001F603"];
            }
        }];
}


- (void)configFooter
{
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footer.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.tableView.tableFooterView = footer;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,80)];
    view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    
    UIView * H = [[UIView alloc] initWithFrame:CGRectMake(20,50, kScreenWidth-40, 0.5)];
    H.backgroundColor = UIColorFromRGB(0xebebeb);
    [view addSubview:H];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 120, 20.f)];
    label.backgroundColor = UIColorFromRGB(0xf8f8f8);
    label.font = [UIFont fontWithName:@"FultonsHand" size:14];
    label.center = CGPointMake(kScreenWidth/2, 50);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Live Different";
    label.textColor = UIColorFromRGB(0xcbcbcb);
    [view addSubview:label];
    
    [footer addSubview:view];
}

@end
