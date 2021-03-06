//
//  HomeController.m
//  orange
//
//  Created by 谢家欣 on 15/9/7.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HomeController.h"
#import "HomeArticleCell.h"
#import "HomeCategoryCell.h"
#import "HomeEntityCell.h"
#import "UIScrollView+Slogan.h"

#import "DiscoverBannerView.h"
#import "WebViewController.h"

@interface HomeCategoryFooter : UICollectionReusableView

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) NSString * text;

@end


@interface HomeController () <DiscoverBannerViewDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * bannerArray;
@property (strong, nonatomic) NSMutableArray * articleArray;
@property (strong, nonatomic) NSMutableArray * categoryArray;
@property (strong, nonatomic) NSMutableArray * entityArray;
@end

@implementation HomeController

static NSString * BannerIdentifier = @"BannerView";
static NSString * ArticleIdentifier = @"HomeArticleCell";
static NSString * CategoryIdentifier = @"CategoryCell";
static NSString * EntityIdentifier = @"EntityCell";

static NSString * CategoryFooterIdentifier = @"CategoryFooter";

#pragma mark - init View
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //        layout.parallaxHeaderAlwaysOnTop = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarHeight) collectionViewLayout:layout];
        
        [_collectionView registerClass:[DiscoverBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier];
        
        [_collectionView registerClass:[HomeArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
        
        [_collectionView registerClass:[HomeCategoryCell class] forCellWithReuseIdentifier:CategoryIdentifier];
        
        [_collectionView registerClass:[HomeCategoryFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CategoryFooterIdentifier];
        
        [_collectionView registerClass:[HomeEntityCell class] forCellWithReuseIdentifier:EntityIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

#pragma mark - get Data
- (void)refresh
{
    [API getHomeWithSuccess:^(NSArray *banners, NSArray *articles, NSArray * categories,  NSArray *entities) {
        self.bannerArray = banners;
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        self.categoryArray = [NSMutableArray arrayWithArray:categories];
        self.entityArray = [NSMutableArray arrayWithArray:entities];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];

    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadView
{
    [super loadView];

    
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView addSloganView];
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
    
//    [self.collectionView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf loadMore];
//    }];
//    
    if (self.articleArray.count == 0)
    {
        [self.collectionView triggerPullToRefresh];
    }
    
    //[self refresh];
    
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
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = self.articleArray.count;
            break;
        case 1:
            count = self.categoryArray.count;
            break;
        case 2:
            count = self.entityArray.count;
            break;
        default:
        
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 2:
        {
            HomeEntityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EntityIdentifier forIndexPath:indexPath];
            cell.data = [self.entityArray objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case 1:
        {
            HomeCategoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryIdentifier forIndexPath:indexPath];
            cell.category = [self.categoryArray objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        default:
        {
            ArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleIdentifier forIndexPath:indexPath];
            cell.article = [self.articleArray objectAtIndex:indexPath.row];
            return cell;
        }
            break;
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reuseableview = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        DiscoverBannerView * bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BannerIdentifier forIndexPath:indexPath];
        bannerView.bannerArray = self.bannerArray;
        bannerView.delegate = self;
        if (self.bannerArray.count == 0) {
            bannerView.hidden = YES;
        }
        else
        {
            bannerView.hidden = NO;
        }
        return bannerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        HomeCategoryFooter * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CategoryFooterIdentifier forIndexPath:indexPath];
        footer.text = @"推荐品类";
        return footer;
    }
    
    return reuseableview;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(0, 0);
    switch (indexPath.section) {
        case 0:
            cellSize = CGSizeMake(kScreenWidth, 84 *kScreenWidth/375 + 32);
            break;
        case 1:
            cellSize = CGSizeMake(kScreenWidth / 3, kScreenWidth / 3);
            break;
        case 2:
            cellSize = CGSizeMake(kScreenWidth, kScreenWidth * 0.48);
            break;
        default:
            break;
    }
    
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0, 0.);
    switch (section) {
        case 1:
//            edge = UIEdgeInsetsMake(10., 0., 10., 0.);
            break;
        case 2:
            edge = UIEdgeInsetsMake(10., 0., 0., 0.);
            break;
        default:
            edge = UIEdgeInsetsMake(0., 0., 10., 0.);
            break;
    }
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spaceing = 10.;
    switch (section) {
        case 1:
            spaceing = 0;
            break;
            
        default:
            break;
    }
    return spaceing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spaceing = 0;
    switch (section) {
        case 1:
//            spaceing = 0;
            break;
            
        default:
            break;
    }
    return spaceing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(0, 0);
    switch (section) {
        case 0:
            headerSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 150.f * kScreenWidth / 320);
            break;
    }
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerSize = CGSizeMake(0., 0.);
    switch (section) {
        case 1:
        {
            if (self.categoryArray.count > 0)
                footerSize = CGSizeMake(kScreenWidth, 30.);
        }
            break;
            
        default:
            break;
    }
    
    return footerSize;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
            //    NSLog(@"%@", article.articleURL);
            WebViewController * vc = [[WebViewController alloc]initWithURL:article.articleURL];
            if (IS_IPHONE) vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - <DiscoverBannerViewDelegate>
- (void)TapBannerImageAction:(NSDictionary *)dict
{
    NSString * url = dict[@"url"];
//    [AVAnalytics event:@"banner" attributes:@{@"url": url}];
    [MobClick event:@"banner" attributes:@{@"url": url}];
    if ([url hasPrefix:@"http://"]) {
        if (k_isLogin) {
            NSRange range = [url rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&session=%@",[Passport sharedInstance].session]];
            }
            else
            {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"?session=%@",[Passport sharedInstance].session]];
            }
        }
        NSRange range = [url rangeOfString:@"out_link"];
        if (range.location == NSNotFound) {
            WebViewController * VC = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end

#pragma mark - <HomeCategoryFooter>
@implementation HomeCategoryFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12.];
        _titleLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.titleLabel.text = _text;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10., 0., 100., 20.);
    
}

@end
