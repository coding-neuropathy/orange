//
//  MoreArticlesViewController.m
//  orange
//
//  Created by D_Collin on 16/2/3.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "MoreArticlesViewController.h"
#import "ArticleListCell.h"
@interface MoreArticlesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,assign)NSInteger page;

@end

@implementation MoreArticlesViewController

static NSString * ArticleCellIdentifier = @"CategoryArticleCell";

- (instancetype)initWithDataSource:(NSArray *)dataSource
{
    if (self = [super init]) {
        self.dataSource = dataSource;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self tableView];
    
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
    [self.tableView.pullToRefreshView startAnimating];
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];
    
}

- (void)loadMore
{
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView reloadData];
    
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

@end
