//
//  UserViewController.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserViewController.h"
//#import "UserHeaderView.h"
#import "UserHeaderView.h"
#import "UserHeaderSectionView.h"
#import "UserFooterSectionView.h"
#import "EntityCell.h"
#import "NoteCell.h"
#import "CategoryArticleCell.h"

#import "SettingViewController.h"

#import "EditViewController.h"
#import "FriendViewController.h"
#import "FanViewController.h"
#import "UserArticleViewController.h"

#import "UserLikeViewController.h"
#import "UserPostNoteViewController.h"
#import "UserTagsViewController.h"
#import "UserDigArticlesViewController.h"

#import "UIScrollView+Slogan.h"
#import "LoginView.h"


//#import "DataStructure.h"

@interface UserViewController () <EntityCellDelegate, UserHeaderSectionViewDelegate, UserHeaderViewDelegate>

@property (strong, nonatomic) NSMutableArray * likedataArray;
@property (strong, nonatomic) NSMutableArray * notedataArray;
@property (strong, nonatomic) NSMutableArray * articledataArray;

//@property (strong, nonatomic) UserHeaderView * headerView;
@property (strong, nonatomic) UICollectionView * collectionView;

@property (strong, nonatomic) UserHeaderView * headerView;

@property (assign, nonatomic) UserPageType type;

@property(nonatomic, strong) id<ALBBCartService> cartService;
@property(nonatomic, strong) tradeProcessSuccessCallback tradeProcessSuccessCallback;
@property(nonatomic, strong) tradeProcessFailedCallback tradeProcessFailedCallback;

@property (weak, nonatomic) UIApplication * app;

@end

@implementation UserViewController

//static NSString * UserHeaderIdentifer = @"AuthUserHeader";
static NSString * UserHeaderIdentifer = @"UserHeader";
static NSString * UserHeaderSectionIdentifer = @"UserHeaderSection";
static NSString * UserFooterSectionIdentifer = @"UserFooterSection";
static NSString * UserLikeEntityIdentifer = @"EntityCell";
static NSString * UserNoteIdentifier = @"NoteCell";
static NSString * UserArticleIdentifier = @"ArticleCell";

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

- (instancetype)initWithUser:(GKUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        if (self.user.userId == [Passport sharedInstance].user.userId) {
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"profile_on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
            self.tabBarItem = item;
            
            _cartService = [[ALBBSDK sharedInstance] getService:@protocol(ALBBCartService)];
        
            
            [self.user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            [self.user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        }
        
    }
    return self;
}

- (void)dealloc
{
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        [self.user removeObserver:self forKeyPath:@"avatarURL"];
        [self.user removeObserver:self forKeyPath:@"nickname"];
    }
}

#pragma mark - init view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        if (IS_IPHONE)
            _collectionView.frame = CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight - kNavigationBarHeight - kStatusBarHeight);
        else {
            _collectionView.frame = CGRectMake(0., 0., 684., kScreenHeight);
            if (self.app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft || self.app.statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                _collectionView.center = CGPointMake((kScreenWidth - kTabBarWidth) / 2, kScreenHeight / 2);
        }
            
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}



#pragma mark - get data
- (void)refresh
{
    [API getUserDetailWithUserId:self.user.userId success:^(GKUser *user, NSArray *lastLikeEntities, NSArray *lastNotes, NSArray * lastArticles) {

        if (self.user.userId == [Passport sharedInstance].user.userId) {
            [Passport sharedInstance].user = user;
        }
        
        self.user = user;
        self.likedataArray = [NSMutableArray arrayWithArray:lastLikeEntities];
        self.notedataArray = [NSMutableArray arrayWithArray:lastNotes];
        self.articledataArray = [NSMutableArray arrayWithArray:lastArticles];

        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = UIColorFromRGB(0xfafafa);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    if (self.navigationController.viewControllers.count > 1){
        self.collectionView.deFrameHeight = kScreenHeight;
    }
    
    self.navigationItem.title = self.user.nick;
//    [self.collectionView registerClass:[UserHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderIdentifer];
    
    [self.collectionView registerClass:[UserHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderIdentifer];
    
    [self.collectionView registerClass:[UserHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer];
    
    [self.collectionView registerClass:[UserFooterSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UserFooterSectionIdentifer];
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:UserLikeEntityIdentifer];
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:UserNoteIdentifier];
    [self.collectionView registerClass:[CategoryArticleCell class] forCellWithReuseIdentifier:UserArticleIdentifier];
    
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        NSMutableArray * array = [NSMutableArray array];
        
        if (IS_IPHONE)
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
            [button setTitle:[NSString fontAwesomeIconStringForEnum:FACog] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
            button.backgroundColor = [UIColor clearColor];
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
            [array addObject:item];
        }
        
        if ([[TaeSession sharedInstance] isLogin])
        {
            UIButton * cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cartBtn.frame = CGRectMake(0., 0., 32., 44.);
            cartBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20.];
            [cartBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
            [cartBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAShoppingCart] forState:UIControlStateNormal];
            [cartBtn setTitleEdgeInsets:UIEdgeInsetsMake(8., 0., 0., 0.)];
            [cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem * cartBtnItem = [[UIBarButtonItem alloc] initWithCustomView:cartBtn];
            [array addObject:cartBtnItem];
        }
        
        self.navigationItem.rightBarButtonItems = array;
    }
    
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    kAppDelegate.activeVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"userView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"userView"];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
//         [self.collectionView performBatchUpdates:nil completion:nil];
         //         self.collectionView.deFrameLeft = 128.;
         if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight || self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
             self.collectionView.frame = CGRectMake(128., 0., 684., kScreenHeight);
         else
             self.collectionView.frame = CGRectMake(0., 0., 684., kScreenHeight);
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.collectionView addSloganView];
    
    if (self.user && self.likedataArray.count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 1:
        {
            if (IS_IPAD) {
                count = self.likedataArray.count > 6 ? 6 : self.likedataArray.count;
            } else
                count = self.likedataArray.count > 4 ? 4 : self.likedataArray.count;
        }
            break;
        case 2:
//        {
//            count = self.articledataArray.count > 3 ? 3 : self.articledataArray.count;
//        }
            break;
        case 3:
//        {
//            count = self.notedataArray.count > 3 ? 3 : self.notedataArray.count;
//        }
            break;
        default:
            break;
    }
    return count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        switch (indexPath.section) {
            case 0:
            {
                self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderIdentifer forIndexPath:indexPath];
                self.headerView.user = self.user;
                self.headerView.delegate = self;
                return self.headerView;
            }
                break;
                
            case 1:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                [headerSection setUser:self.user WithType:UserLikeType];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case 2:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                [headerSection setUser:self.user WithType:UserArticleType];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case 3:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                [headerSection setUser:self.user WithType:UserPostType];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case 4:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                [headerSection setUser:self.user WithType:UserTagType];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case 5:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                [headerSection setUser:self.user WithType:UserDigArticleType];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            default:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                
                return headerSection;
            }
                break;
        }
    } else {
        UserFooterSectionView * footerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UserFooterSectionIdentifer forIndexPath:indexPath];
        //footerSection.title = NSLocalizedStringFromTable(@"more", kLocalizedFile, nil);
            footerSection.alpha = 0;
            switch (indexPath.section) {
                case 0:
                    footerSection.alpha = 1;
                    break;
                case 1:
                    if (self.likedataArray.count > 0)
                        footerSection.alpha = 1;
                    break;
                    
                case 2:
                    if (self.articledataArray.count > 0)
                        footerSection.alpha = 1;
                    break;
                    
                case 3:
                    if (self.user.noteCount > 0)
                        footerSection.alpha = 1;
                    break;
                    
                case 4:
                    if (self.user.tagCount > 0)
                        footerSection.alpha = 1;
                    break;
                case 5:
                    if (self.user.digCount > 0)
                        footerSection.alpha = 1;
                    break;
            }
        
        
        return footerSection;
    }
    
//    return [UICollectionReusableView new];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

//    switch (indexPath.section) {
//        default:
//        {
            EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserLikeEntityIdentifer forIndexPath:indexPath];
            cell.imageView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
            cell.imageView.layer.borderWidth = 0.5;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.imageView.clipsToBounds = YES;
            cell.entity = [self.likedataArray objectAtIndex:indexPath.row];
            cell.delegate = self;
            return cell;
//        }
//            break;
//    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (indexPath.section) {
        case 1:
            if (IS_IPAD) {
                itemSize = CGSizeMake(100., 100.);
            } else {
                itemSize = IS_IPHONE_6P || IS_IPHONE_6 ? CGSizeMake(80., 80.) : CGSizeMake(64., 64.);
//                if (IS_IPHONE_6P || IS_IPHONE_6)
//                    itemSize = CGSizeMake(80., 80.);
//                else
//                    itemSize = CGSizeMake(64., 64.);
            }

            break;
        case 2:
            itemSize = CGSizeMake(kScreenWidth, 110.);
            break;
        case 3:
            itemSize = CGSizeMake(kScreenWidth, 100.);
            break;
        default:
            break;
    }
    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0., 0.);
    switch (section) {
        case 0:
            {
                CGFloat userHeaderHeight = self.user.bio.length == 0 ? 144. : 204.;
                userHeaderHeight += IS_IPAD ? 20. : 0.;
            
                size = CGSizeMake(self.collectionView.deFrameWidth, userHeaderHeight);
            
            }
            break;
            
        case 1:
            if (self.likedataArray.count > 0)
                size = CGSizeMake(self.collectionView.deFrameWidth, 44.);
            break;
        case 2:
            if (self.articledataArray.count > 0) {
                size = CGSizeMake(self.collectionView.deFrameWidth, 44.);
            }
            break;
        case 3:
            if (self.notedataArray.count > 0)
                size = CGSizeMake(self.collectionView.deFrameWidth, 44.);
            break;
        case 4:
            if (self.user.tagCount > 0)
                size = CGSizeMake(self.collectionView.deFrameWidth, 44.);
            break;
        case 5:
            if (self.user.digCount > 0)
                size = CGSizeMake(self.collectionView.deFrameWidth, 44.);
            break;
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0., 0.);
    switch (section) {
        case 0:
            if (self.user.bio.length == 0) {
                size = CGSizeMake(kScreenWidth, 10.);
            }
            else
            {
                size = CGSizeMake(0., 0.);
            }
            break;
        case 1:
            if (self.likedataArray.count > 0)
                size = CGSizeMake(kScreenWidth, 10.);
            break;
        case 2:
            if (self.articledataArray.count > 0) {
                size = CGSizeMake(kScreenWidth, 10.);
            }
            break;
        case 3:
            if (self.notedataArray.count > 0)
                size = CGSizeMake(kScreenWidth, 10.);
            break;
        case 4:
            if (self.user.tagCount > 0)
                size = CGSizeMake(kScreenWidth, 10.);
            break;
        case 5:
            if (self.user.digCount > 0)
                size = CGSizeMake(kScreenWidth, 10.);
            break;
    }
    return size;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
    switch (section) {
        case 1:
            if (IS_IPHONE_6 || IS_IPHONE_6P) itemSpacing = 5.;
            break;
            
        default:
            break;
    }
    return itemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    switch (section) {
        case 1:
            if (self.likedataArray.count > 0)
                edge = UIEdgeInsetsMake(0., 16., 16., 16.);
            break;
            
        default:
            break;
    }
    return edge;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 2:
        {
            GKArticle * article = [self.articledataArray objectAtIndex:indexPath.row];
            [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
            
        }
            break;
        case 3:
        {
            GKNote * note = [self.notedataArray objectAtIndex:indexPath.row];
            GKEntity * entity = [GKEntity modelFromDictionary:@{@"entity_id": note.entityId}];
            [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - button action
- (void)settingButtonAction
{
    SettingViewController * VC = [[SettingViewController alloc]init];
    if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)cartBtnAction:(id)sender
{
    [_cartService showCart:self isNeedPush:YES webViewUISettings:nil tradeProcessSuccessCallback:_tradeProcessSuccessCallback tradeProcessFailedCallback:_tradeProcessFailedCallback];
}

#pragma mark - <UserHeaderViewDelegate>
- (void)TapFriendBtnWithUser:(GKUser *)user
{
    FriendViewController * VC = [[FriendViewController alloc]init];
    VC.user = self.user;
    if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)TapFansBtnWithUser:(GKUser *)user
{
    FanViewController * VC = [[FanViewController alloc]init];
    VC.user = self.user;
    if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)TapEditBtnWithUser:(GKUser *)user
{
    EditViewController * vc = [[EditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)TapFollowBtnWithUser:(GKUser *)user View:(UserHeaderView *)view
{
//    DDLogInfo(@"follow with user id %lu", user.userId);
    if (!k_isLogin) {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    } else {
        [API followUserId:user.userId state:YES success:^(GKUserRelationType relation) {
            user.relation = relation;
            DDLogInfo(@"relation %lu", relation);
            view.user = user;
            [SVProgressHUD showImage:nil status:@"关注成功"];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"关注失败"];
        }];
    }
}

- (void)TapUnFollowBtnWithUser:(GKUser *)user View:(UserHeaderView *)view
{
    DDLogInfo(@"unfollow");
    UIAlertController * altervc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@?",NSLocalizedStringFromTable(@"unfollow", kLocalizedFile, nil), user.nickname] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cacnel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //        [altervc dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"confirm", kLocalizedFile, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [API followUserId:user.userId state:NO success:^(GKUserRelationType relation) {
            user.relation = relation;
            //            [self configFollowButton];
            view.user = user;
            [SVProgressHUD showImage:nil status:@"取消关注成功"];
            //            [self.tableView reloadData];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"取消关注失败"];
        }];
        
    }];
    
    [altervc addAction:cacnel];
    [altervc addAction:confirm];
    [self presentViewController:altervc animated:YES completion:nil];
}

#pragma mark - <UserHeaderSectionViewDelegate>
- (void)TapHeaderViewWithType:(UserPageType)type
{
    switch (type) {
        case UserLikeType:
        {
            UserLikeViewController *vc = [[UserLikeViewController alloc] initWithUser:self.user];
            if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case UserArticleType:
        {
            UserArticleViewController * vc = [[UserArticleViewController alloc] init];
            vc.Uid = self.user.userId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case UserPostType:
        {
            UserPostNoteViewController * vc = [[UserPostNoteViewController alloc] initWithUser:self.user];
            if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case UserTagType:
        {
            UserTagsViewController * vc = [[UserTagsViewController alloc] initWithUser:self.user];
            if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case UserDigArticleType:
        {
            UserDigArticlesViewController * vc = [[UserDigArticlesViewController alloc]initWithUser:self.user];
            if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity hideButtomBar:YES];
}

#pragma mark - UserModel KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        if ([keyPath isEqualToString:@"nickname"]) {
            DDLogInfo(@"nickname kvo %@", [Passport sharedInstance].user.nickname);
            self.user = [Passport sharedInstance].user;
            self.navigationItem.title = self.user.nick;
            self.headerView.user = self.user;
//            [self.collectionView reloadData];
        }
        
        if ([keyPath isEqualToString:@"avatarURL"]) {
            self.user = [Passport sharedInstance].user;
            self.headerView.user = self.user;
//            [self.collectionView reloadData];
        }
    }
}


@end
