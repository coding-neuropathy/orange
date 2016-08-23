//
//  EntitySKUController.m
//  orange
//
//  Created by 谢家欣 on 16/8/15.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUController.h"

@interface EntitySKUController ()

@property (strong, nonatomic) NSString * entity_hash;
@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) UIButton * continueAddBtn;

@end

@implementation EntitySKUController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedStringFromTable(@"item", kLocalizedFile, nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.continueAddBtn];

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

@end
