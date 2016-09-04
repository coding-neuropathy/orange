//
//  AllOrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "AllOrderController.h"
#import "OrderCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"

@interface AllOrderController ()

@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) NSMutableArray    *orderArray;

@end

@implementation AllOrderController

static NSString *CellIdentifier     = @"OrderCell";
static NSString *HeaderIdentifier   = @"OrderHeader";
static NSString *FooterIdentifier   = @"OrderFooter";


#pragma mark - init collction view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
        layout.itemSize                     = CGSizeMake(kScreenWidth, 100.);
        layout.headerReferenceSize          = CGSizeMake(kScreenWidth, 100.);
        layout.footerReferenceSize          = CGSizeMake(kScreenWidth, 50.);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.deFrameSize = CGSizeMake(kScreenWidth, kScreenHeight - 47.);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
    }
    return _collectionView;
}
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView                      = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.deFrameSize          = CGSizeMake(kScreenWidth, kScreenHeight - 47.);
////        _tableView.deFrameTop           = 47.;
////        _tableView.backgroundColor      = [UIColor colorFromHexString:@"#ffffff"];
//        _tableView.rowHeight            = 100.;
//        _tableView.sectionHeaderHeight  = 100.;
//        _tableView.sectionFooterHeight  = 40.;
//        _tableView.delegate             = self;
//        _tableView.dataSource           = self;
//        
//    }
//    return _tableView;
//}

#pragma mark - get order list 
- (void)refresh
{
    [API getOrderListWithSuccess:^(NSArray *OrderArray) {
//        DDLogInfo(@"order list %@", OrderArray);
        self.orderArray = (NSMutableArray *)OrderArray;
        
        [self.collectionView.pullToRefreshView stopAnimating];
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadData];
        [UIView setAnimationsEnabled:YES];
        
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[OrderCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView registerClass:[OrderHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [self.collectionView registerClass:[OrderFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
        
    }];
    
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf.entityList loadWithCategoryId:weakSelf.cateId];
//    }];
    
    if (self.orderArray.count == 0)
    {
        [self.collectionView triggerPullToRefresh];
    }
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.orderArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GKOrder * order  = [self.orderArray objectAtIndex:section];
    DDLogInfo(@"orderItems %ld", order.orderItems.count);
    return order.orderItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GKOrder * order     = [self.orderArray objectAtIndex:indexPath.section];
    cell.orderItem      = [order.orderItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GKOrder * order     = [self.orderArray objectAtIndex:indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OrderHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        headerView.order    = order;
        return headerView;
    
    } else {
        OrderFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                         withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        
        footerView.order    = order;
        return footerView;
    }

}

@end
