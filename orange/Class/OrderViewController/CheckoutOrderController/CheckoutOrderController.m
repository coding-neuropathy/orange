//
//  CheckoutOrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/5.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "CheckoutOrderController.h"
#import "OrderCell.h"
#import "OrderHeaderView.h"
#import "CheckoutFooterView.h"
#import "PaymentCodeController.h"
#import "WebViewController.h"

#import "WXApi.h"

@interface CheckoutOrderController () <CheckoutFooterViewDelegate>

//@property (strong, nonatomic) GKOrder           *order;
@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) NSArray           *orderArray;

@end

@implementation CheckoutOrderController

static NSString *CellIdentifier     = @"OrderCell";
static NSString *HeaderIdentifier   = @"OrderHeader";
static NSString *FooterIdentifier   = @"CheckoutOrderFooter";

- (instancetype)initWithOrder:(GKOrder *)order
{
    self = [super init];
    if (self) {
//        self.order      = order;
        self.orderArray     = [NSArray arrayWithObjects:order, nil];
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
        layout.footerReferenceSize          = CGSizeMake(kScreenWidth, 220.);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.deFrameSize = CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
        _collectionView.alwaysBounceVertical    = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        
    }
    return _collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"order-detail", kLocalizedFile, nil);
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[OrderCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView registerClass:[OrderHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    [self.collectionView registerClass:[CheckoutFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.orderArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GKOrder * order  = [self.orderArray objectAtIndex:section];
    DDLogInfo(@"orderItems %ld", (unsigned long)order.orderItems.count);
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
    GKOrder * order         = [self.orderArray objectAtIndex:indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OrderHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                         withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        headerView.paymentEnable    = NO;
        headerView.order            = order;
        return headerView;
        
    } else {
        CheckoutFooterView *footerView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                         withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        footerView.delegate             = self;
        footerView.order                = order;
        return footerView;
    }
}

#pragma mark - <CheckoutFooterViewDelegate>
- (void)tapWeCahtBtn:(id)sender
{
    if ([sender isKindOfClass:[GKOrder class]]) {
        GKOrder *order  = (GKOrder *)sender;

        PaymentCodeController * paymengVC   = [[PaymentCodeController alloc] initWithOrder:order];
        __weak __typeof(&*paymengVC)weakVC = paymengVC;
        paymengVC.closeAction               = ^(void){
            [weakVC removeFromParentViewController];
        };

        [[UIApplication sharedApplication].keyWindow addSubview:paymengVC.view];
        [self addChildViewController:paymengVC];
    }
}

- (void)tapAlipayBtn:(id)sender
{

    if ([sender isKindOfClass:[GKOrder class]]) {
        GKOrder *order  = (GKOrder *)sender;
        
        [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"loading", kLocalizedFile, nil)];
        [API getPaymentURLWithOrderId:order.orderId PaymentType:AlipayPaymentType Success:^(NSString *payment_url) {
//            DDLogInfo(@"payment %@", payment_url);
//            [[OpenCenter sharedOpenCenter] openWebWithURL:[NSURL URLWithString:payment_url]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payment_url]];
            
            WebViewController   *webVC  = [[WebViewController alloc] initWithURL:[NSURL URLWithString:payment_url]];
            
            [self.navigationController pushViewController:webVC animated:YES];
            
            [SVProgressHUD dismissWithDelay:2];
        } Failure:^(NSInteger stateCode, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}



@end
