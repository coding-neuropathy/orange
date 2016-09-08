//
//  OrderController.m
//  orange
//
//  Created by 谢家欣 on 16/9/1.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "OrderController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>

#import "AllOrderController.h"
#import "PendingOrderController.h"
#import "FinishedOrderController.h"


@interface OrderController () 

@property (strong, nonatomic) UIPageViewController      *thePageViewController;
@property (strong, nonatomic) HMSegmentedControl        *segmentedControl;
@property (assign, nonatomic) NSInteger                 index;

@property (strong, nonatomic) AllOrderController        *allOrderController;
@property (strong, nonatomic) PendingOrderController    *pendingController;
@property (strong, nonatomic) FinishedOrderController   *finishedOrderController;
@property (strong, nonatomic) NSArray                   *controllers;

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

        __weak __typeof(&*self)weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            UIViewController * controller = [weakSelf.controllers objectAtIndex:index];
            [weakSelf.thePageViewController setViewControllers:@[controller]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:NO completion:^(BOOL finished) {
                                                          weakSelf.index = index;
                                                      }];
        }];
        
    }
    return _segmentedControl;
}

#pragma mark - lazy load 
- (AllOrderController *)allOrderController
{
    if (!_allOrderController) {
        _allOrderController = [[AllOrderController alloc] init];
    }
    return _allOrderController;
}

- (PendingOrderController *)pendingController
{
    if (!_pendingController) {
        _pendingController  = [[PendingOrderController alloc] init];
    }
    return _pendingController;
}

- (FinishedOrderController *)finishedOrderController
{
    if (!_finishedOrderController) {
        _finishedOrderController    = [[FinishedOrderController alloc] init];
    }
    return _finishedOrderController;
}

- (NSArray *)controllers
{
    if (!_controllers) {
        _controllers        = [NSArray arrayWithObjects:self.allOrderController,
                               self.pendingController, self.finishedOrderController, nil];
    }
    return _controllers;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title              = NSLocalizedStringFromTable(@"order", kLocalizedFile, nil);
    self.view.backgroundColor   = [UIColor colorFromHexString:@"#ffffff"];
    
    [self.view addSubview:self.segmentedControl];
    
    self.thePageViewController.view.frame = CGRectMake(0, self.segmentedControl.deFrameBottom, kScreenWidth,  kScreenHeight -
                                                       self.segmentedControl.deFrameBottom);
    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
    [self addChildViewController:self.thePageViewController];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.thePageViewController setViewControllers:@[self.allOrderController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        if (finished) {
            weakSelf.index = 0;
        }
    }];
}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.controllers.count;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.index = [self.controllers indexOfObject:viewController];
    if (self.index > 0) {
//        self.index = self.beforeIndex;
//        DDLogInfo(@"before %ld", self.index);
        return [self.controllers objectAtIndex:self.index - 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.index = [self.controllers indexOfObject:viewController];
    if (self.index < [self.controllers count] - 1) {
        DDLogInfo(@"after %ld", (long)self.index);
        return [self.controllers objectAtIndex:self.index + 1];
    }
    return nil;
}

#pragma mark - <UIPageViewControllerDelegate>
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger currentIndex = [self.controllers indexOfObject:pageViewController.viewControllers.firstObject];
    if (completed) {

        [self.segmentedControl setSelectedSegmentIndex:currentIndex animated:YES];
    }
}
//#pragma mark - HMSegmentedControl ChangeValue
//- (void)segmentedControlChangedValue:(id)sender
//{
//
//}

@end
