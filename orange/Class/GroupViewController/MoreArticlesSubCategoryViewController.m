//
//  MoreArticlesSubCategoryViewController.m
//  orange
//
//  Created by D_Collin on 16/2/16.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MoreArticlesSubCategoryViewController.h"
#import "ArticleListCell.h"
@interface MoreArticlesSubCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView * tableView;

@property (nonatomic ,assign)NSInteger page;

//@property (assign, nonatomic) NSInteger count;
@end

@implementation MoreArticlesSubCategoryViewController

static NSString * ArticleCellIdentifier = @"CategoryArticleCell";

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource
{
    if (self = [super init]) {
        self.dataSource = dataSource;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ArticleListCell class] forCellReuseIdentifier:ArticleCellIdentifier];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (self.dataSource == 0) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)refresh
{
    self.page = 1;
    [API getSubCategoryArticlesWithCategroyId:self.cid Page:self.page success:^(NSArray *articles, NSInteger count) {
        self.dataSource = [NSMutableArray arrayWithArray:articles];
        self.page += 1;
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
}

- (void)loadMore
{
    [API getSubCategoryArticlesWithCategroyId:self.cid Page:self.page success:^(NSArray *articles, NSInteger count) {
        [self.dataSource addObjectsFromArray:articles];
        self.page += 1;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
    
}

#pragma mark -----------tableView懒加载 ---------------

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight -kStatusBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------tableView代理协议-----------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ArticleCell";
    ArticleListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.article = [self.dataSource objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.dataSource objectAtIndex:indexPath.row];
    [[OpenCenter sharedOpenCenter] openWebWithURL:article.articleURL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.;
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
