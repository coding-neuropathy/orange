//
//  EntityViewController.m
//  orange
//
//  Created by huiter on 15/1/24.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityViewController.h"
#import "API.h"
//#import "NoteCell.h"
//#import "EntityThreeGridCell.h"
//#import "CSStickyHeaderFlowLayout.h"
#import "UserViewController.h"
#import "NotePostViewController.h"
#import "CategoryViewController.h"

#import "WXApi.h"
//#import "GKWebVC.h"
#import "EntityLikeUserCell.h"
#import "EntityNoteCell.h"
#import "EntityCell.h"
#import "EntityHeaderSectionView.h"

#import "EntityLikerController.h"
#import "UIScrollView+Slogan.h"

#import "ReportViewController.h"
#import "LoginView.h"
#import "IBActionSheet.h"
#import "EntityHeaderView.h"
#import "WebViewController.h"
#import "ShareView.h"


@interface EntityViewController ()<IBActionSheetDelegate, EntityHeaderSectionViewDelegate, EntityCellDelegate, EntityNoteCellDelegate>

@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *noteButton;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) EntityHeaderView * header;
//@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIView *likeUserView;
@property (nonatomic, strong) UIView * noteContentView;

//@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UIButton * postBtn;
//@property (nonatomic, strong) UIButton * buyBtn;

@property (nonatomic, strong) NSMutableArray *dataArrayForlikeUser;
@property (nonatomic, strong) NSMutableArray *dataArrayForNote;
@property (nonatomic, strong) NSMutableArray *dataArrayForRecommend;

@property(nonatomic, strong) id<ALBBItemService> itemService;

/**
 * 店家id （仅限淘宝，天猫）
 */
@property (strong, nonatomic) NSString * seller_id;
//@property (nonatomic) OneSDKItemType itemType;



@end

@implementation EntityViewController
{
    tradeProcessSuccessCallback _tradeProcessSuccessCallback;
    tradeProcessFailedCallback _tradeProcessFailedCallback;
}

static NSString * LikeUserIdentifier = @"LikeUserCell";
static NSString * NoteCellIdentifier = @"NoteCell";
static NSString * EntityCellIdentifier = @"EntityCell";
static NSString * const EntityReuseHeaderSectionIdentifier = @"EntityHeaderSection";
//static NSString * const EntityReuseHeaderActionIdentifier = @"EntityHeaderAction";

- (instancetype)init
{
    if (self = [super init]) {
//        self.itemType = OneSDKItemType_TAOBAO1;
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

- (CGFloat)headerHeight
{
    return [EntityHeaderView headerViewHightWithEntity:self.entity];
}

#pragma mark - View
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight- kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
        
        _collectionView.contentInset = UIEdgeInsetsMake([self headerHeight], 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

- (EntityHeaderView *)header
{
    if (!_header) {
        _header = [[EntityHeaderView alloc] initWithFrame:CGRectMake(0, - [self headerHeight], kScreenWidth, [self headerHeight] )];
//        _header.delegate = self;
        _header.entity = self.entity;
        _header.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _header;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
//        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40., 35)];
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(0, 0, 40., 48.);
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.entity.isLiked) {
            _likeButton.selected = YES;
        }
    }
    return _likeButton;
}

- (UIButton *)postBtn
{
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _postBtn.frame = CGRectMake(0., 0., 40., 40.);
        [_postBtn setImage:[UIImage imageNamed:@"post note"] forState:UIControlStateNormal];
//        UIImage * image = [UIImage imageWithIcon:@"post note" backgroundColor:[UIColor clearColor] iconColor:UIColorFromRGB(0x414243) fontSize:20.];
//        [_postBtn setImage:image forState:UIControlStateNormal];
        [_postBtn addTarget:self action:@selector(noteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.frame = CGRectMake(0., 0., 129., 35.);
        _buyButton.layer.masksToBounds = YES;
        _buyButton.layer.cornerRadius = 4;
        _buyButton.backgroundColor = UIColorFromRGB(0x427ec0);
        _buyButton.titleLabel.font = [UIFont fontWithName:@"Georgia" size:16.f];
        [_buyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_buyButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [_buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                {

                    
                    _buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
//                    NSString * priceString = [NSString stringWithFormat:@"%@ ¥ %0.2f", NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil), self.entity.lowestPrice];
//                    CGFloat width = [priceString widthWithLineWidth:0. Font:_buyButton.titleLabel.font];
                
//                    _buyButton.frame = CGRectMake(0., 0., width + 30., 35.);
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    DDLogError(@"okokoko ");
                    _buyButton.enabled = NO;
                }
                    break;
                case GKBuySOLDOUT:
                {
                    _buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
//                    NSString * priceString = [NSString stringWithFormat:@"%@ ¥ %0.2f", NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil), self.entity.lowestPrice];
//                    CGFloat width = [priceString widthWithLineWidth:0. Font:_buyButton.titleLabel.font];
                    
//                    _buyButton.frame = CGRectMake(0., 0., width + 30., 35.);
                    [_buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                }
                    break;
                default:
                    [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
                    break;
            }
            
        }
//        [_buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
    }
    return _buyButton;
}

- (void)configToolbar
{
//    self.navigationController.toolbar.clipsToBounds = YES;
    self.navigationController.toolbar.barTintColor = UIColorFromRGB(0xffffff);
    self.navigationController.toolbar.layer.borderWidth = 0.5;
    self.navigationController.toolbar.layer.borderColor = UIColorFromRGB(0xcacaca).CGColor;
    
    for (UIView * view in self.navigationController.toolbar.subviews) {
        if ([view  isKindOfClass:[UIImageView class]]&&![view isKindOfClass:[NSClassFromString(@"_UIToolbarBackground") class]]) {
            view.alpha =0;
        }
    }
    
    //[self.navigationController.toolbar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(kScreenWidth, 1)] forToolbarPosition:UIBarPositionAny];
    
    UIBarButtonItem * likeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    UIBarButtonItem * postBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.postBtn];
    UIBarButtonItem * buyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.buyButton];
    
    UIBarButtonItem * fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = kScreenWidth - 50. - self.buyButton.deFrameWidth - 80.;
    
    self.toolbarItems = @[likeBarBtn, postBarBtn, fixedItem, buyBarBtn];
}

#pragma mark - get entity data
- (void)refresh
{
    [API getEntityDetailWithEntityId:self.entity.entityId success:^(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray) {
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
//        DDLogError(@"buy %@", self.entity.purchaseArray[0]);
//        GKPurchase * purchase = self.entity.purchaseArray[0];
//        DDLogError(@"%d", purchase.status);
        if (self.entity.purchaseArray.count > 0) {
            GKPurchase * purchase = self.entity.purchaseArray[0];
            switch (purchase.status) {
                case GKBuyREMOVE:
                    self.buyButton.enabled = NO;
                    self.buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
                    [self.buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    break;
                case GKBuySOLDOUT:
                    self.buyButton.backgroundColor = UIColorFromRGB(0x9d9e9f);
                    [self.buyButton setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                    break;
                default:
                    [self.buyButton setTitle:[NSString stringWithFormat:@"¥ %0.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
                    break;
            }
            
        }

        [self.collectionView reloadData];
        //        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        
    }];
}

- (void)loadView
{
    self.view = self.collectionView;
//    [super loadView];
    
//    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[EntityLikeUserCell class] forCellWithReuseIdentifier:LikeUserIdentifier];
    
    [self.collectionView registerClass:[EntityNoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityCellIdentifier];
    
    [self.collectionView registerClass:[EntityHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier];
    
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
    
//    self.navigationController.toolbar.translucent = NO;
    self.title = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    [self.collectionView addSubview:self.header];
    [self configToolbar];
    
    
    [API getRandomEntityListByCategoryId:self.entity.categoryId
                                  entityId:self.entity.entityId
                                     count:9 success:^(NSArray *entityArray) {
//                                         DDLogInfo(@"%@", entityArray);
                                         self.dataArrayForRecommend = [NSMutableArray arrayWithArray:entityArray];
                                         [self.collectionView reloadData];
                                     } failure:^(NSInteger stateCode) {
                                         
                                     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"EntityView"];
    [MobClick beginLogPageView:@"EntityView"];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"EntityView"];
    [MobClick endLogPageView:@"EntityView"];
    self.navigationController.toolbarHidden = YES;
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



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.dataArrayForNote) {
        [self refresh];
    }
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
//    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addSloganView];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 1:
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
        case 2:
            count = self.dataArrayForNote.count;
            break;
        case 3:
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
        case 1:
        {
            EntityLikeUserCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:LikeUserIdentifier forIndexPath:indexPath];
            cell.user = [self.dataArrayForlikeUser objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case 2:
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
        EntityHeaderSectionView * headerSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntityReuseHeaderSectionIdentifier forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
                GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(self.entity.categoryId)}];
                headerSection.headertype = CategoryType;
                headerSection.text = category.categoryName;
                headerSection.delegate = self;
                return headerSection;
            }
                break;
            case 1:
                headerSection.headertype = LikeType;
                headerSection.text = [NSString stringWithFormat:@"%ld", self.entity.likeCount];
                headerSection.delegate = self;
                return headerSection;
                break;
            case 2:
                headerSection.headertype = NoteType;
                headerSection.text = [NSString stringWithFormat:@"%ld", self.dataArrayForNote.count];
                return headerSection;
                break;
            case 3:
            {
                headerSection.headertype = RecommendType;
                headerSection.text = @"recommendation";
                return headerSection;
            }
                break;
            default:
                return headerSection;
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
        case 1:
            cellsize = CGSizeMake(36., 36.);
            break;
        case 2:
        {
            CGFloat height = [EntityNoteCell height:[self.dataArrayForNote objectAtIndex:indexPath.row]];
            cellsize = CGSizeMake(kScreenWidth, height);
        }
            break;
        case 3:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                cellsize = CGSizeMake(100., 100.);
            } else if (IS_IPHONE_6) {
                cellsize = CGSizeMake(110., 110.);
            } else {
                cellsize = CGSizeMake(120., 120.);
            }
            
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
        case 0:
            
            break;
        case 1:
        {
            if (self.dataArrayForlikeUser.count != 0) {
                edge = UIEdgeInsetsMake(0., 16., 16., 16.);
            }
        }
            break;
        case 3:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                edge =  UIEdgeInsetsMake(5., 5., 5, 5.);
            } else if (IS_IPHONE_6) {
                edge = UIEdgeInsetsMake(10., 10., 10., 10.);
            } else {
                edge = UIEdgeInsetsMake(15., 15., 15., 15.);
            }
        }
            break;
        default:
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
        case 1:
            itemSpacing = 3.;
            break;
        case 3:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                itemSpacing = 5.;
            } else if (IS_IPHONE_6) {
                itemSpacing = 10.;
            } else {
                itemSpacing = 10.;
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
        case 3:
        {
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                spacing = 5.;
            } else if (IS_IPHONE_6) {
                spacing = 10.;
            } else {
                spacing = 10.;
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
        case 3:
            size = CGSizeMake(kScreenWidth, 50.);
            break;
        case 1:
        {
            if (self.dataArrayForlikeUser.count != 0) {
                size =  CGSizeMake(kScreenWidth, 48.);
            }
        }
            break;
        case 2:
        {
            if (self.dataArrayForNote.count != 0) {
                size = CGSizeMake(kScreenWidth, 30);
            } else {
                
            }
        }
            break;
        default:
            size =  CGSizeMake(kScreenWidth, 30);
            break;
    }
    return size;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            UserViewController * VC = [[UserViewController alloc]init];
            VC.user = [self.dataArrayForlikeUser objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:VC animated:YES];
            
            [AVAnalytics event:@"entity_forward_user"];
            [AVAnalytics event:@"entity_forward_user"];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
//    GKEntity * entity = [self.dataArrayForRecommend objectAtIndex:indexPath.row];
    [[OpenCenter sharedOpenCenter] openEntity:entity];
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
//        case ShopType:
//        {
//            
//        }
        default:
            break;
    }
}

#pragma mark - <EntityNoteCellDelegate>
- (void)swipLeftWithContentView:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(-80, 0., view.deFrameWidth, view.deFrameHeight);
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
        
        [AVAnalytics event:@"poke note" attributes:@{@"note": @(note.noteId), @"status":@"success"} durations:(int)note.pokeCount];
        [MobClick event:@"poke note" attributes:@{@"note": @(note.noteId), @"status":@"success"} counter:(int)note.pokeCount];
    } failure:^(NSInteger stateCode) {
        [AVAnalytics event:@"poke note" attributes:@{@"note":@(note.noteId), @"status":@"failure"}];
        [MobClick event:@"poke note" attributes:@{@"note":@(note.noteId), @"status":@"failure"}];
    }];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedStringFromTable(@"tip off", kLocalizedFile, nil);
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

//#pragma mark
//#pragma mark - Entity Header View Delegate
//- (void)TapLikeBtnAction:(id)sender
//{
//    self.likeButton = (UIButton *)sender;
//    [self likeButtonAction];
//}
//
//- (void)TapBuyBtnAction:(id)sender
//{
//    self.buyButton = (UIButton *)sender;
//    [self buyButtonAction];
//}

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
    
    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
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
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"喜爱失败"];
    }];
}

- (void)noteButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc] init];
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
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
//        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)shareButtonAction
{
    
    ShareView * view = [[ShareView alloc]initWithTitle:self.entity.entityName SubTitle:@"" Image:self.image.image URL:[NSString stringWithFormat:@"%@%@/",kGK_WeixinShareURL,self.entity.entityHash]];
    view.entity = self.entity;
    view.tapRefreshButtonBlock = ^(){
        [self.collectionView setScrollsToTop:YES];
        [self refresh];
    };
    [view show];
//    return;
    /*
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
     */

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

//    GKWebVC * VC = [GKWebVC linksWebViewControllerWithURL:[NSURL URLWithString:url]];
    WebViewController *VC =[[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    VC.title = @"宝贝详情";
    VC.hidesBottomBarWhenPushed = YES;
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
        
        if(!k_isLogin)
        {
            LoginView * view = [[LoginView alloc]init];
            [view show];
            return;
        }
        ReportViewController * VC = [[ReportViewController alloc] init];
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
    DDLogInfo(@"note %@", self.note.text);
    if (buttonIndex == 1) {
        [API deleteNoteByNoteId:self.note.noteId success:^{
            __block NSInteger noteIndex = -1;
//            DDLogInfo(@"okoko");
            [self.dataArrayForNote enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GKNote * note = obj;
                if (note.noteId == self.note.noteId) {
                    noteIndex = idx;
//                    if (noteIndex)
                    [self.dataArrayForNote removeObjectAtIndex:idx];
                    self.note = nil;
//                    [self.tableView reloadData];
//                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];

                }
//                if (stop) {
//                    GKNote *note = obj;
//                    DDLogInfo(@"note %ld", note.noteId);
//                    if (note.noteId == self.note.noteId) {
//                        noteIndex = (NSInteger)idx;
//                    }
//                    DDLogInfo(@"noteindex %ld", self.note.noteId);
//                    if (noteIndex != -1) {
//                        [self.dataArrayForNote removeObjectAtIndex:noteIndex];
//                        DDLogInfo(@"note array %@", self.dataArrayForNote);
////                        DDLogInfo(@"del %@", [NSIndexPath indexPathForRow:noteIndex inSection:0]);
//                        [self.tableView reloadData];
////                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:noteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    }
//                    self.note = nil;
//                }
            }];
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
    if(scene == 1)
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
        if (scene == 1) {
            [AVAnalytics event:@"share entity to moments" attributes:@{@"entity":self.entity.entityName}];
            [MobClick event:@"share entity to moments" attributes:@{@"entity":self.entity.entityName}];
        } else {
            [AVAnalytics event:@"share entity to wechat" attributes:@{@"entity":self.entity.entityName}];
            [MobClick event:@"share entity to wechat" attributes:@{@"entity":self.entity.entityName}];
        }
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
            
            [AVAnalytics event:@"share to entity to weibo" attributes:@{@"entity":self.entity.entityName}];
            [MobClick event:@"share to entity to weibo" attributes:@{@"entity":self.entity.entityName}];
        }
    }];
}

@end
