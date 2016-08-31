//
//  CartController.m
//  orange
//
//  Created by 谢家欣 on 16/8/29.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CartController.h"
#import "CartCell.h"
#import "CartToolBar.h"


@interface CartController () <CartToolbarDelegate>

@property (strong, nonatomic) CartToolBar       *toolbar;
@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSMutableArray    *cartItemArray;


@end

@implementation CartController

static NSString * CellIndetifier = @"CartCell";


- (UIView *)toolbar
{
    if (!_toolbar) {
        _toolbar                                = [[CartToolBar alloc] initWithFrame:CGRectZero];
        _toolbar.deFrameSize                    = CGSizeMake(kScreenWidth, 49.);
        _toolbar.backgroundColor                = UIColorFromRGB(0xffffff);
        _toolbar.delegate                       = self;
        
    }
    return _toolbar;
}

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

- (void)refresh
{
    [API getCartItemListWithSuccess:^(NSArray *shoppingCartArray) {
        DDLogInfo(@"%@", shoppingCartArray);
        self.cartItemArray = [NSMutableArray arrayWithArray:shoppingCartArray];
        [self.tableView reloadData];
        
//        CGFloat price = 0.;
//        for (ShoppingCart *cart in self.cartItemArray) {
//            price += cart.price;
//        }
//        self.toolbar.price = price;
        
        [self.toolbar updatePriceWithprice:[self updateCartItemPrice]];
        
        [self.tableView.pullToRefreshView stopAnimating];
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
        
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)viewDidLoad
{

    self.title                      = NSLocalizedStringFromTable(@"shopping-cart", kLocalizedFile, nil);
    
    [self.tableView registerClass:[CartCell class] forCellReuseIdentifier:CellIndetifier];
    [self.view addSubview:self.tableView];
    
    [self configToolbar];

    [super viewDidLoad];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf refresh];
        
    }];
    
    if (self.cartItemArray.count == 0)
    {
        [self.tableView triggerPullToRefresh];
    }
    
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
    CartCell * cell         = [tableView dequeueReusableCellWithIdentifier:CellIndetifier forIndexPath:indexPath];
    
    cell.cartItem           = [self.cartItemArray objectAtIndex:indexPath.row];
    cell.updateOrderPrice   = ^() {
        [self.toolbar updatePriceWithprice:[self updateCartItemPrice]];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.;
}

#pragma mark - config toolbar
- (void)configToolbar
{
//    DDLogInfo(@"height %f", self.view.deFrameHeight);
    self.toolbar.deFrameBottom              = self.view.deFrameHeight - kNavigationBarHeight - kStatusBarHeight;
//    self.toolbar.price                      = self.ca.lowestPrice;
//    CGFloat price = 0.;
//    for (ShoppingCart *cart in self.cartItemArray) {
//        price += cart.price;
//    }
    self.toolbar.price = [self updateCartItemPrice];
    [self.view insertSubview:self.toolbar aboveSubview:self.tableView];
}

- (CGFloat)updateCartItemPrice
{
    CGFloat price = 0.;
    for (ShoppingCart *cart in self.cartItemArray) {
        price += cart.price;
    }
    return price;
}

#pragma mark - <CartToolbarDelegate>
- (void)tapOrderBtn:(id)sender
{
    
}

@end
