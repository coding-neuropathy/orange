//
//  UserLikeViewController.m
//  orange
//
//  Created by 谢家欣 on 15/10/20.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserLikeViewController.h"
#import "EntityCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "UserEntityCategoryController.h"


@protocol UserLikeHeaderSectionViewDelegate <NSObject>
- (void)TapSection:(id)sender;
@end

@interface UserLikeHeaderSectionView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * indicatorLable;
@property (strong, nonatomic) GKCategory * category;
@property (strong, nonatomic) NSString * language;

@property (weak, nonatomic) id <UserLikeHeaderSectionViewDelegate> delegate;
//@property (strong, nonatomic) NSString * title;

@end

@interface UserLikeViewController () <EntityCellDelegate, UserLikeHeaderSectionViewDelegate>

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) NSMutableArray * likeEntities;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (nonatomic, assign) NSTimeInterval likeTimestamp;
@property (assign, nonatomic) NSInteger pageSize;
@property (strong, nonatomic) GKCategory * category;

@property (strong, nonatomic) UserLikeHeaderSectionView * headerSectionView;


// for ipad
@property (strong, nonatomic) UIButton * categoryBtn;
@property (strong, nonatomic) UIPopoverController *popover;

@property (strong, nonatomic) UserEntityCategoryController * categoryController;

@end

@implementation UserLikeViewController

static NSString * EntityIdentifier = @"EntityCell";
static NSString * HeaderSectionIdentifier = @"HeaderSection";


- (instancetype)initWithUser:(GKUser *)user
{
    self = [super init];
    if (self) {
        _user = user;
//        _category = [GKCategory]
        self.pageSize = IS_IPAD ? 24 : 30;
    }
    return self;
}

- (GKCategory *)category
{
    if (!_category) {
        _category = [GKCategory modelFromDictionary:@{@"id":@(0), @"title":NSLocalizedStringFromTable(@"all", kLocalizedFile, nil)}];
    }
    return _category;
}

#pragma mark - init view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[CSStickyHeaderFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _collectionView = [[UICollectionView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight - kTabBarHeight) collectionViewLayout:layout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.frame = IS_IPAD ? CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight)
                                        : CGRectMake(0., 0., kScreenWidth, kScreenHeight - kNavigationBarHeight- kStatusBarHeight);
        
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

// for iphone
- (UserLikeHeaderSectionView *)headerSectionView
{
    if (!_headerSectionView) {
        _headerSectionView = [[UserLikeHeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _headerSectionView.category = self.category;
        _headerSectionView.delegate = self;
        
    }
    return _headerSectionView;
}


// for ipad
- (UIButton *)categoryBtn
{
    if (!_categoryBtn) {
        _categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _categoryBtn.frame = CGRectMake(0., 0., 50., 20.);
        _categoryBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17.];
        //        _categoryBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_categoryBtn setTitleColor:UIColorFromRGB(0x414243) forState:UIControlStateNormal];
        [_categoryBtn setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"all", kLocalizedFile, nil), [NSString fontAwesomeIconStringForEnum:FASortAsc]] forState:UIControlStateNormal];
        //        [_categoryBtn setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"all", kLocalizedFile, nil), [NSString fontAwesomeIconStringForEnum:FASortDesc]] forState:UIControlStateHighlighted];
        [_categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _categoryBtn;
}


#pragma mark - get data
- (void)refresh
{
    [API getUserLikeEntityListWithUserId:self.user.userId categoryId:self.category.groupId
                               timestamp:[[NSDate date] timeIntervalSince1970] count:30 success:^(NSTimeInterval timestamp, NSArray *entityArray) {
        self.likeEntities = [NSMutableArray arrayWithArray:entityArray];
        self.likeTimestamp = timestamp;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getUserLikeEntityListWithUserId:self.user.userId categoryId:self.category.groupId timestamp:self.likeTimestamp count:30 success:^(NSTimeInterval timestamp, NSArray *entityArray) {
        [self.likeEntities addObjectsFromArray:entityArray];
        self.likeTimestamp = timestamp;
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
        
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}


- (void)loadView
{
    [super loadView];
    
    if (IS_IPHONE) {
//        UserLikeHeaderSectionView * v = [[UserLikeHeaderSectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) ];
//        v.category = self.category;
//        v.delegate = self;
    
        [self.view addSubview:self.headerSectionView];
        self.collectionView.deFrameTop = 44;
    }

    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityIdentifier];
    //[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier];
    
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        self.navigationItem.title = NSLocalizedStringFromTable(@"me like", kLocalizedFile, nil);
    } else {
        self.navigationItem.title = NSLocalizedStringFromTable(@"user like", kLocalizedFile, nil);
    }
    
    if (IS_IPAD) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.categoryBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [AVAnalytics beginLogPageView:@"UserLikeView"];
    [MobClick beginLogPageView:@"UserLikeView"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [AVAnalytics endLogPageView:@"UserLikeView"];
    [MobClick endLogPageView:@"UserLikeView"];
    
    [self.categoryController.view removeFromSuperview];
    [self.categoryController removeFromParentViewController];
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
    
    if (self.likeEntities == 0) {
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.likeEntities.count;
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UserLikeHeaderSectionView * section = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
//        GKCategory * category = [GKCategory modelFromDictionary:@{@"id":@(0), @"title":NSLocalizedStringFromTable(@"all", kLocalizedFile, nil)}];
        section.category = self.category;
        section.delegate = self;
        return section;
    }

    //return [UICollectionReusableView new];
    return nil;
}
*/

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityIdentifier forIndexPath:indexPath];
    GKEntity * entity = [self.likeEntities objectAtIndex:indexPath.row];
//    DDLogError(@"entity %@ %ld", entity, indexPath.row);
    cell.entity = entity;
    cell.delegate = self;
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0, 0);
    
    if (IS_IPAD ) {
        
        cellsize = CGSizeMake(204.,204.);
    }
    else
    {
        cellsize = CGSizeMake((kScreenWidth - 12)/3, (kScreenWidth - 12)/3);
    }
    return cellsize;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    CGSize size = IS_IPHONE ? CGSizeMake(kScreenWidth, 0.) : CGSizeMake(kScreenWidth - kTabBarWidth, 0.);
//    
//    return size;
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    edge = IS_IPAD ? UIEdgeInsetsMake(16., 20., 16., 16.) : UIEdgeInsetsMake(3., 3., 3., 3.);
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 0.;
    itemSpacing = IS_IPAD ? 5. : 3.;

    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 3.;
    if (IS_IPAD) spacing = 16.;
    return spacing;
}

#pragma mark - <EntityCellDelegate>
- (void)TapImageWithEntity:(GKEntity *)entity
{
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

#pragma mark - <UserLikeHeaderSectionViewDelegate>
- (void)TapSection:(id)sender
{
    UserLikeHeaderSectionView * sectionView = (UserLikeHeaderSectionView *)sender;
    if (self.categoryController != nil) {
        [UIView animateWithDuration:0.25 animations:^{
            self.categoryController.view.alpha = 0;
        }completion:^(BOOL finished) {
            if (finished) {
                [self.categoryController.view removeFromSuperview];
                [self.categoryController removeFromParentViewController];
                self.categoryController = nil;
                sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleDown];
                [MobClick event:@"click user category" attributes:@{@"action":@"cancel"}];
//                [AVAnalytics event:@"click user category" attributes:@{@"action":@"cancel"}];
            }
        }];

    } else {
        sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleUp];

        self.categoryController = [[UserEntityCategoryController alloc] init];
        self.categoryController.currentIndex = self.category.groupId;
        
        AppDelegate * appdelegate = [[UIApplication sharedApplication] delegate];
        [appdelegate.window.rootViewController addChildViewController:self.categoryController];
        [appdelegate.window.rootViewController.view addSubview:self.categoryController.view];
        self.categoryController.view.alpha = 0;
        //self.categoryController.view.deFrameBottom = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.categoryController.view.alpha = 1;
            //self.categoryController.view.deFrameTop = kStatusBarHeight + kNavigationBarHeight + 44;
        }];
        
    
        __weak __typeof(&*self)weakSelf = self;
        self.categoryController.tapBlock = ^(GKCategory * category) {
            GKCategory * currentCategory = weakSelf.category;
        
            if (category) {
                sectionView.category = category;
                weakSelf.category = category;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.categoryController.view.alpha = 0;
            }completion:^(BOOL finished) {
                [weakSelf.categoryController.view removeFromSuperview];
                [weakSelf.categoryController removeFromParentViewController];
            }];
            
            if (currentCategory.groupId != category.groupId) {
                [weakSelf.collectionView triggerPullToRefresh];
            }
            
            weakSelf.categoryController = nil;
            sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleUp];
        

        };
//    self.categoryController = nil;
        
        [MobClick event:@"click user category" attributes:@{@"action":self.category.title}];
//        [AVAnalytics event:@"click user category" attributes:@{@"action":self.category.title}];
    }
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         self.collectionView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
//         [self.popover presentPopoverFromRect:self.categoryBtn.frame inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

#pragma mark - button action
- (void)categoryBtnAction:(id)sender
{
    //    DDLogInfo(@"info");
    //    UIViewController *contentVC = [[UIViewController alloc] init];
    self.categoryController = [[UserEntityCategoryController alloc] init];
    self.categoryController.currentIndex = self.category.groupId;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.categoryController];
    self.popover.delegate = self;
    //    self.categoryVC.currentIndex = self.cateId;
//    DDLogInfo(@"cate %lu", self.cateId);
    UIButton *button = (UIButton *)sender;
    CGRect frame = button.frame;
    frame.origin.y += 20.f;
    
    __weak __typeof(&*self)weakSelf = self;
    self.categoryController.tapBlock = ^(GKCategory * category) {
        GKCategory * currentCategory = weakSelf.category;

        weakSelf.category = category;
        
        [weakSelf.popover dismissPopoverAnimated:YES];
//        [weakSelf.collectionView triggerPullToRefresh];
        if (currentCategory.groupId != category.groupId) {
            [weakSelf.collectionView triggerPullToRefresh];
        }
//        weakSelf.category = currentCategory;
    
        
        NSString * btnString = [NSString stringWithFormat:@"%@ %@", category.title_en, [NSString fontAwesomeIconStringForEnum:FASortAsc]];
        CGFloat btnWidth = [btnString widthWithLineWidth:0. Font:button.titleLabel.font];
        button.frame = CGRectMake(0., 0., btnWidth, 20);
        [button setTitle:btnString forState:UIControlStateNormal];
    };
//    _categoryVC.didSelectedCategory = ^(NSString * catename, NSInteger index) {
//        weakSelf.cateId = index;
//        [weakSelf.collectionView triggerPullToRefresh];
//        
//        [weakSelf.popover dismissPopoverAnimated:YES];
//        
//        NSString * btnString = [NSString stringWithFormat:@"%@ %@", catename, [NSString fontAwesomeIconStringForEnum:FASortAsc]];
//        CGFloat btnWidth = [btnString widthWithLineWidth:0. Font:button.titleLabel.font];
//        button.frame = CGRectMake(0., 0., btnWidth, 20);
//        [button setTitle:btnString forState:UIControlStateNormal];
//    };
    
    self.popover.popoverContentSize = CGSizeMake(190., 530.);
    [self.popover presentPopoverFromRect:frame inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - <UIPopoverControllerDelegate>
- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout nonnull CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull * _Nonnull)view
{
//    NSLog(@"view view %@", popoverController);
    CGRect rectInView = [self.categoryBtn convertRect:self.categoryBtn.frame toView:self.navigationItem.rightBarButtonItem.customView];
    
    *rect = CGRectMake(CGRectGetMidX(rectInView), CGRectGetMaxY(rectInView), 50, 20);

    *view = self.navigationController.view;
}
@end


#pragma mark - <UserLikeHeaderSectionView>
@implementation UserLikeHeaderSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        NSArray *languages = [NSLocale preferredLanguages];
        //        NSLog(@"%@", languages);
        self.language = [languages objectAtIndex:0];
        UIButton * button =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UILabel *)indicatorLable
{
    if (!_indicatorLable) {
        _indicatorLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _indicatorLable.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        _indicatorLable.textAlignment = NSTextAlignmentLeft;
        _indicatorLable.textColor = UIColorFromRGB(0x9d9e9f);
        _indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleDown];

        [self addSubview:_indicatorLable];
    }
    return _indicatorLable;
}

- (void)click
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapSection:)]) {
        [_delegate TapSection:self];
    }
}

- (void)setCategory:(GKCategory *)category
{
    _category = category;
    
    if ([self.language hasPrefix:@"en"]) {
        self.titleLabel.text = _category.title_en;
    } else {
        self.titleLabel.text = _category.title_cn;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0., 0., 100., 44);
    self.titleLabel.deFrameRight += 16.;

    self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
    self.indicatorLable.center = self.titleLabel.center;
    self.indicatorLable.deFrameRight = kScreenWidth - 10.;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., 44);
    CGContextAddLineToPoint(context, kScreenWidth, 44);
    CGContextStrokePath(context);
    
}




@end
