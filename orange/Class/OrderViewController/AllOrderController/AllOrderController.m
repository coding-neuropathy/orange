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
#import "CheckoutOrderController.h"

@interface AllOrderController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, OrderHeaderViewDelegate>


@end

@implementation AllOrderController

static NSString *CellIdentifier     = @"OrderCell";
static NSString *HeaderIdentifier   = @"OrderHeader";
static NSString *FooterIdentifier   = @"OrderFooter";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page   = 1;
        self.size   = 10;
    }
    return self;
}

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
        _collectionView.deFrameSize = CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kNavigationBarHeight);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
        
        _collectionView.emptyDataSetSource = self;
//        _collectionView.emptyDataSetVisible = NO;
    }
    return _collectionView;
}


#pragma mark - get order list 
- (void)refresh
{
    self.page = 1;
    [API getOrderListWithWithStatus:0 Page:self.page Size:self.size Success:^(NSArray *OrderArray) {
        DDLogInfo(@"order list %@", OrderArray);
        self.orderArray = [NSMutableArray arrayWithArray:OrderArray];
        self.page       += 1;
        [self.collectionView.pullToRefreshView stopAnimating];
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadData];
        [UIView setAnimationsEnabled:YES];
        
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)load
{
    [API getOrderListWithWithStatus:0 Page:self.page Size:self.size Success:^(NSArray *OrderArray) {
        //        DDLogInfo(@"order list %@", OrderArray);
//        self.orderArray = (NSMutableArray *)OrderArray;
        self.page       += 1;
        [self.orderArray addObjectsFromArray:OrderArray];
        [self.collectionView.infiniteScrollingView stopAnimating];
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadData];
        [UIView setAnimationsEnabled:YES];
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
        [self.collectionView.infiniteScrollingView stopAnimating];
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

- (void)viewWillAppear:(BOOL)animated
{
    self.collectionView.scrollsToTop    = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.collectionView.scrollsToTop    = NO;
    [super viewWillDisappear:animated];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
        
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf load];
    }];
    
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
    DDLogInfo(@"order status %ld", (unsigned long)order.status);
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
        OrderHeaderView *headerView = [collectionView
                                       dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                        withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        headerView.order            = order;
        headerView.delegate         = self;
        return headerView;
    
    } else {
        OrderFooterView *footerView = [collectionView
                                       dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                        withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        
        footerView.order    = order;
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.;
}

//#pragma mark - <UICollectionViewDelegate>
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    GKOrder * order = [self.orderArray objectAtIndex:indexPath.section];
//    
//    CheckoutOrderController * vc = [[CheckoutOrderController alloc] initWithOrder:order];
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark - <DZNEmptyDataSetSource>
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedStringFromTable(@"no-order", kLocalizedFile, nil);;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0. green:0. blue:0. alpha:0.27],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -100.0;
}

#pragma mark - <DZNEmptyDataSetDelegate>
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    DDLogInfo(@"%s",__FUNCTION__);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}

#pragma mark - <OrderHeaderViewDelegate>
- (void)tapPaymentBtnAction:(GKOrder *)order
{
//    GKOrder * order = [self.orderArray objectAtIndex:ind];
    
    CheckoutOrderController * vc = [[CheckoutOrderController alloc] initWithOrder:order];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
