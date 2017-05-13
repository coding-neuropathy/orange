//
//  EntityViewController.m
//  orange
//
//  Created by huiter on 15/1/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityViewController.h"
//#import "API.h"

//#import "EntityStickyHeaderFlowLayout.h"
#import "UserViewController.h"
#import "SubCategoryEntityController.h"

#import "EntityHeaderView.h"
#import "EntityLikeUserCell.h"
#import "EntityNoteCell.h"
#import "EntityCell.h"
#import "EntityHeaderSectionView.h"
#import "EntityHeaderActionView.h"
//#import "EntityHeaderBuyView.h"
#import "EntityPopView.h"

//#import "EntityNoteFooterView.h"

#import "EntityLikerController.h"
#import "UIScrollView+Slogan.h"

#import "ReportViewController.h"
#import "ShareController.h"
#import "PNoteViewController.h"


/**
 *  3d-touch
 */
#import "EntityPreViewController.h"


typedef NS_ENUM(NSInteger, EntityDisplayCellType) {
    EntityHeaderType,
    EntityHeaderActionType,
//    EntityHeaderBuyType,
    EntityHeaderLikeType,
    EntityHeaderNoteType,
    EntityHeaderCategoryType,
};

@interface EntityViewController ()<EntityHeaderViewDelegate, EntityHeaderSectionViewDelegate, EntityNoteCellDelegate, EntityLikeUserCellDelegate, EntityCellDelegate>

@property (nonatomic, strong) GKNote        *note;
//@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *image;
@property (nonatomic, strong) UIButton      *likeButton;
@property (nonatomic, strong) UIButton      *buyButton;
@property (nonatomic, strong) UIButton      *noteButton;
@property (nonatomic, strong) UIButton      *moreBtn;

@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) EntityHeaderActionView    *actionView;
//@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) UIButton              *postBtn;
@property (nonatomic, strong) NSMutableArray        *dataArrayForlikeUser;
@property (nonatomic, strong) NSMutableArray        *dataArrayForNote;
@property (nonatomic, strong) NSMutableArray        *dataArrayForRecommend;

//@property (nonatomic, strong) id<ALBBItemService>   itemService;

//@property (strong, nonatomic) UIActionSheet         *actionSheet;

/**
 * 店家id （仅限淘宝，天猫）
 */
@property (strong, nonatomic) NSString              *seller_id;


//@property (strong, nonatomic) SloppySwiper *swiper;

@end

@implementation EntityViewController
{
    AlibcTradeProcessSuccessCallback _tradeProcessSuccessCallback;
    AlibcTradeProcessFailedCallback _tradeProcessFailedCallback;
}

static NSString * LikeUserIdentifier = @"LikeUserCell";
static NSString * NoteCellIdentifier = @"NoteCell";
static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * const EntityReuseHeaderIdentifier = @"EntityHeader";
static NSString * const EntityReuseHeaderSectionIdentifier = @"EntityHeaderSection";
static NSString * const EntityReuseHeaderActionIdentifier = @"EntityHeaderAction";
//static NSString * const EntityReuseHeaderBuyIdentifier = @"EntityHeaderBuy";
static NSString * const EntityReuseFooterNoteIdenetifier = @"EntityNoteFooter";

- (instancetype)init
{
    if (self = [super init]) {
//        self.itemType = OneSDKItemType_TAOBAO1;
//        self.flag           = false;
        self.image          = [[UIImageView alloc] initWithFrame:CGRectZero];
//        self.itemService    = [[ALBBSDK sharedInstance] getService:@protocol(ALBBItemService)];
        
        self.dataArrayForNote       = [[NSMutableArray alloc] initWithCapacity:0];
        self.dataArrayForlikeUser   = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver];
}

- (instancetype)initWithEntity:(GKEntity *)entity
{
    self = [self init];
    if (self) {
        self.entity = entity;
        if (self.entity.purchaseArray > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"]) {
                self.seller_id = purchase.seller;
            }
        }
        
    }
    return self;
}

#pragma mark -
- (CGFloat)headerHeight
{
    return [EntityHeaderView headerViewHightWithEntity:self.entity];
}

- (void)setSpecialNavigationBarWithAlpha:(CGFloat)alpha
{
    if (alpha <=0 ) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    self.navigationController.navigationBar.translucent     = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"top bar ggradient"] stretchableImageWithLeftCapWidth:1 topCapHeight:64] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage     = [UIImage new];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor colorWithRed:33. / 255. green:33. / 255. blue:33. / 255. alpha:alpha]
                                                                      }];
    
    
    [self.moreBtn setImage:[UIImage imageNamed:@"more white"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    [self setWhiteBackBtn];
}

- (void)setDefaultNavigationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageWithColor:[UIColor colorFromHexString:@"#ffffff"] andSize:CGSizeMake(10, 10)] stretchableImageWithLeftCapWidth:2 topCapHeight:2]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#ebebeb"] andSize:CGSizeMake(kScreenWidth, 1)]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor colorWithRed:33. / 255. green:33. / 255. blue:33. / 255. alpha:1]
                                                                      }];
    
    [self.moreBtn setImage:[UIImage imageNamed:@"more dark"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    [self setDefaultBackBtn];
}

#pragma mark - View
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
//        EntityStickyHeaderFlowLayout *entityLayout = [[EntityStickyHeaderFlowLayout alloc] init];
//        entityLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionViewFlowLayout *layout      = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.deFrameSize = IS_IPAD   ? CGSizeMake(kPadScreenWitdh, kScreenHeight - kStatusBarHeight)
                                                : CGSizeMake(kScreenWidth, kScreenHeight);
    
        _collectionView.delegate                = self;
        _collectionView.dataSource              = self;
        _collectionView.backgroundColor         = kBackgroundColor;
//        _collectionView.backgroundColor         = [UIColor redColor];
        _collectionView.alwaysBounceVertical    = YES;
        /**
         *  适配横屏启动
         */
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight
            || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
            self.collectionView.deFrameLeft = (kScreenWidth - kTabBarWidth - self.collectionView.deFrameWidth ) / 2.;
    }
    return _collectionView;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.deFrameSize        = CGSizeMake(32., 32.);
        _moreBtn.backgroundColor    = [UIColor clearColor];
        [_moreBtn setImage:[UIImage imageNamed:@"more dark"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    return _moreBtn;
}

#pragma mark - get entity data
- (void)refresh
{
    [API getEntityDetailWithEntityId:self.entity.entityId success:^(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray, NSArray *recommendation) {
        [self.image sd_setImageWithURL:self.entity.imageURL_640x640];
        self.entity = entity;

        self.dataArrayForlikeUser   = [NSMutableArray arrayWithArray:likeUserArray];
        self.dataArrayForNote       = [NSMutableArray arrayWithArray:noteArray];
        self.dataArrayForRecommend  = [NSMutableArray arrayWithArray:recommendation];
        
//        DDLogInfo(@"section note %@", self.dataArrayForNote[0]);
        for (GKNote *note in self.dataArrayForNote) {
            DDLogInfo(@"note %@", note.text);
            if (note.creator.userId == [Passport sharedInstance].user.userId) {
                self.note = note;
                break;
            }
        }
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                    self.buyButton.enabled = NO;
//                    self.buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
                    self.buyButton.backgroundColor = [UIColor clearColor];
                    [self.buyButton setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
                     [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    break;
                case GKBuySOLDOUT:
                    self.buyButton.backgroundColor = [UIColor colorFromHexString:@"#9d9e9f"];
                     [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    break;
                default:
                    [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
                    break;
            }
            
        }
        [self.collectionView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (IS_IPHONE) self.collectionView.deFrameTop = -64.;
    self.title = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    
    [self.collectionView registerClass:[EntityLikeUserCell class] forCellWithReuseIdentifier:LikeUserIdentifier];
    [self.collectionView registerClass:[EntityNoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderIdentifier];
    [self.collectionView registerClass:[EntityHeaderActionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderActionIdentifier];
//    [self.collectionView registerClass:[EntityHeaderBuyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderBuyIdentifier];
    [self.collectionView registerClass:[EntityHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier];
    
    [self.view addSubview:self.collectionView];

    
    if (IS_IPAD) {
        [self.moreBtn setImage:[UIImage imageNamed:@"more dark"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    }

    
    [self refresh];
    
    if (iOS9)
        [self registerPreview];
}

/**
 *  3D-Touch
 */
- (void)registerPreview{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }
    else {
        DDLogInfo(@"该设备不支持3D-Touch");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navBarEffect   = YES;
    [MobClick beginLogPageView:@"EntityView"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (IS_IPHONE) {
//        [self setDefaultNavigationBar];
        self.navBarEffect   = NO;
    }
    [MobClick endLogPageView:@"EntityView"];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set entity data
- (void)setEntity:(GKEntity *)entity
{
    if (self.entity) {
        [self removeObserver];
    }
    _entity = entity;
    [self addObserver];
}
//
//- (void)setNote:(GKNote *)note
//{
//    _note = note;
//    self.actionView.note = note;
//}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [self.collectionView addSloganView];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self configConfigNavigationItem];
    if (IS_IPHONE && self.navBarEffect) {
        if (scrollView.contentOffset.y < 0.) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0.);
        }
        CGFloat yOffset = scrollView.contentOffset.y;
        
        if (yOffset <= (kScreenWidth - 64)) {
            CGFloat navbarAphla = yOffset / (kScreenWidth - 64);
            [self setSpecialNavigationBarWithAlpha:navbarAphla];            
        } else {
            [self setDefaultNavigationBar];
        }
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case EntityHeaderLikeType:
//            count = IS_IPAD ? self.dataArrayForlikeUser.count : 1;
            if (self.dataArrayForlikeUser.count > 0) {
                count = IS_IPAD ? self.dataArrayForlikeUser.count : 1;
            }
//            return count;
            
            break;
        case EntityHeaderNoteType:
//            DDLogInfo(@"section %ld num %ld", (long)section, (long)self.dataArrayForNote.count);
            count = self.dataArrayForNote.count;
            break;
        case EntityHeaderCategoryType:
            count = self.dataArrayForRecommend.count;
            break;
        default:
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {

        case EntityHeaderLikeType:
        {
            EntityLikeUserCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:LikeUserIdentifier forIndexPath:indexPath];
            if (IS_IPAD) {
                cell.user = [self.dataArrayForlikeUser objectAtIndex:indexPath.row];
            } else {
//                cell.likeUsers  = self.dataArrayForlikeUser;
                [cell setLikeUsers:self.dataArrayForlikeUser WithLikeCount:self.entity.likeCount];
                cell.delegate   = self;
            }
            
            return cell;
        }
            break;
        case EntityHeaderNoteType:
        {
            EntityNoteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
            cell.note = [self.dataArrayForNote objectAtIndex:indexPath.row];
            cell.delegate = self;
            cell.tapAvatarBlock = ^(GKUser *user) {
                [[OpenCenter sharedOpenCenter] openUser:user];
            };
            
            __weak __typeof(&*cell)weakCell = cell;

            cell.tapLinkBlock = ^(NSURL *url) {
                NSArray  *array= [[url absoluteString] componentsSeparatedByString:@":"];
                if([array[0] isEqualToString:@"http"])
                {
                    [[OpenCenter sharedOpenCenter] openWebWithURL:url];
                }
                
                if([array[0] isEqualToString:@"tag"])
                {
                    [[OpenCenter sharedOpenCenter] openTagWithName:[array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] User:weakCell.note.creator Controller:self];
                }
                if([array[0] isEqualToString:@"user"])
                {
                    GKUser * user = [GKUser modelFromDictionary:@{@"userId":@([array[1] integerValue])}];
//                        [[OpenCenter sharedOpenCenter] openUser:user];
                    [[OpenCenter sharedOpenCenter] openUser:user];
                }
                
                if([array[0] isEqualToString:@"entity"])
                {
                    GKEntity * entity = [GKEntity modelFromDictionary:@{@"entityId":@([array[1] integerValue])}];
                    [[OpenCenter sharedOpenCenter] openEntity:entity];
//                    EntityViewController *vc = [[EntityViewController alloc] initWithEntity:entity];
//                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            return cell;
        }
            break;
        default:
        {
            EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityCellIdentifier forIndexPath:indexPath];
            cell.entity = [self.dataArrayForRecommend objectAtIndex:indexPath.row];
            cell.delegate = self;
            return cell;
        }
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        switch (indexPath.section) {
            case EntityHeaderType:
            {
                EntityHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:EntityReuseHeaderIdentifier forIndexPath:indexPath];
                headerView.entity = self.entity;
                headerView.delegate = self;
                return headerView;
            }
                break;
                
            case EntityHeaderActionType:
            {
                EntityHeaderActionView * actionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:EntityReuseHeaderActionIdentifier forIndexPath:indexPath];
                actionView.entity   = self.entity;
                actionView.delegate = [GKHandler sharedGKHandler];
                return actionView;
            }
                break;
            case EntityHeaderLikeType:
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                headerSection.headertype = LikeType;
                headerSection.text = [NSString stringWithFormat:@"%ld", (long)self.entity.likeCount];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case EntityHeaderNoteType:
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                headerSection.headertype = NoteType;
                headerSection.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.dataArrayForNote.count];
                headerSection.postNoteBlock = ^(){
                    [self noteButtonAction];
                };
                return headerSection;
            }
                break;
            case EntityHeaderCategoryType:
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
                headerSection.headertype = CategoryHeaderType;
                if (category.categoryName) {
                    headerSection.text = category.categoryName;
                } else {
                    headerSection.text = @"";
                }
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            default:
                break;
        }
    }
    
    return reusableview;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize;
    switch (indexPath.section) {
        case EntityHeaderLikeType:
            cellsize = IS_IPAD ? CGSizeMake(36., 36.) : CGSizeMake(kScreenWidth, 64.);
            break;
        case EntityHeaderNoteType:
        {
            if (self.dataArrayForNote.count > 0) {
                GKNote * note = [self.dataArrayForNote objectAtIndex:indexPath.row];
                cellsize = CGSizeMake(self.collectionView.deFrameWidth, [EntityNoteCell height:note]);
            }
        }
            break;
        case EntityHeaderCategoryType:
        {
            cellsize = IS_IPAD ? CGSizeMake(204., 204.) : CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
        }
            break;
            
        default:
            cellsize = CGSizeMake(0., 0.);
            break;
    }
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    switch (section) {
        case EntityHeaderLikeType:
        {
            if (self.dataArrayForlikeUser.count != 0 && IS_IPAD) {
                edge = UIEdgeInsetsMake(0., 16., 16., 16.);
            }
        }
            break;
        case EntityHeaderCategoryType:
        {
            if (IS_IPHONE) {
                edge = UIEdgeInsetsMake(3, 3, 3, 3);
            }
            else
            {
                edge = UIEdgeInsetsMake(20., 20., 0, 20.);
            }
        }
            break;
        default:
//            if (IS_IPAD) edge = UIEdgeInsetsMake(0., 128., 0, 128.);
            edge = UIEdgeInsetsMake(0., 0., 0, 0.);
            break;
    }
    return edge;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing;
    switch (section) {
        case EntityHeaderType:
            break;
        case EntityHeaderLikeType:
            itemSpacing = 3.;
            break;
        case EntityHeaderCategoryType:
        {
            itemSpacing = IS_IPAD ? 16. : 3.;
        }
            break;
        default:
            itemSpacing = 0.;
            break;
    }
    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing;
    switch (section) {
        case EntityHeaderCategoryType:
        {
            if (IS_IPHONE)
                spacing = 3.;
            else
                spacing = 16.;
        }
            break;
            
        default:
            spacing = 0;
            break;
    }
    return spacing;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0., 0.);
    switch (section) {
        case EntityHeaderType:
            size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 656)
                            : CGSizeMake(kScreenWidth, [EntityHeaderView headerViewHightWithEntity:self.entity]);
            break;
        case EntityHeaderActionType:
            size    = CGSizeMake(kScreenWidth, 60.);
            break;
        case EntityHeaderLikeType:
        {
            if (self.dataArrayForlikeUser.count != 0 && IS_IPAD) {
                size =  CGSizeMake(kScreenWidth, 48.);
            }
        }
            break;
        case EntityHeaderNoteType:
        {
            if (self.dataArrayForNote.count != 0) {
                size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 30) : CGSizeMake(kScreenWidth, 68);
            }
        }
            break;
        case EntityHeaderCategoryType:
                size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 50.) : CGSizeMake(kScreenWidth, 48.);
            break;
        default:
//            size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 50.) : CGSizeMake(kScreenWidth, 48.);
            size = CGSizeMake(0., 0.);
            break;
    }
    return size;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case EntityHeaderLikeType:
        {
            if (IS_IPAD) {
//                UserViewController * VC = [[UserViewController alloc]init];
//                VC.user = [self.dataArrayForlikeUser objectAtIndex:indexPath.row];
//                [self.navigationController pushViewController:VC animated:YES];
//                [[OpenCenter sharedOpenCenter] openWithController:self User:[self.dataArrayForlikeUser objectAtIndex:indexPath.row]];
                [[OpenCenter sharedOpenCenter] openAuthUser:[self.dataArrayForlikeUser objectAtIndex:indexPath.row]];
                [MobClick event:@"entity_forward_user"];
            }
        }
            break;
//        case EntityHeaderCategoryType:
//        {
//            GKEntity *entity = [self.dataArrayForRecommend objectAtIndex:indexPath.row];
//            
//            EntityViewController    *vc = [[EntityViewController alloc] initWithEntity:entity];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case EntityHeaderNoteType:
//        {
//            
//        }
//            break;
            
        default:
            break;
    }
}

#pragma mark - <UIViewControllerPreviewingDelegate>
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath =[self.collectionView indexPathForItemAtPoint:location];
    
    EntityCell * cell = (EntityCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    switch (indexPath.section) {
        case EntityHeaderCategoryType:
        {
            if (iOS10) {
                EntityViewController * vc = [[EntityViewController alloc] initWithEntity:cell.entity];
                vc.preferredContentSize = CGSizeMake(0., 0.);
                previewingContext.sourceRect = cell.frame;
//                vc.hidesBottomBarWhenPushed = YES;
                return vc;
            } else {
                EntityPreViewController * vc    = [[EntityPreViewController alloc] initWithEntity:cell.entity PreImage:cell.imageView.image];
                vc.preferredContentSize = CGSizeMake(0., 0.);
                previewingContext.sourceRect = cell.frame;
            
                vc.baichuanblock = ^(GKPurchase * purchase) {
                    [[GKHandler sharedGKHandler] TapBuyButtonActionWithEntity:cell.entity];
                };
            
                [vc setBackblock:^(UIViewController * vc1) {
                    [self.navigationController pushViewController:vc1 animated:YES];
                }];
            
                [MobClick event:@"3d-touch" attributes:@{
                                                     @"entity"  : cell.entity.title,
                                                     @"from"    : @"detail-page-recommend",
                                                         }];
                return vc;
            }
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    if (IS_IPHONE) viewControllerToCommit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
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

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
//    EntityViewController    *vc = [[EntityViewController alloc] initWithEntity:entity];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <EntityHeaderViewDelegate>
- (void)handelTapImageWithIndex:(NSUInteger)idx
{
    EntityPopView * popView         = [[EntityPopView alloc] initWithFrame:CGRectZero];
    popView.deFrameSize             = CGSizeMake(kScreenWidth, kScreenHeight);
    popView.entity                  = self.entity;
    [popView setImageIndex:idx];
    [popView setNoteNumber:self.dataArrayForNote.count];
    
    if (self.note) {
        [popView setNoteBtnSelected];
    }
    
    popView.tapLikeBtn = ^(UIButton *likeBtn){
        [self likeButtonActionWithBtn:likeBtn];
    };
    
    popView.tapNoteBtn = ^(UIButton *noteBtn){
        [self noteButtonAction];
    };
    
    popView.tapBuyBtn = ^(UIButton *buyBtn){
        [self buyButtonAction];
    };
    [popView showInWindowWithAnimated:YES];
    
    [MobClick event:@"click entity image view"];
}

- (void)handleGotoEntityLikeListBtn:(id)sender
{
    EntityLikerController * vc = [[EntityLikerController alloc] initWithEntity:self.entity];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <EntityHeaderSectionViewDelegate>
- (void)TapHeaderView:(id)sender
{
    EntityHeaderSectionView * header = (EntityHeaderSectionView *)sender;
    
    switch (header.headertype) {
        case CategoryHeaderType:
        {
            GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
            [[OpenCenter sharedOpenCenter] openCategory:category];

        }
            break;
        case LikeType:
        {
            EntityLikerController * vc = [[EntityLikerController alloc] initWithEntity:self.entity];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - action
- (void)likeAction
{
    [[GKHandler sharedGKHandler] TapLikeButtonWithEntity:self.entity Button:self.likeButton];
}

- (void)openEntityNote
{
    PNoteViewController * pnvc = [[PNoteViewController alloc] initWithEntityNote:self.note];
    
    pnvc.entity = self.entity;
    
    pnvc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    pnvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    pnvc.successBlock = ^(GKNote *note) {
        if (![self.dataArrayForNote containsObject:note]) {
            [self.dataArrayForNote insertObject:note atIndex:self.dataArrayForNote.count];
        }
        
        self.note = note;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:EntityHeaderNoteType]];
        
    };
    
    //设置模态视图控制器弹出效果为淡入淡出
    [pnvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //    [self presentModalViewController:pnvc animated:YES];
    [self presentViewController:pnvc animated:YES completion:nil];
}

- (void)pokeNoteWithPokeBtn:(UIButton *)pokeBtn Note:(GKNote *)note
{
    [API pokeWithNoteId:note.noteId state:!pokeBtn.selected success:^(NSString *entityId, NSUInteger noteId, BOOL poked) {
        
        if (poked == pokeBtn.selected) {
            
        }
        else if (poked) {
            note.pokeCount = note.pokeCount + 1;
        } else {
            note.pokeCount = note.pokeCount - 1;
        }
        note.poked = poked;
        
        [MobClick event:@"poke note" attributes:@{@"note": @(note.noteId), @"status":@"success"} counter:(int)note.pokeCount];
    } failure:^(NSInteger stateCode) {
        [MobClick event:@"poke note" attributes:@{@"note":@(note.noteId), @"status":@"failure"}];
    }];
}

#pragma mark - <EntityNoteCellDelegate>
- (void)swipLeftWithContentView:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(-80., 0., view.deFrameWidth, view.deFrameHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)handleCellEditBtn:(GKNote *)note
{
    ReportViewController *vc    = [[ReportViewController alloc] init];
    vc.note = note;
    [kAppDelegate.activeVC.navigationController pushViewController:vc animated:YES];
}

- (void)tapPokeNoteBtn:(id)sender Note:(GKNote *)note
{
    UIButton * pokeBtn = (UIButton *)sender;
    if(!k_isLogin) {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self pokeNoteWithPokeBtn:pokeBtn Note:note];
        }];
    } else {
        [self pokeNoteWithPokeBtn:pokeBtn Note:note];
    }
}

#pragma mark - Button Action
- (void)likeButtonActionWithBtn:(UIButton *)btn
{
    self.likeButton = btn;
    if (!k_isLogin) {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self likeAction];
        }];
    } else {
        [self likeAction];
    }
}

//点击评论按钮
- (void)noteButtonAction
{
    if (!k_isLogin) {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self openEntityNote];
        }];
    } else {
        [self openEntityNote];
    }

//#pragma mark ------------ PNoteView ------------------------------
}

//点击分享按钮
- (void)shareButtonAction
{
    ShareController * shareVC   = [[ShareController alloc] initWithTitle:self.entity.entityName URLString:[NSString stringWithFormat:@"%@%@/",kGK_WeixinShareURL, self.entity.entityHash] Image:self.image.image];
    shareVC.type    = EntityType;
    __weak __typeof(&*self)weakSelf = self;
    shareVC.refreshBlock        = ^(){
        [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"refreshing", kLocalizedFile, nil)];
//        CGPointMake(scrollView.contentOffset.x, 0.)
        [weakSelf.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, 0.) animated:YES];
        [weakSelf refresh];
//        [weakSelf refreshRandom];
    };
    
    shareVC.tipOffBlock         = ^() {
        ReportViewController * VC = [[ReportViewController alloc] init];
        VC.entity = self.entity;
        if(!k_isLogin)
        {
            [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
//                [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
                [self.navigationController pushViewController:VC animated:YES];
            }];
        } else {
            [self.navigationController pushViewController:VC animated:YES];
//            [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
        }
    };
    [shareVC show];
}

- (void)buyButtonAction
{
    [[GKHandler sharedGKHandler] TapBuyButtonActionWithEntity:self.entity];
}

- (void)categoryButtonAction
{
    GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId": @(self.entity.categoryId)}];
    SubCategoryEntityController * VC = [[SubCategoryEntityController alloc] initWithSubCategory:category];
//    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    [self.navigationController pushViewController:VC animated:YES];
    
    [MobClick event:@"entity_forward_categoty"];
}

#pragma mark - <EntityHeaderActionViewDelegate>
- (void)tapLikeBtn:(id)sender
{
    [self likeButtonActionWithBtn:sender];
}

- (void)tapPostNoteBtn:(id)sender
{
    self.noteButton = (UIButton *)sender;
    [self noteButtonAction];
}

- (void)tapBuyBtn:(id)sender
{
    
    self.buyButton = (UIButton *)sender;
    [self buyButtonAction];
}

#pragma mark -
- (void)tapMoreBtn:(id)sender
{
    self.moreBtn = (UIButton *)sender;
    [self shareButtonAction];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.collectionView performBatchUpdates:nil completion:nil];
//         self.collectionView.deFrameLeft = 128.;
         if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight
             || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
             self.collectionView.frame = CGRectMake(128., 0., kPadScreenWitdh, kScreenHeight);
         else
             self.collectionView.frame = CGRectMake(0., 0., kPadScreenWitdh, kScreenHeight);
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
     }];
    
}

#pragma mark - 3d-touch PreviewAction
- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
//    UIPreviewAction *action = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        if (!k_isLogin)
//        {
//            [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
//                [self likeAction];
//                //                [[GKHandler sharedGKHandler] li]
//            }];
//        } else {
//            [self likeAction];
//        }
//        
//        //        [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];
//        
//    }];
    
    
#pragma mark --------------- 点击跳转至购买页 ---------------------
    UIPreviewAction *buyAction = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"buy", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        //code signing
        
        if (self.entity.purchaseArray.count > 0) {
            [[GKHandler sharedGKHandler] TapBuyButtonActionWithEntity:self.entity];
//            [MobClick event:@"purchase" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.lowestPrice];
        }
        
    }];
    
    UIPreviewAction *storeAction = [UIPreviewAction actionWithTitle:NSLocalizedStringFromTable(@"store", kLocalizedFile, nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        //code signing
        if (self.entity.purchaseArray.count > 0) {
            [[GKHandler sharedGKHandler] tapStoreButtonWithEntity:self.entity];
        }
        
    }];
    
    GKPurchase  *purchase   = self.entity.purchaseArray[0];
    if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"])
    {
        return @[buyAction, storeAction];
    } else {
        return @[buyAction];
    }
}


@end
