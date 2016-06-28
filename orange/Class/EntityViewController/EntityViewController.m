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
#import "NotePostViewController.h"
//#import "CategoryViewController.h"
#import "SubCategoryEntityController.h"

#import "EntityHeaderView.h"
#import "EntityLikeUserCell.h"
#import "EntityNoteCell.h"
#import "EntityCell.h"
#import "EntityHeaderSectionView.h"
#import "EntityHeaderActionView.h"
#import "EntityHeaderBuyView.h"
#import "EntityPopView.h"

#import "EntityLikerController.h"
#import "UIScrollView+Slogan.h"

#import "ReportViewController.h"
#import "LoginView.h"

#import "WebViewController.h"
#import "ShareView.h"
#import "PNoteViewController.h"


@interface EntityViewController ()<EntityHeaderViewDelegate, EntityHeaderSectionViewDelegate, EntityCellDelegate, EntityNoteCellDelegate, EntityHeaderActionViewDelegate,EntityHeaderBuyViewDelegate,UITextViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *noteButton;
@property (nonatomic, strong) UIButton * moreBtn;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) EntityHeaderView * header;
@property (nonatomic, strong) EntityHeaderActionView * actionView;
@property (nonatomic, strong) EntityHeaderBuyView * buyView;
//@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIView *likeUserView;
@property (nonatomic, strong) UIView * noteContentView;
@property (nonatomic, assign) BOOL flag;

//@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UIButton * postBtn;
//@property (nonatomic, strong) UIButton * buyBtn;

@property (nonatomic, strong) NSMutableArray *dataArrayForlikeUser;
@property (nonatomic, strong) NSMutableArray *dataArrayForNote;
@property (nonatomic, strong) NSMutableArray *dataArrayForRecommend;

@property(nonatomic, strong) id<ALBBItemService> itemService;

@property (strong, nonatomic) UIActionSheet * actionSheet;

/**
 * 店家id （仅限淘宝，天猫）
 */
@property (strong, nonatomic) NSString * seller_id;
//@property (nonatomic) OneSDKItemType itemType;


@property (weak, nonatomic) UIApplication * app;



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

- (instancetype)init
{
    if (self = [super init]) {
//        self.itemType = OneSDKItemType_TAOBAO1;
        self.flag = false;
        self.image = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.itemService=[[TaeSDK sharedInstance] getService:@protocol(ALBBItemService)];
    }
    return self;
}

- (instancetype)initWithEntity:(GKEntity *)entity
{
    self = [self init];
    if (self) {
        self.entity = entity;
//        self.itemService = [[TaeSDK sharedInstance] getService:@protocol(ALBBItemService)];
        
        if (self.entity.purchaseArray > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"]) {
                self.seller_id = purchase.seller;
//                DDLogError(@"seller %@", self.seller_id);
            }
        }
        
    }
    return self;
}

- (UIApplication *)app
{
    if (!_app) {
        _app = [UIApplication sharedApplication];
    }
    return _app;
}

- (CGFloat)headerHeight
{
    return [EntityHeaderView headerViewHightWithEntity:self.entity];
}

#pragma mark - View
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        EntityStickyHeaderFlowLayout * layout = [[EntityStickyHeaderFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

        _collectionView.frame = IS_IPAD ? CGRectMake(0., 0., 684, kScreenHeight) : CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight);
        
        
        if (self.app.statusBarOrientation == UIDeviceOrientationLandscapeRight || self.app.statusBarOrientation == UIDeviceOrientationLandscapeLeft)
            self.collectionView.deFrameLeft = 128.;

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}


- (UIButton *)likeButton
{
    if (!_likeButton) {
//        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40., 35)];
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(0, 0, kScreenWidth/3, 44.);
        UIImage * like = [[UIImage imageNamed:@"like"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _likeButton.tintColor = UIColorFromRGB(0xffffff);
        [_likeButton setImage:like forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        [_likeButton setTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
        _postBtn.tintColor = UIColorFromRGB(0xffffff);
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
        [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [_buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                {
                    [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    [_buyButton setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
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
                    [self.buyButton setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
                     [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                    [self.buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    break;
                case GKBuySOLDOUT:
                    self.buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
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
    } failure:^(NSInteger stateCode) {
        
    }];
}


- (void)loadView
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    backView.backgroundColor = UIColorFromRGB(0xfafafa);
    self.view = backView;
    
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.collectionView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.title = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    [self.collectionView registerClass:[EntityLikeUserCell class] forCellWithReuseIdentifier:LikeUserIdentifier];
    
    [self.collectionView registerClass:[EntityNoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderActionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderActionIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderBuyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderBuyIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier];
    
    /*
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
    self.navigationItem.rightBarButtonItems = array;
    */
    
//    {
//        UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
//        item.title =NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
//        self.navigationItem.backBarButtonItem = item;
//    }

    [self refresh];
    [self refreshRandom];

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.collectionView.frame = CGRectMake((kScreenWidth - kScreenHeight)/2, 0., kScreenHeight - kTabBarWidth, kScreenHeight);
    }
    
//    [AVAnalytics beginLogPageView:@"EntityView"];
    [MobClick beginLogPageView:@"EntityView"];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [AVAnalytics endLogPageView:@"EntityView"];
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

#pragma mark - <UICollectionViewDataSource>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self configConfigNavigationItem];
}

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
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        switch (indexPath.section) {
            case 0:
            {
                EntityHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderIdentifier forIndexPath:indexPath];
                headerView.entity = self.entity;
                headerView.delegate = self;
                return headerView;
            }
                break;

            case 1:
            {
                EntityHeaderActionView * actionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderActionIdentifier forIndexPath:indexPath];
                actionView.entity = self.entity;
                actionView.note = self.note;
                self.likeButton = actionView.likeButton;
                actionView.delegate = self;
                self.actionView = actionView;
                return actionView;
            }
                break;
            case 2:
            {
                EntityHeaderBuyView * buyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderBuyIdentifier forIndexPath:indexPath];
                buyView.entity = self.entity;
                self.likeButton = buyView.likeButton;
                buyView.delegate = self;
                self.buyView = buyView;
                return buyView;
            }
                break;

            case 4:
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                headerSection.headertype = LikeType;
                headerSection.text = [NSString stringWithFormat:@"%ld", self.entity.likeCount];
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case 5:
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                headerSection.headertype = NoteType;
                headerSection.text = [NSString stringWithFormat:@"%ld", self.dataArrayForNote.count];
                return headerSection;
            }
                break;
            case 6:
            {
                EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
                GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
                headerSection.headertype = CategoryType;
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
    }
    return reusableview;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0., 0.);
    switch (indexPath.section) {
        case 4:
            cellsize = CGSizeMake(36., 36.);
            break;
        case 5:
        {
            GKNote * note = [self.dataArrayForNote objectAtIndex:indexPath.row];
            if (IS_IPAD) {
                cellsize = CGSizeMake(684., [EntityNoteCell height:note]);
            }
            else
            {
                cellsize = CGSizeMake(kScreenWidth, [EntityNoteCell height:note]);
            }
        }
            break;
        case 6:
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
        case 4:
        {
            if (self.dataArrayForlikeUser.count != 0) {
                
                if (IS_IPHONE)
                    edge = UIEdgeInsetsMake(0., 16., 16., 16.);
                else {
                    edge = UIEdgeInsetsMake(0., 16., 16., 16.);
                }
            }
        }
            break;
        case 6:
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
        case 0:
            break;
        case 4:
            itemSpacing = 3.;
            break;
        case 6:
        {
            if (IS_IPAD)
            {
                itemSpacing = 16.;
            }else
            {
            itemSpacing = 3;
            }
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
        case 6:
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
        case 0:
            size = IS_IPAD ? CGSizeMake(684., 550.) : CGSizeMake(kScreenWidth, [EntityHeaderView headerViewHightWithEntity:self.entity]);
//            DDLogInfo(@"xxxx %f xxxxx", size.width);
            break;
        case 2:
            size = IS_IPAD ? CGSizeMake(684, 80) :  CGSizeMake(kScreenWidth, 60);
//            if (IS_IPHONE) {
//                size =  CGSizeMake(kScreenWidth, 60);
//            }
//            else
//            {
//                size =  CGSizeMake(684, 60);
//            }
            break;
        case 3:
            size = IS_IPAD ? CGSizeMake(684, 0.) : CGSizeMake(kScreenWidth, 0);
            break;
        case 4:
        {
            if (self.dataArrayForlikeUser.count != 0) {
                size =  CGSizeMake(kScreenWidth, 48.);
            }
        }
            break;
        case 5:
        {
            if (self.dataArrayForNote.count != 0) {
                size = IS_IPAD ? CGSizeMake(684, 30) : CGSizeMake(kScreenWidth, 30);
            }
        }
            break;
        default:
            size = IS_IPAD ? CGSizeMake(684., 50.) : CGSizeMake(kScreenWidth, 50);
            break;
    }
    return size;
}

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


#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

#pragma mark - <EntityHeaderViewDelegate>
- (void)handelTapImageWithIndex:(NSUInteger)idx
{
//    DDLogInfo(@"OKOKOKOK");
//    [AVAnalytics event:@"click entiyt image view"];
    [MobClick event:@"click entiyt image view"];
    EntityPopView * popView = [[EntityPopView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    popView.entity = self.entity;
    [popView setImageIndex:idx];
    [popView setNoteNumber:self.dataArrayForNote.count];
    
    if (self.note) {
        [popView setNoteBtnSelected];
    }
    popView.tapLikeBtn = ^(UIButton *likeBtn){
//        DDLogInfo(@"like btn %@", likeBtn);
        [self likeButtonActionWithBtn:likeBtn];
    };
    popView.tapNoteBtn = ^(UIButton *noteBtn){
        [self noteButtonAction];
    };
    
    popView.tapBuyBtn = ^(UIButton *buyBtn){
        [self buyButtonAction];
    };
    [popView showInWindowWithAnimated:YES];
}

#pragma mark - <EntityHeaderSectionViewDelegate>
- (void)TapHeaderView:(id)sender
{
    EntityHeaderSectionView * header = (EntityHeaderSectionView *)sender;
    
    switch (header.headertype) {
        case CategoryType:
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
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    UIButton * pokeBtn = (UIButton *)sender;
    
    [API pokeWithNoteId:note.noteId state:!pokeBtn.selected success:^(NSString *entityId, NSUInteger noteId, BOOL poked) {
        
        if (poked == pokeBtn.selected) {
            
        }
        else if (poked) {
            note.pokeCount = note.pokeCount + 1;
        } else {
            note.pokeCount = note.pokeCount - 1;
        }
        note.poked = poked;
        
//        [AVAnalytics event:@"poke note" attributes:@{@"note": @(note.noteId), @"status":@"success"} durations:(int)note.pokeCount];
        [MobClick event:@"poke note" attributes:@{@"note": @(note.noteId), @"status":@"success"} counter:(int)note.pokeCount];
    } failure:^(NSInteger stateCode) {
//        [AVAnalytics event:@"poke note" attributes:@{@"note":@(note.noteId), @"status":@"failure"}];
        [MobClick event:@"poke note" attributes:@{@"note":@(note.noteId), @"status":@"failure"}];
    }];
}


//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NSLocalizedStringFromTable(@"tip off", kLocalizedFile, nil);
//}


#pragma mark - Action
- (void)likeButtonAction
{
    [self likeButtonActionWithBtn:nil];
}

- (void)likeButtonActionWithBtn:(UIButton *)btn
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
//    [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];
    [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
    
    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
        if (liked == self.likeButton.selected) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
            image.frame = self.likeButton.imageView.frame;
            [self.likeButton addSubview:image];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
                image.deFrameTop = image.deFrameTop - 10;
                image.alpha = 0.1;
            }completion:^(BOOL finished) {
                [image removeFromSuperview];
            }];
            ////[SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        }
        
        
        self.likeButton.selected = liked;
        self.entity.liked = liked;
        
        DDLogInfo(@"entity view %d", self.likeButton.selected);

        
        if (liked) {
            self.entity.likeCount += 1;
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
            image.frame = self.likeButton.imageView.frame;
            [self.likeButton addSubview:image];
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
                image.deFrameTop = image.deFrameTop - 10;
                image.alpha = 0.1;
            }completion:^(BOOL finished) {
                [image removeFromSuperview];
            }];
            
            if ([Passport sharedInstance].user) {
                [self.dataArrayForlikeUser insertObject:[Passport sharedInstance].user atIndex:0];
            }
            ////[SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        } else {
            [self.dataArrayForlikeUser removeObject:[Passport sharedInstance].user];
            
            self.entity.likeCount -= 1;
            [SVProgressHUD dismiss];
        }
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:4]];
        if (btn){
            btn.selected = self.entity.liked;
            [btn setTitle:[NSString stringWithFormat:@"%ld",self.entity.likeCount] forState:UIControlStateNormal];
        }
        [self setNavBarButton:self.flag];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"喜爱失败"];
    }];
}

//点击评论按钮
- (void)noteButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc] init];
        [view show];
        return;
    }

#pragma mark ------------ PNoteView ------------------------------
    
    PNoteViewController * pnvc = [[PNoteViewController alloc]init];
    
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


//点击分享按钮
- (void)shareButtonAction
{
    
    
        ShareView * view = [[ShareView alloc]initWithTitle:self.entity.entityName SubTitle:@"" Image:self.image.image URL:[NSString stringWithFormat:@"%@%@/",kGK_WeixinShareURL,self.entity.entityHash]];
        view.type = @"entity";
        view.entity = self.entity;
        __weak __typeof(&*self)weakSelf = self;
        
        view.tapRefreshButtonBlock = ^(){
            
            //        [weakSelf.collectionView setScrollsToTop:YES];
            //        [SVProgressHUD showImage:nil status:@"\U0001F603 刷新成功"];
            [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
            [weakSelf.collectionView setContentOffset:CGPointMake(0., -self.header.deFrameHeight) animated:YES];
            [weakSelf refresh];
            [weakSelf refreshRandom];
        };
        [view show];
}

- (void)buyButtonAction
{
    if (self.entity.purchaseArray.count >0) {
        GKPurchase * purchase = self.entity.purchaseArray[0];
//        NSLog(@"%@ %@", purchase.origin_id, purchase.source);
        if ([purchase.source isEqualToString:@"taobao.com"] || [purchase.source isEqualToString:@"tmall.com"])
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
        } else
            [self showWebViewWithTaobaoUrl:[purchase.buyLink absoluteString]];
        
//        [AVAnalytics event:@"buy action" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.lowestPrice];
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

//    GKWebVC * VC = [GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:url]];
    WebViewController *VC =[[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    VC.title = @"宝贝详情";
    if (IS_IPHONE) VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)categoryButtonAction
{
//    CategoryViewController * VC = [[CategoryViewController alloc]init];
//    VC.category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
//    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId": @(self.entity.categoryId)}];
    SubCategoryEntityController * VC = [[SubCategoryEntityController alloc] initWithSubCategory:category];
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
    
//    [AVAnalytics event:@"entity_forward_categoty"];
    [MobClick event:@"entity_forward_categoty"];
}

#pragma mark - <EntityHeaderActionViewDelegate>
- (void)tapLikeBtn:(id)sender
{
    self.likeButton = (UIButton *)sender;
    [self likeButtonAction];
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

- (void)tapMoreBtn:(id)sender
{
    self.moreBtn = (UIButton *)sender;
    if (IS_IPHONE) {
        [self shareButtonAction];
    }
//    else
//    {
//        CGRect frame = self.moreBtn.frame;
//        frame.origin.y += 20.f;
//        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) destructiveButtonTitle:nil otherButtonTitles:@"分享到微信",@"分享到朋友圈",@"分享到新浪微博", NSLocalizedStringFromTable(@"tip off", kLocalizedFile, nil), nil];
//        self.actionSheet.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
//        [self.actionSheet showFromRect:frame inView:self.navigationController.view animated:NO];
//    }
}

//#pragma mark - <UIActionSheetDelegate>
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //    DDLogInfo(@"btn index %lu", buttonIndex);
//    switch (buttonIndex) {
//        case 0:
//        {
////            [self wxShare:0];
//        }
//            break;
//        case 1:
////            [self wxShare:1];
//            break;
//        case 2:
////            [self weiboShare];
//            break;
//        case 3:
//            
//            //            [self.actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
//            //            [self openReportVC];
//            break;
//        default:
//            break;
//    }
//}



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
            [button addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
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


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.collectionView performBatchUpdates:nil completion:nil];
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

#pragma mark - ConfigNavigationItem
-(void)configConfigNavigationItem
{
    CGRect a =  [self.actionView.superview convertRect:self.actionView.frame toView:kAppDelegate.window];
    
    if (a.origin.y <= 30) {
        if (self.flag == YES) {
            return;
        }
        else
        {
            self.flag = YES;
        }
    }
    else
    {
        if (self.flag == NO) {
            return;
        }
        else{
            self.flag = NO;
        }
    }
    [self setNavBarButton:self.flag];
}


@end
