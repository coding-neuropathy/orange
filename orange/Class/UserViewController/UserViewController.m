//
//  UserViewController.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserViewController.h"
#import "UserHeaderView.h"
#import "UserHeaderSectionView.h"
#import "UserFooterSectionView.h"
#import "EntityCell.h"
#import "NoteCell.h"

#import "FriendViewController.h"
#import "FanViewController.h"

#import "UserLikeViewController.h"
#import "UserPostNoteViewController.h"

//#import "DataStructure.h"

@interface UserViewController () <EntityCellDelegate, UserHeaderViewDelegate, UserFooterSectionDelete>

@property (strong, nonatomic) NSMutableArray * likedataArray;
@property (strong, nonatomic) NSMutableArray * notedataArray;
@property (strong, nonatomic) UserHeaderView * headerView;
@property (strong, nonatomic) UICollectionView * collectionView;

@property (assign, nonatomic) UserPageType type;

@end

@implementation UserViewController

static NSString * UserHeaderIdentifer = @"UserHeader";
static NSString * UserHeaderSectionIdentifer = @"UserHeaderSection";
static NSString * UserFooterSectionIdentifer = @"UserFooterSection";
static NSString * UserLikeEntityIdentifer = @"EntityCell";
static NSString * UserNoteIdentifier = @"NoteCell";


- (instancetype)initWithUser:(GKUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

#pragma mark - init view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        
        //        _collectionView.contentInset = UIEdgeInsetsMake(617, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
    [API getUserDetailWithUserId:self.user.userId success:^(GKUser *user, NSArray *lastLikeEntities, NSArray *lastNotes) {
        self.user = user;
        self.likedataArray = [NSMutableArray arrayWithArray:lastLikeEntities];
        self.notedataArray = [NSMutableArray arrayWithArray:lastNotes];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}


- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.user.nickname;
    
    [self.collectionView registerClass:[UserHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderIdentifer];
    
    [self.collectionView registerClass:[UserHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer];
    
    [self.collectionView registerClass:[UserFooterSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UserFooterSectionIdentifer];
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:UserLikeEntityIdentifer];
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:UserNoteIdentifier];
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
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 1:
        {
            count = self.likedataArray.count > 4 ? 4 : self.likedataArray.count;
            
        }
            break;
        case 2:
            count = self.notedataArray.count > 3 ? 3 : self.notedataArray.count;
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
                return headerSection;
            }
                break;
            case 2:
            {
                UserHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UserHeaderSectionIdentifer forIndexPath:indexPath];
                [headerSection setUser:self.user WithType:UserPostType];
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
//        footerSection.title = NSLocalizedStringFromTable(@"more", kLocalizedFile, nil);
        switch (indexPath.section) {
            case 1:
                footerSection.type = UserLikeType;
                break;
            case 2:
                footerSection.type = UserPostType;
                break;
            default:
                break;
        }
        
        footerSection.delegate = self;
        return footerSection;
    }
    
//    return [UICollectionReusableView new];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserLikeEntityIdentifer forIndexPath:indexPath];
//    cell.entity = [self.likedataArray objectAtIndex:indexPath.row];
//    cell.delegate = self;
//    return cell;
    switch (indexPath.section) {
        case 2:
        {
            NoteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserNoteIdentifier forIndexPath:indexPath];
            cell.note = [self.notedataArray objectAtIndex:indexPath.row];
            return cell;
        }
            break;
            
        default:
        {
            EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserLikeEntityIdentifer forIndexPath:indexPath];
            cell.entity = [self.likedataArray objectAtIndex:indexPath.row];
            cell.delegate = self;
            return cell;
        }
            break;
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (indexPath.section) {
        case 1:
            itemSize = CGSizeMake(80., 80.);
            break;
        case 2:
            itemSize = CGSizeMake(kScreenWidth, 100.);
            break;
        default:
            break;
    }
    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize size = CGSizeMake(0., 0.);
    switch (section) {
        case 0:
            size = CGSizeMake(kScreenWidth, 260.);
            break;
            
        case 1:
            if (self.likedataArray.count > 0)
                size = CGSizeMake(kScreenWidth, 44.);
            break;
            
        default:
            if (self.notedataArray.count > 0)
                size = CGSizeMake(kScreenWidth, 44.);
            break;
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0., 0.);
    switch (section) {
        case 0:
            
            break;
        case 1:
        {
            if (self.likedataArray.count > 4)
                size = CGSizeMake(kScreenWidth, 54.);
        }
            break;
        case 2:
            if (self.notedataArray.count > 3)
                size = CGSizeMake(kScreenWidth, 54.);
            break;
        default:
            break;
    }
    return size;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
    switch (section) {
        case 1:
            itemSpacing = 5.;
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
            GKNote * note = [self.notedataArray objectAtIndex:indexPath.row];
            GKEntity * entity = [GKEntity modelFromDictionary:@{@"entity_id": note.entityId}];
            [[OpenCenter sharedOpenCenter] openEntity:entity];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <UserHeaderViewDelegate>
- (void)TapFriendBtnWithUser:(GKUser *)user
{
    FriendViewController * VC = [[FriendViewController alloc]init];
    VC.user = self.user;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)TapFansBtnWithUser:(GKUser *)user
{
    FanViewController * VC = [[FanViewController alloc]init];
    VC.user = self.user;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - <UserFooterSectionDelete>
- (void)TapMoreButtonWithType:(UserPageType)type
{
    switch (type) {
        case UserLikeType:
        {
            UserLikeViewController *vc = [[UserLikeViewController alloc] initWithUser:self.user];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case UserPostType:
        {
            UserPostNoteViewController * vc = [[UserPostNoteViewController alloc] initWithUser:self.user];
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
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}


@end
