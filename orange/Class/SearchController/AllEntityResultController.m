//
//  AllEntityResultController.m
//  orange
//
//  Created by D_Collin on 16/7/18.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "AllEntityResultController.h"
#import "EntitySingleListCell.h"
#import "NoSearchResultView.h"

@interface AllEntityResultController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NoSearchResultView * noResultView;

@end

@implementation AllEntityResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.title = NSLocalizedStringFromTable(@"entities", kLocalizedFile, nil);
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:IS_IPHONE ? CGRectMake(0., 0., kScreenWidth, kScreenHeight) : CGRectMake(0., 0., kScreenWidth - kTabBarWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        
    }
    return _tableView;
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
    
    if (self.dataArray == 0) {
        [self.tableView triggerPullToRefresh];
    }
}

- (NoSearchResultView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[NoSearchResultView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight)];
    }
    return _noResultView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    static NSString *CellIdentifier = @"EntitySingleListCell";
    EntitySingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[EntitySingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.entity = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114.;
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


#pragma mark - Data
- (void)refresh
{
    [API searchEntityWithString:self.keyword type:@"all" offset:0 count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
        if (entityArray.count == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:entityArray];;
            self.tableView.tableFooterView = self.noResultView;
            self.noResultView.type = NoResultType;
        } else {
            self.dataArray = [NSMutableArray arrayWithArray:entityArray];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    
    [API searchEntityWithString:self.keyword type:@"all" offset:self.dataArray.count count:30 success:^(NSDictionary *stat, NSArray *entityArray) {
        if (self.dataArray.count == 0) {
            self.dataArray = [NSMutableArray array];
        }
        [self.dataArray addObjectsFromArray:entityArray];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
//        DDLogError(@"code %ld", (long)stateCode);
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         self.tableView.frame = CGRectMake(0., 0., size.width - kTabBarWidth, size.height);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
