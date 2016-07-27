//
//  authorizedUserViewController.m
//  orange
//
//  Created by D_Collin on 16/2/26.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "authorizedUserViewController.h"
#import "UserHeaderView.h"
//#import "CategoryArticleCell.h"
#import "MoreArticleCell.h"
#import "FriendViewController.h"
#import "FanViewController.h"

#import "UIScrollView+Slogan.h"
#import "LoginView.h"

@interface authorizedUserViewController ()<UserHeaderViewDelegate>

@property (nonatomic , strong) NSMutableArray * articledataArray;

@property (nonatomic , strong) UserHeaderView * headerView;

@property (nonatomic , strong) UICollectionView * collectionView;

@property (nonatomic , assign)NSInteger page;

@property (nonatomic , assign)NSInteger height;

@end

@implementation authorizedUserViewController

static NSString * UserHeaderIdentifer = @"UserHeader";
static NSString * UserArticleIdentifier = @"ArticleCell";

- (instancetype)initWithUser:(GKUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        if (self.user.userId == [Passport sharedInstance].user.userId) {
//            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_icon_me"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_me"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
//            item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//            self.tabBarItem = item;
            
            
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
        _collectionView = [[UICollectionView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) collectionViewLayout:layout];
        
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
//    NSLog(@"%ld",self.user.userId);
    self.page = 1;
    
    [API getUserArticlesWithUserId:self.user.userId Page:self.page Size:10 success:^(NSArray *articles, NSInteger page, NSInteger count) {
        
        self.articledataArray = [NSMutableArray arrayWithArray:articles];
        self.page += 1;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
    
    
}

- (void)loadMore
{
    [API getUserArticlesWithUserId:self.user.userId Page:self.page Size:10 success:^(NSArray *articles, NSInteger page, NSInteger count) {
        [self.articledataArray addObjectsFromArray:articles];
        self.page += 1;
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadView
{
    self.view = self.collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.nickname;
    
    [self.collectionView registerClass:[UserHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderIdentifer];
    
    [self.collectionView registerClass:[MoreArticleCell class] forCellWithReuseIdentifier:UserArticleIdentifier];
    
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
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    

    if (self.articledataArray == 0) {
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.articledataArray.count;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderIdentifer forIndexPath:indexPath];
        self.headerView.user = self.user;
        self.headerView.delegate = self;
        return self.headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
       MoreArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserArticleIdentifier forIndexPath:indexPath];
            
        cell.article = [self.articledataArray objectAtIndex:indexPath.row];
        return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize  = CGSizeMake(0., 0.);
    if (IS_IPAD) {
        cellsize = CGSizeMake(342., 360.);
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight){
            cellsize = CGSizeMake(313., 344.);
        }
        //        return cellsize;
    } else {
        
        cellsize = CGSizeMake(kScreenWidth, 110.);
    }
    return cellsize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0., 0., 0., 0.);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat linespacing = 0.;
    
    if (IS_IPHONE) {
        linespacing =  1.;
    }
    return linespacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return IS_IPHONE ? CGSizeMake(kScreenWidth, 305.) : CGSizeMake(kScreenWidth - kTabBarWidth, 380);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.articledataArray objectAtIndex:indexPath.row];
    
    [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
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

- (void)TapFollowBtnWithUser:(GKUser *)user View:(UserHeaderView *)view
{
    DDLogInfo(@"follow with user id %lu", user.userId);
    if (!k_isLogin) {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
        //        [[OpenCenter sharedOpenCenterController] openAccountViewControllerWithSuccessBlock:^(BOOL isLogin) {
        //            //            [self.arrayForUser removeAllObjects];
        //            [self.collectionView triggerPullToRefresh];
        //        }];
    } else {
        [API followUserId:user.userId state:YES success:^(GKUserRelationType relation) {
            user.relation = relation;
            DDLogInfo(@"relation %lu", (long)relation);
            view.user = user;
            //            [self.tableView reloadData];
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



#pragma mark - UserModel KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        if ([keyPath isEqualToString:@"nickname"]) {
            DDLogInfo(@"nickname kvo %@", [Passport sharedInstance].user.nickname);
            //            self.
            self.user = [Passport sharedInstance].user;
            self.navigationItem.title = self.user.nickname;
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
