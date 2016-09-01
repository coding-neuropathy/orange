//
//  OrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface OrderController () 

@property (strong, nonatomic) UIPageViewController * thePageViewController;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger index;

@end

@implementation OrderController

#pragma mark - lazy load view
- (UIPageViewController *)thePageViewController
{
    if (!_thePageViewController) {
        _thePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _thePageViewController.dataSource = self;
        _thePageViewController.delegate = self;
    }
    return _thePageViewController;
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectZero];
        _segmentedControl.deFrameSize   = CGSizeMake(kScreenWidth, 47);
        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"all", kLocalizedFile, nil),
                                              NSLocalizedStringFromTable(@"pending", kLocalizedFile, nil),
                                              NSLocalizedStringFromTable(@"finished", kLocalizedFile, nil)]];
        _segmentedControl.layer.borderWidth = 1.;
        _segmentedControl.layer.borderColor = [UIColor colorFromHexString:@"#ebebeb"].CGColor;
        [_segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
        [_segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        
        NSDictionary *dict2 = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x212121) forKey:NSForegroundColorAttributeName];
        [_segmentedControl setSelectedTitleTextAttributes:dict2];
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.];;
        
        NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
        [attributes setValue:font forKey:NSFontAttributeName];
        [attributes setValue:UIColorFromRGB(0x757575) forKey:NSForegroundColorAttributeName];
        [_segmentedControl setTitleTextAttributes:attributes];
        [_segmentedControl setBackgroundColor:[UIColor clearColor]];
        [_segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0x212121)];
        [_segmentedControl setSelectionIndicatorHeight:2];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//        [_segmentedControl setTag:2];
        
    }
    return _segmentedControl;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title          = NSLocalizedStringFromTable(@"order", kLocalizedFile, nil);
    
    [self.view addSubview:self.segmentedControl];
    
    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
    [self addChildViewController:self.thePageViewController];
    
}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 3;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
//    if ([viewController isKindOfClass:[MessageController class]]) {
//        return self.activeController;
//    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
//    if ([viewController isKindOfClass:[ActiveController class]]) {
//        return self.msgController;
//    }
    return nil;
}

#pragma mark - <UIPageViewControllerDelegate>

#pragma mark - HMSegmentedControl ChangeValue
- (void)segmentedControlChangedValue:(id)sender
{

}

@end
