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

@interface UserLikeHeaderSectionView : UICollectionReusableView

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * indicatorLable;
@property (strong, nonatomic) GKCategory * category;
@property (weak, nonatomic) id <UserLikeHeaderSectionViewDelegate> delegate;
//@property (strong, nonatomic) NSString * title;

@end

@interface UserLikeViewController () <EntityCellDelegate, UserLikeHeaderSectionViewDelegate>

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) NSMutableArray * likeEntities;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (nonatomic, assign) NSTimeInterval likeTimestamp;
@property (strong, nonatomic) GKCategory * category;

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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
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
        [self.collectionView reloadData];
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
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[EntityCell class] forCellWithReuseIdentifier:EntityIdentifier];
    [self.collectionView registerClass:[UserLikeHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier];
    
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        self.navigationItem.title = @"我的喜爱";
    } else {
        self.navigationItem.title = @"他的喜爱";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"UserLikeView"];
    [MobClick beginLogPageView:@"UserLikeView"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"UserLikeView"];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UserLikeHeaderSectionView * section = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderSectionIdentifier forIndexPath:indexPath];
//        GKCategory * category = [GKCategory modelFromDictionary:@{@"id":@(0), @"title":NSLocalizedStringFromTable(@"all", kLocalizedFile, nil)}];
        section.category = self.category;
        section.delegate = self;
        return section;
    }
    return [UICollectionReusableView new];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityIdentifier forIndexPath:indexPath];
    cell.entity = [self.likeEntities objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellsize = CGSizeMake(0, 0);
    cellsize = CGSizeMake((kScreenWidth-12)/3, (kScreenWidth-12)/3);
    return cellsize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(kScreenWidth, 44.);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    edge = UIEdgeInsetsMake(3., 3., 3., 3.);
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = 3.;

    return itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 3.;
    
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
        [self.categoryController.view removeFromSuperview];
        [self.categoryController removeFromParentViewController];
        self.categoryController = nil;
        
        sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleDown];
//        return;
    } else {
        sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleUp];

        self.categoryController = [[UserEntityCategoryController alloc] init];
        self.categoryController.currentIndex = self.category.groupId;
        
        AppDelegate * appdelegate = [[UIApplication sharedApplication] delegate];
        [appdelegate.window.rootViewController addChildViewController:self.categoryController];
        [appdelegate.window addSubview:self.categoryController.view];
    
        __weak __typeof(&*self)weakSelf = self;
        self.categoryController.tapBlock = ^(GKCategory * category) {
            GKCategory * currentCategory = weakSelf.category;
        
            if (category) {
                sectionView.category = category;
                weakSelf.category = category;
            }
        
            [weakSelf.categoryController.view removeFromSuperview];
            [weakSelf.categoryController removeFromParentViewController];
//            sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleUp];
            if (currentCategory.groupId != category.groupId) {
                [weakSelf.collectionView triggerPullToRefresh];
            }
        
            weakSelf.categoryController = nil;
            sectionView.indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleUp];
        };
//    self.categoryController = nil;
    }
    
}

@end


#pragma mark - <UserLikeHeaderSectionView>
@implementation UserLikeHeaderSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
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
        //        _indicatorLable.hidden = YES;
        //        _indicatorLable.backgroundColor = [UIColor redColor];
        [self addSubview:_indicatorLable];
    }
    return _indicatorLable;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapSection:)]) {
        [_delegate TapSection:self];
    }
}

- (void)setCategory:(GKCategory *)category
{
    _category = category;
    self.titleLabel.text = _category.title_cn;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0., 0., 100., self.deFrameHeight);
    self.titleLabel.deFrameRight += 16.;

    self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
    self.indicatorLable.center = self.titleLabel.center;
    self.indicatorLable.deFrameRight = self.deFrameRight - 10.;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextStrokePath(context);
    
}

@end
