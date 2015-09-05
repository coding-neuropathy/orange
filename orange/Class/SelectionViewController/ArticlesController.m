//
//  ArticlesController.m
//  orange
//
//  Created by 谢家欣 on 15/9/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ArticlesController.h"
#import "ArticleCell.h"

@interface ArticlesController ()

@property (strong, nonatomic) NSMutableArray * articleArray;
@property (strong, nonatomic) UICollectionView * collectionView;

@end

@implementation ArticlesController

static NSString * ArticleIdentifier = @"ArticleCell";

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
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
    [API getArticlesWithSuccess:^(NSArray *articles) {
        self.articleArray = [NSMutableArray arrayWithArray:articles];
        
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
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
    [self.collectionView registerClass:[ArticleCell class] forCellWithReuseIdentifier:ArticleIdentifier];
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
    CGSize cellSize = CGSizeMake(kScreenWidth, 117);
    
    return cellSize;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
