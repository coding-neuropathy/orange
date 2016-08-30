//
//  CartController.m
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CartController.h"
#import "CartCell.h"


@interface CartController ()

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSMutableArray    *cartItemArray;

@end

@implementation CartController

static NSString * CellIndetifier = @"CartCell";


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView                  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.deFrameSize      = CGSizeMake(kScreenWidth, kScreenHeight);
        _tableView.dataSource       = self;
        _tableView.delegate         = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad
{

    self.title                      = NSLocalizedStringFromTable(@"shopping-cart", kLocalizedFile, nil);
    
    [self.tableView registerClass:[CartCell class] forCellReuseIdentifier:CellIndetifier];
    [self.view addSubview:self.tableView];
    
    
    [API getCartItemListWithSuccess:^(NSArray *shoppingCartArray) {
        DDLogInfo(@"%@", shoppingCartArray);
        self.cartItemArray = [NSMutableArray arrayWithArray:shoppingCartArray];
        [self.tableView reloadData];
    } Failure:^(NSInteger stateCode, NSError *error) {
        
    }];

    [super viewDidLoad];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifier forIndexPath:indexPath];
    
    cell.cartItem   = [self.cartItemArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.;
}

@end
