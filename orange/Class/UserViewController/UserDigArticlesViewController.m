//
//  UserDigArticlesViewController.m
//  orange
//
//  Created by D_Collin on 16/4/7.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UserDigArticlesViewController.h"
#import "ArticleListCell.h"
@interface UserDigArticlesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic)GKUser * user;
@property (strong , nonatomic)UITableView * tableView;
@property (strong , nonatomic)NSMutableArray * ArticleArray;

@property (nonatomic ,assign)NSInteger page;


@end

@implementation UserDigArticlesViewController

static NSString * UserDigArticleIdentifier = @"UserDigCell";

- (instancetype)initWithUser:(GKUser *)user
{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ArticleListCell class] forCellReuseIdentifier:UserDigArticleIdentifier];
    
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        self.navigationItem.title = NSLocalizedStringFromTable(@"me poke", kLocalizedFile, nil);
    } else {
        self.navigationItem.title = NSLocalizedStringFromTable(@"user poke", kLocalizedFile, nil);
    }
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
    
    if (self.ArticleArray == 0) {
        [self.tableView triggerPullToRefresh];
    }
}



- (void)refresh
{
    self.page = 1;
    [API getUserDigArticleWithUserId:self.user.userId Page:self.page success:^(NSArray *articles, NSInteger size, NSInteger total) {
        self.ArticleArray = [NSMutableArray arrayWithArray:articles];
        self.page += 1;
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getUserDigArticleWithUserId:self.user.userId Page:self.page success:^(NSArray *articles, NSInteger size, NSInteger total) {
        [self.ArticleArray addObjectsFromArray:articles];
        self.page += 1;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------tableView代理协议-----------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ArticleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ArticleCell";
    ArticleListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.article = [self.ArticleArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKArticle * article = [self.ArticleArray objectAtIndex:indexPath.row];
    [[OpenCenter sharedOpenCenter] openArticleWebWithArticle:article];
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
