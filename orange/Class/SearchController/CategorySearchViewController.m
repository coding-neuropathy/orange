//
//  CategorySearchViewController.m
//  orange
//
//  Created by huiter on 15/12/8.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "CategorySearchViewController.h"
#import "CategoryGridCell.h"
#import "NoSearchResultView.h"
#import "PinyinTools.h"

@interface CategorySearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NoSearchResultView * noResultView;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@end

@implementation CategorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self.view addSubview:self.tableView];
    /*
     __weak __typeof(&*self)weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight - kTabBarHeight-kStatusBarHeight-kNavigationBarHeight-4) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) style:UITableViewStylePlain];
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
    return ceil(self.filteredArray.count /(CGFloat)4);
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CategoryGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSArray *categoryDictArray = self.filteredArray;
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    NSUInteger offset = indexPath.row * 4;
    int i = 0;
    for (; offset < categoryDictArray.count ; offset++) {
        [categoryArray addObject:categoryDictArray[offset]];
        i++;
        if (i>=4) {
            break;
        }
    }
    cell.categoryArray = categoryArray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CategoryGridCell height];
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
}


- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    
    self.tableView.tableFooterView = nil;
    
    self.filteredArray = [NSMutableArray array];
    for (GKEntityCategory *word in kAppDelegate.allCategoryArray) {
        NSString *screenName = word.categoryName;
        if ([PinyinTools ifNameString:screenName SearchString:searchText]) {
            [_filteredArray addObject:word];
        }
    }
    [self.filteredArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
    [self.tableView.pullToRefreshView stopAnimating];
    if(self.filteredArray.count == 0)
    {
        self.tableView.tableFooterView = self.noResultView;
        self.noResultView.type = NoResultType;
    }
    [self.tableView reloadData];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Data
- (void)loadMore
{

    [self.tableView.infiniteScrollingView stopAnimating];
    return;
}

@end
