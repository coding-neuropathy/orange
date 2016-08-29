//
//  EntitySKUController.m
//  orange
//
//  Created by 谢家欣 on 16/8/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUController.h"
#import "CartController.h"

#import "EntitySKUView.h"
#import "SKUToolbar.h"

#import <WZLBadge/WZLBadgeImport.h>



@interface EntitySKUController () <SKUToolbarDelegate, EntitySKUViewDelegate>

typedef NS_ENUM(NSInteger, SKUSectionType) {
    EntitySKUHeaderSection = 0,
    SKUSection,
};


@property (strong, nonatomic) NSString          *entity_hash;
@property (strong, nonatomic) GKEntity          *entity;

@property (strong, nonatomic) UIButton          *continueAddBtn;
@property (strong, nonatomic) UIButton          *backBtn;

@property (strong, nonatomic) SKUToolbar        *toolbar;
@property (strong, nonatomic) UIButton          *orderBtn;
@property (strong, nonatomic) EntitySKUView     *entitySKUView;

@property (strong, nonatomic) UIButton          *cartListBtn;
@property (assign, nonatomic) NSInteger         cartVolume;

@end

@implementation EntitySKUController


static NSString * SKUCellIdentifier                 = @"SKUCell";
static NSString * EntitySKUReuseHeaderIdentifier    = @"EntityHeader";
static NSString * SKUHeaderIdentifier               = @"SKUHeader";

- (instancetype)initWithEntityHash:(NSString *)hash
{
    self = [super init];
    if (self) {
        self.entity_hash                            = hash;
        self.cartVolume                             = 0;
    }
    return self;
}

#pragma mark - lazy load view
- (UIButton *)continueAddBtn
{
    if (!_continueAddBtn) {
        _continueAddBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueAddBtn.titleLabel.font             = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _continueAddBtn.deFrameSize                 = CGSizeMake(70., 22.);
        
        [_continueAddBtn setTitle:NSLocalizedStringFromTable(@"continue-add", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_continueAddBtn setTitleColor:UIColorFromRGB(0x5976c1) forState:UIControlStateNormal];
        [_continueAddBtn addTarget:self action:@selector(continueAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _continueAddBtn;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.deFrameSize        = CGSizeMake(32., 44.);
        
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)cartListBtn
{
    if (!_cartListBtn) {
        _cartListBtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartListBtn.backgroundColor        = [UIColor colorFromHexString:@"#f8f8f8"];
        _cartListBtn.deFrameSize            = CGSizeMake(56., 56.);
        _cartListBtn.layer.cornerRadius     = _cartListBtn.deFrameHeight / 2.;
        _cartListBtn.layer.shadowOffset     = CGSizeMake(0., 2.);
//        _cartListBtn.layer.shadowColor  = [UIColor colorWithWhite:0. alpha:0.18].CGColor;
        _cartListBtn.layer.shadowOpacity    = 0.18;
        
        _cartListBtn.badgeCenterOffset      = CGPointMake(-8, 8);
        _cartListBtn.badgeBgColor           = [UIColor colorFromHexString:@"#212121"];
        
        [_cartListBtn setImage:[UIImage imageNamed:@"bag"] forState:UIControlStateNormal];
        [_cartListBtn addTarget:self action:@selector(cartListBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _cartListBtn;
}

- (EntitySKUView *)entitySKUView
{
    if (!_entitySKUView) {
        _entitySKUView                          = [[EntitySKUView alloc] initWithFrame:CGRectZero];
        
        _entitySKUView.backgroundColor          = UIColorFromRGB(0xffffff);
        _entitySKUView.deFrameSize              = CGSizeMake(kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 49.);
        _entitySKUView.SKUDelegate              = self;
        _entitySKUView.contentSize              = CGSizeMake(kScreenWidth, kScreenHeight);
    }
    return _entitySKUView;
}

- (UIView *)toolbar
{
    if (!_toolbar) {
        _toolbar                                = [[SKUToolbar alloc] initWithFrame:CGRectZero];
        _toolbar.deFrameSize                    = CGSizeMake(kScreenWidth, 49.);
        _toolbar.backgroundColor                = UIColorFromRGB(0xffffff);
        _toolbar.delegate                       = self;
//        _toolbar.backgroundColor                = [UIColor redColor];
        
    }
    return _toolbar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title                   = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    self.navigationItem.leftBarButtonItem       = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.rightBarButtonItem      = [[UIBarButtonItem alloc] initWithCustomView:self.continueAddBtn];
    
    [self.view addSubview:self.entitySKUView];

    /**
     *  config toolbar
     */
    [self configToolbar];
    
    /**
     *  config cart list btn
     */
    [self configCart];
    
    
    [API getEntitySKUWithHash:self.entity_hash Success:^(GKEntity *entity) {
        
        self.entity                 = entity;
        self.entitySKUView.entity   = self.entity;
        self.toolbar.price          = self.entity.lowestPrice;
//        [self.collectionView reloadData];
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error %@", error.localizedDescription);
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

//    [self.navigationController setToolbarHidden:YES animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark - button action
- (void)continueAddBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cartListBtnAction:(id)sender
{
    CartController * cartController = [[CartController alloc] init];
    
    [self.navigationController pushViewController:cartController animated:YES];
}

- (void)backBtnAction:(id)sender
{
    UIAlertController * actionSheetController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"清空购物袋 ?", kLocalizedFile, nil) message:@"现在返回， 购物袋中的商品将被清空" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * backAcion = [UIAlertAction actionWithTitle:@"仍然返回"
                                                    style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [actionSheetController addAction:backAcion];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil)
                                                style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [actionSheetController dismissViewControllerAnimated:YES completion:nil];
    }];
    [actionSheetController addAction:cancelAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}


#pragma mark - config toolbar
- (void)configToolbar
{
    
    DDLogInfo(@"height %f", self.view.deFrameHeight);
    self.toolbar.deFrameBottom              = self.view.deFrameHeight - kNavigationBarHeight - kStatusBarHeight;
    self.toolbar.price                      = self.entity.lowestPrice;
    [self.view insertSubview:self.toolbar aboveSubview:self.entitySKUView];

}

- (void)configCart
{

    self.cartListBtn.deFrameLeft            = 16.;
    self.cartListBtn.deFrameBottom          = self.view.deFrameHeight - kNavigationBarHeight - kStatusBarHeight - 12.;
    
    [self.view insertSubview:self.cartListBtn aboveSubview:self.toolbar];
}

#pragma mark - <EntitySKUViewDelegate>
- (void)TapSKUTagWithSKU:(GKEntitySKU *)sku
{
    DDLogInfo(@"sku_id %ld", sku.skuId);
    [self.toolbar updatePriceWithprice:sku.discount];
}

- (void)TapAddCartWithSKU:(GKEntitySKU *)sku
{
    [SVProgressHUD showInfoWithStatus:@"add-to-cart"];
    [API addEntitySKUToCartWithSKUId:sku.skuId Volume:1 Success:^(BOOL is_success) {
        
        if (is_success) {
            self.cartVolume += 1;
            [_cartListBtn showBadgeWithStyle:WBadgeStyleNumber value:self.cartVolume animationType:WBadgeAnimTypeNone];
            [SVProgressHUD showSuccessWithStatus:@"success"];
        }
    } Failure:^(NSInteger stateCode, NSError *error) {
        DDLogError(@"error: %@", error.localizedDescription);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - <SKUToolbarDelegate>
- (void)tapOrderBtn:(id)sender
{
    
}


@end


