//
//  ArticleSearchViewController.m
//  orange
//
//  Created by huiter on 15/12/8.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "ArticleSearchViewController.h"
#import "ArticleListCell.h"
#import "NoSearchResultView.h"

@interface ArticleSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NoSearchResultView * noResultView;
@property (nonatomic, strong) NSString *keyword;

@end

@implementation ArticleSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
        __weak __typeof(&*self)weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight-kStatusBarHeight-kNavigationBarHeight-44) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        
    }
    return _tableView;
}

- (NoSearchResultView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[NoSearchResultView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    }
    return _noResultView;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"ArticleCell";
    ArticleListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.article = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - <UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKArticle * article = [self.dataArray objectAtIndex:indexPath.row];
    [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
}


- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    
    self.keyword = searchText;
    self.tableView.tableFooterView = nil;
    
    [API searchArticlesWithString:searchText Page:1 Size:10 success:^(NSArray *articles) {
        if (articles.count == 0) {
            self.tableView.tableFooterView = self.noResultView;
            self.noResultView.type = NoResultType;
        } else {
            self.dataArray = [NSMutableArray arrayWithArray:articles];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Data
- (void)loadMore
{

    NSInteger page = ceilf(self.dataArray.count / 10.) + 1;
    [API searchArticlesWithString:self.keyword Page:page Size:10 success:^(NSArray *articles) {
        [self.dataArray addObjectsFromArray:articles];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];

}

@end
