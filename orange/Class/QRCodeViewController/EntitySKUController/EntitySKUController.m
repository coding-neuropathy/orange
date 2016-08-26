//
//  EntitySKUController.m
//  orange
//
//  Created by 谢家欣 on 16/8/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUController.h"

#import "EntitySKUView.h"
#import "SKUToolbar.h"



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



@end

@implementation EntitySKUController


static NSString * SKUCellIdentifier                 = @"SKUCell";
static NSString * EntitySKUReuseHeaderIdentifier    = @"EntityHeader";
static NSString * SKUHeaderIdentifier               = @"SKUHeader";

- (instancetype)initWithEntityHash:(NSString *)hash
{
    self = [super init];
    if (self) {
        self.entity_hash = hash;
    }
    return self;
}

#pragma mark - lazy load view
- (UIButton *)continueAddBtn
{
    if (!_continueAddBtn) {
        _continueAddBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueAddBtn.titleLabel.font         = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _continueAddBtn.deFrameSize             = CGSizeMake(70., 22.);
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

#pragma mark - <EntitySKUViewDelegate>
- (void)TapSKUTagWithSKU:(GKEntitySKU *)sku
{
    DDLogInfo(@"OKOKOKO");
    [self.toolbar updatePriceWithprice:sku.discount];
}

#pragma mark - <SKUToolbarDelegate>
- (void)tapOrderBtn:(id)sender
{
    
}


@end


