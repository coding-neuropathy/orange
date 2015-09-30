//
//  TagArticlesController.m
//  orange
//
//  Created by 谢家欣 on 15/9/30.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "TagArticlesController.h"
#import "ArticleCell.h"
#import "WebViewController.h"

@interface TagArticlesController ()

@property (strong, nonatomic) NSString * tagName;
@property (strong, nonatomic) NSMutableArray * articleArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger size;

@property (strong, nonatomic) UICollectionView * collectionView;

@end

@implementation TagArticlesController

static NSString * ArticleIdentifier = @"ArticleCell";

- (instancetype)initWithTagName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.tagName = [name decodeURL];
        self.page = 1;
        self.size = 10;
//        self.title = [name decodeURL];
    }
    return self;
}

#pragma mark - init View
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //        layout.parallaxHeaderAlwaysOnTop = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
    self.page = 1;
    [API getArticlesWithTagName:self.tagName Page:self.page Size:self.size success:^(NSArray *dataArray) {
//        NSLog(@"%@", dataArray);
        self.articleArray = [NSMutableArray arrayWithArray:dataArray];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        self.page += 1;
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getArticlesWithTagName:self.tagName Page:self.page Size:self.size success:^(NSArray *dataArray) {
        //        NSLog(@"%@", dataArray);
//        self.articleArray = [NSMutableArray arrayWithArray:dataArray];
        [self.articleArray addObjectsFromArray:dataArray];
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
        self.page += 1;
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
    
    self.title = self.tagName;
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[ArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.scrollsToTop = YES;
    [AVAnalytics beginLogPageView:@"TagArticlesView"];
    [MobClick beginLogPageView:@"TagArticlesView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.collectionView.scrollsToTop = NO;
    [AVAnalytics endLogPageView:@"TagArticlesView"];
    [MobClick endLogPageView:@"TagArticlesView"];
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
    
    if (self.articleArray.count == 0)
    {
        [self.collectionView triggerPullToRefresh];
    }
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.articleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleIdentifier forIndexPath:indexPath];
    cell.article = [self.articleArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    CGSize cellSize = CGSizeMake(kScreenWidth, 140 + 174* kScreenWidth/(375-32) );
    
    GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
    
    return [ArticleCell CellSizeWithArticle:article ];
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0., 0., 5, 0.);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.articleArray objectAtIndex:indexPath.row];
    [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
