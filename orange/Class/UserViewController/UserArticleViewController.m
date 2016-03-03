//
//  UserArticleViewController.m
//  orange
//
//  Created by D_Collin on 16/3/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UserArticleViewController.h"
#import "ArticleListCell.h"
@interface UserArticleViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 用户图文数据源数组 */
@property (nonatomic , strong)NSMutableArray * dataSource;

@property (nonatomic , strong)UITableView * tableView;

@property (nonatomic , assign)NSInteger page;

@end

@implementation UserArticleViewController

static NSString * ArticleCellIdentifier = @"UserArticleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ArticleListCell class] forCellReuseIdentifier:ArticleCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    [API getUserArticlesWithUserId:self.Uid Page:self.page Size:15 success:^(NSArray *articles, NSInteger page, NSInteger count) {
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
    [API getUserArticlesWithUserId:self.Uid Page:self.page Size:15 success:^(NSArray *articles, NSInteger page, NSInteger count) {
        [self.dataSource addObjectsFromArray:articles];
        self.page += 1;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark -----------tableView代理协议-------------

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleListCell * cell = [tableView dequeueReusableCellWithIdentifier:ArticleCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.article = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKArticle * article = [self.dataSource objectAtIndex:indexPath.row];
//    NSLog(@"%@",article.articleURL);
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
