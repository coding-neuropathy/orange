//
//  EntityViewController.m
//  orange
//
//  Created by huiter on 15/1/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityViewController.h"
//#import "API.h"

#import "EntityStickyHeaderFlowLayout.h"
#import "UserViewController.h"
#import "SubCategoryEntityController.h"

#import "EntityHeaderView.h"
#import "EntityLikeUserCell.h"
#import "EntityNoteCell.h"
#import "EntityCell.h"
#import "EntityHeaderSectionView.h"
#import "EntityHeaderActionView.h"
#import "EntityHeaderBuyView.h"
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
    EntityHeaderBuyType,
    EntityHeaderLikeType = 4,
    EntityHeaderNoteType,
    EntityHeaderCategoryType,
};

@interface EntityViewController ()<EntityHeaderViewDelegate, EntityHeaderSectionViewDelegate,
                                    EntityCellDelegate, EntityNoteCellDelegate, EntityHeaderActionViewDelegate,
                                     EntityHeaderBuyViewDelegate>

@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *noteButton;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) EntityHeaderView * header;
@property (nonatomic, strong) EntityHeaderActionView * actionView;
@property (nonatomic, strong) EntityHeaderBuyView * buyView;
//@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIView *likeUserView;
@property (nonatomic, strong) UIView * noteContentView;
@property (nonatomic, assign) BOOL flag;


@property (nonatomic, strong) UIButton *postBtn;

@property (nonatomic, strong) NSMutableArray *dataArrayForlikeUser;
@property (nonatomic, strong) NSMutableArray *dataArrayForNote;
@property (nonatomic, strong) NSMutableArray *dataArrayForRecommend;

@property(nonatomic, strong) id<ALBBItemService> itemService;

@property (strong, nonatomic) UIActionSheet * actionSheet;

/**
 * 店家id （仅限淘宝，天猫）
 */
@property (strong, nonatomic) NSString * seller_id;


//@property (strong, nonatomic) SloppySwiper *swiper;

@end

@implementation EntityViewController
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

static NSString * LikeUserIdentifier = @"LikeUserCell";
static NSString * NoteCellIdentifier = @"NoteCell";
static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * const EntityReuseHeaderIdentifier = @"EntityHeader";
static NSString * const EntityReuseHeaderSectionIdentifier = @"EntityHeaderSection";
static NSString * const EntityReuseHeaderActionIdentifier = @"EntityHeaderAction";
static NSString * const EntityReuseHeaderBuyIdentifier = @"EntityHeaderBuy";
static NSString * const EntityReuseFooterNoteIdenetifier = @"EntityNoteFooter";

- (instancetype)init
{
    if (self = [super init]) {
//        self.itemType = OneSDKItemType_TAOBAO1;
        self.flag           = false;
        self.image          = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.itemService    = [[ALBBSDK sharedInstance] getService:@protocol(ALBBItemService)];
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
        
//        [_collectionView setContentOffset:CGPointMake(0., 64.)];
//        [_collectionView.collectionViewLayout collectionViewContentSize];

        _collectionView.delegate                = self;
        _collectionView.dataSource              = self;
        _collectionView.backgroundColor         = [UIColor colorFromHexString:@"#ffffff"];
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


- (UIButton *)likeButton
{
    if (!_likeButton) {
//        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40., 35)];
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(0, 0, kScreenWidth / 3, 44.);
        UIImage * like = [[UIImage imageNamed:@"like"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _likeButton.tintColor = [UIColor colorFromHexString:@"#ffffff"];
        [_likeButton setImage:like forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        [_likeButton setTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeButton addTarget:self action:@selector(likeButtonActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (self.entity.isLiked) {
            _likeButton.selected = YES;
        }
    }
    return _likeButton;
}

//点评按钮
- (UIButton *)postBtn
{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _postBtn.frame = CGRectMake(0., 0.,  kScreenWidth/3, 44.);
        UIImage * image = [[UIImage imageNamed:@"post note"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _postBtn.tintColor = [UIColor colorFromHexString:@"#ffffff"];
        [_postBtn setImage:image forState:UIControlStateNormal];
        //[_postBtn setTitle:NSLocalizedStringFromTable(@"note", kLocalizedFile, nil) forState:UIControlStateNormal];
        _postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_postBtn addTarget:self action:@selector(noteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE) {
            _buyButton.frame = CGRectMake(0., 0., kScreenWidth/3, 44.);
        }
        else
        {
            _buyButton.frame = CGRectMake(0., 0., kScreenWidth - kTabBarWidth/3, 44.);
        }
        _buyButton.layer.masksToBounds = YES;
        _buyButton.layer.cornerRadius = 0;
        _buyButton.backgroundColor = UIColorFromRGB(0x2a5393);
        _buyButton.titleLabel.font = [UIFont fontWithName:@"Georgia" size:16.f];
        [_buyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_buyButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                {
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    [_buyButton setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
                    _buyButton.backgroundColor = [UIColor clearColor];
                    _buyButton.enabled = NO;
                }
                    break;
                case GKBuySOLDOUT:
                {
                    _buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                }
                    break;
                default:
                {
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
                }
                    break;
            }
            
        }

    }
    return _buyButton;
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
    [API getEntityDetailWithEntityId:self.entity.entityId success:^(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray) {
        [self.image sd_setImageWithURL:self.entity.imageURL_640x640];
        self.entity = entity;
//        self.header.entity = entity;
        
        self.dataArrayForlikeUser = [NSMutableArray arrayWithArray:likeUserArray];
        self.dataArrayForNote = [NSMutableArray arrayWithArray:noteArray];
        for (GKNote *note in self.dataArrayForNote) {
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
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD dismiss];
    }];
}

- (void)refreshRandom
{
    
    [API getRandomEntityListByCategoryId:self.entity.categoryId
                                entityId:self.entity.entityId
                                   count:9 success:^(NSArray *entityArray) {
                                       self.dataArrayForRecommend = [NSMutableArray arrayWithArray:entityArray];
                                       [self.collectionView reloadData];
                                   } failure:^(NSInteger stateCode) {
                                       
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
    
    [self.view addSubview:self.collectionView];
    
    self.title = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    
    [self.collectionView registerClass:[EntityLikeUserCell class] forCellWithReuseIdentifier:LikeUserIdentifier];
    
    [self.collectionView registerClass:[EntityNoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
    
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderIdentifier];
    [self.collectionView registerClass:[EntityHeaderActionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderActionIdentifier];
    [self.collectionView registerClass:[EntityHeaderBuyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderBuyIdentifier];
    [self.collectionView registerClass:[EntityHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier];
    
//    [self.collectionView registerClass:[EntityNoteFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:EntityReuseFooterNoteIdenetifier];

    [self refresh];
    [self refreshRandom];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
//    self.title = entity.entityName;
    [self addObserver];
}

- (void)setNote:(GKNote *)note
{
    _note = note;
    self.actionView.note = note;
}

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
    } else {
//        [self configConfigNavigationItem];
    }

}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 4:
        {
            count = self.dataArrayForlikeUser.count;
            if ((IS_IPHONE_4_OR_LESS || IS_IPHONE_5) && count > 7) {
                count = 7;
            }
            if (IS_IPHONE_6 && count > 8) {
                count = 8;
            }
            if (IS_IPHONE_6P && count > 9) {
                count = 9;
            }
        }
            break;
        case 5:
            count = self.dataArrayForNote.count;
            break;
        case 6:
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
        case 4:
        {
            EntityLikeUserCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:LikeUserIdentifier forIndexPath:indexPath];
            cell.user = [self.dataArrayForlikeUser objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case 5:
        {
            EntityNoteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
            cell.note = [self.dataArrayForNote objectAtIndex:indexPath.row];
            cell.delegate = self;
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
                if ( IS_IPAD)
                    headerView.entity = self.entity;
                else
                    [headerView setEntity:self.entity WithLikeUser:self.dataArrayForlikeUser];
                
                headerView.delegate = self;
                headerView.actionDelegate   = [GKHandler sharedGKHandler];
                return headerView;
            }
                break;

            case EntityHeaderActionType:
            {
                EntityHeaderActionView * actionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderActionIdentifier forIndexPath:indexPath];
                actionView.entity = self.entity;
                actionView.note = self.note;
                self.likeButton = actionView.likeButton;
                actionView.delegate = [GKHandler sharedGKHandler];
                actionView.headerDelegate = self;
                self.actionView = actionView;
                return actionView;
            }
                break;
            case EntityHeaderBuyType:
            {
                EntityHeaderBuyView * buyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderBuyIdentifier forIndexPath:indexPath];
                buyView.entity = self.entity;
                self.likeButton = buyView.likeButton;
                buyView.delegate = self;
                self.buyView = buyView;
                return buyView;
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
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                return headerSection;
            }
                break;
        }
    } else {
//        EntityNoteFooterView * footerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:EntityReuseFooterNoteIdenetifier forIndexPath:indexPath];
//        footerSection.openPostNote = ^(){
//            [self noteButtonAction];
//        };
//        return footerSection;
    }
    return reusableview;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0., 0.);
    switch (indexPath.section) {
        case EntityHeaderLikeType:
            cellsize = IS_IPAD ? CGSizeMake(36., 36.) : CGSizeMake(0., 0.);
            break;
        case EntityHeaderNoteType:
        {
            GKNote * note = [self.dataArrayForNote objectAtIndex:indexPath.row];
            cellsize = CGSizeMake(self.collectionView.deFrameWidth, [EntityNoteCell height:note]);
        }
            break;
        case EntityHeaderCategoryType:
        {
            cellsize = IS_IPAD ? CGSizeMake(204., 204.) : CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
        }
            break;
            
        default:
            break;
    }
    return cellsize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0, 0.);
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
                edge = UIEdgeInsetsMake(0., 20., 0, 20.);
            }
        }
            break;
        default:
//            if (IS_IPAD) edge = UIEdgeInsetsMake(0., 128., 0, 128.);
            break;
    }
    return edge;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
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
            //            itemSpacing = 0;
            break;
    }
    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0;
    switch (section) {
        case EntityHeaderCategoryType:
        {
            if (IS_IPHONE) {
                spacing = 3.;
            }
            else
            {
                spacing = 16.;
            }
             
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
        case 1:
//            size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 50.) : CGSizeMake(kScreenWidth, 0.);
            break;
        case 2:
//            size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 80) :  CGSizeMake(kScreenWidth, 0);
            break;
        case 3:
            size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 0.) : CGSizeMake(kScreenWidth, 0);
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
                size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 30) : CGSizeMake(kScreenWidth, 48);
            }
        }
            break;
        default:
            size = IS_IPAD ? CGSizeMake(kPadScreenWitdh, 50.) : CGSizeMake(kScreenWidth, 48.);
            break;
    }
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    CGSize size = CGSizeMake(0., 0.);
//    switch (section) {
//        case EntityHeaderNoteType:
//            if (IS_IPHONE) size = CGSizeMake(kScreenWidth, 88.);
//            break;
//            
//        default:
//            break;
//    }
//    
//    return size;
//}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 4:
        {
            UserViewController * VC = [[UserViewController alloc]init];
            VC.user = [self.dataArrayForlikeUser objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:VC animated:YES];
            [MobClick event:@"entity_forward_user"];
        }
            break;
        case 5:
        {
            
        }
            break;
            
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
        case 6:
        {
            if (iOS10) {
                EntityViewController * vc = [[EntityViewController alloc] initWithEntity:cell.entity];
                vc.preferredContentSize = CGSizeMake(0., 0.);
                previewingContext.sourceRect = cell.frame;
                vc.hidesBottomBarWhenPushed = YES;
                return vc;
            } else {
                EntityPreViewController * vc    = [[EntityPreViewController alloc] initWithEntity:cell.entity PreImage:cell.imageView.image];
                vc.preferredContentSize = CGSizeMake(0., 0.);
                previewingContext.sourceRect = cell.frame;
            
                vc.baichuanblock = ^(GKPurchase * purchase) {
                    NSNumber * _itemId = [[[NSNumberFormatter alloc] init] numberFromString:purchase.origin_id];
                    ALBBTradeTaokeParams * taoKeParams = [[ALBBTradeTaokeParams alloc]init];
                    taoKeParams.pid = kGK_TaobaoKe_PID;
                    [self.itemService showTaoKeItemDetailByItemId:self
                                                   isNeedPush:YES
                                            webViewUISettings:nil
                                                       itemId:_itemId
                                                     itemType:1
                                                       params:nil
                                                  taoKeParams:taoKeParams
                                  tradeProcessSuccessCallback:_tradeProcessSuccessCallback
                                   tradeProcessFailedCallback:_tradeProcessFailedCallback];
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
    PNoteViewController * pnvc = [[PNoteViewController alloc] init];
    
    pnvc.entity = self.entity;
    pnvc.note = self.note;
    
    pnvc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    pnvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    pnvc.successBlock = ^(GKNote *note) {
        if (![self.dataArrayForNote containsObject:note]) {
            [self.dataArrayForNote insertObject:note atIndex:self.dataArrayForNote.count];
        }
        
        self.note = note;
        [self.collectionView reloadData];
        
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
    ReportViewController * vc = [[ReportViewController alloc] init];
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
        [weakSelf refreshRandom];
    };
    
    shareVC.tipOffBlock         = ^() {
        ReportViewController * VC = [[ReportViewController alloc] init];
        VC.entity = self.entity;
        if(!k_isLogin)
        {
            [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
                [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
            }];
        } else {
            [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
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
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    
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


- (void)setNavBarButton:(BOOL)flag
{
    if (flag) {
        NSMutableArray * array = [NSMutableArray array];
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
            [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            button.backgroundColor = [UIColor clearColor];
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
            [array addObject:item];
        }
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
            [button setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(noteButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            button.backgroundColor = [UIColor clearColor];
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
            [array addObject:item];
        }
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 44)];
            [button setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(tapLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            button.backgroundColor = [UIColor clearColor];
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
            [array addObject:item];
        
            button.selected = self.entity.liked;
        }
        [self.navigationItem setRightBarButtonItems:array animated:YES];
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:nil animated:NO];
    }
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

#pragma mark - ConfigNavigationItem
-(void)configConfigNavigationItem
{
//    CGRect a =  [self.actionView.superview convertRect:self.actionView.frame toView:kAppDelegate.window];
//    
//    if (a.origin.y <= 30) {
//        if (self.flag == YES) {
//            return;
//        }
//        else
//        {
//            self.flag = YES;
//        }
//    }
//    else
//    {
//        if (self.flag == NO) {
//            return;
//        }
//        else{
//            self.flag = NO;
//        }
//    }
//    [self setNavBarButton:self.flag];
}


@end
