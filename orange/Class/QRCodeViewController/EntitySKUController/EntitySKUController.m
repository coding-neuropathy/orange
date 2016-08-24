//
//  EntitySKUController.m
//  orange
//
//  Created by 谢家欣 on 16/8/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUController.h"


#import "SKUToolbar.h"



@interface EntitySKUController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

typedef NS_ENUM(NSInteger, SKUSectionType) {
    EntitySKUHeaderSection = 0,
    SKUSection,
};


@property (strong, nonatomic) NSString          *entity_hash;
@property (strong, nonatomic) GKEntity          *entity;

@property (strong, nonatomic) UIButton          *continueAddBtn;

@property (strong, nonatomic) SKUToolbar        *toolbar;
@property (strong, nonatomic) UIButton          *orderBtn;

@property (strong, nonatomic) UICollectionView  *collectionView;


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

- (UIView *)toolbar
{
    if (!_toolbar) {
        _toolbar                                = [[SKUToolbar alloc] initWithFrame:CGRectZero];
        _toolbar.deFrameSize                    = CGSizeMake(kScreenWidth, 49.);
        _toolbar.backgroundColor                = UIColorFromRGB(0xffffff);
//        _toolbar.backgroundColor                = [UIColor redColor];
        
    }
    return _toolbar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title                   = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    self.navigationItem.rightBarButtonItem      = [[UIBarButtonItem alloc] initWithCustomView:self.continueAddBtn];
    
    
    /**
     *  config toolbar
     */
    [self configToolbar];
    
    [API getEntitySKUWithHash:self.entity_hash Success:^(GKEntity *entity) {
        
        self.entity = entity;
        self.toolbar.price  = self.entity.lowestPrice;
        [self.collectionView reloadData];
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


#pragma mark - config toolbar
- (void)configToolbar
{
    
    DDLogInfo(@"height %f", self.view.deFrameHeight);
    self.toolbar.deFrameBottom              = self.view.deFrameHeight - kNavigationBarHeight - kStatusBarHeight;
    self.toolbar.price                      = self.entity.lowestPrice;
    [self.view insertSubview:self.toolbar aboveSubview:self.collectionView];

}


@end


