//
//  FinishedOrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "FinishedOrderController.h"

@implementation FinishedOrderController

#pragma mark - get order list
- (void)refresh
{
    self.page   = 1;
    [API getOrderListWithWithStatus:Paid Page:self.page Size:self.size Success:^(NSArray *OrderArray) {
        self.orderArray = (NSMutableArray *)OrderArray;
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
    [API getOrderListWithWithStatus:Paid Page:self.page Size:self.size Success:^(NSArray *OrderArray) {
        self.page       += 1;
        [self.orderArray addObjectsFromArray:OrderArray];
        [self.collectionView.pullToRefreshView stopAnimating];
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadData];
        [UIView setAnimationsEnabled:YES];
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

@end
