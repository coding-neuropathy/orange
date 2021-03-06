//
//  NotifyController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "NotifyController.h"
//#import "HMSegmentedControl.h"
#import "MessageController.h"
#import "ActiveController.h"

#import <WZLBadge/WZLBadgeImport.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface NotifyController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController * thePageViewController;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) MessageController * msgController;
@property (strong, nonatomic) ActiveController * activeController;

@end

@implementation NotifyController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle: @"" image:[[UIImage imageNamed:@"notify"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"notify_on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //  UIImageRenderingModeAlwaysTemplate  始终根据Tint Color绘制图片，忽略图片的颜色信息。
        //  UIImageRenderingModeAlwaysOriginal  始终绘制图片原始状态，不使用Tint Color。
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        self.tabBarItem = item;
        self.index = 0;
    }
    return self;
}

#pragma mark - init view
- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40., 32.)];
        
        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"activity", kLocalizedFile, nil),
                                              NSLocalizedStringFromTable(@"message", kLocalizedFile, nil)]];
        [_segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
//        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
        [_segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
//        NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x9d9e9f) forKey:NSForegroundColorAttributeName];
//        [_segmentedControl setTitleTextAttributes:dict];

        
        NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
        [attributes setValue:[UIFont boldSystemFontOfSize:17.] forKey:NSFontAttributeName];
        [attributes setValue:[UIColor colorFromHexString:@"#757575"] forKey:NSForegroundColorAttributeName];
        [_segmentedControl setTitleTextAttributes:attributes];
        
        NSDictionary *selectionTitleAttr = [NSDictionary dictionaryWithObject:[UIColor colorFromHexString:@"#212121"]
                                                                       forKey:NSForegroundColorAttributeName];
        [_segmentedControl setSelectedTitleTextAttributes:selectionTitleAttr];
        
        [_segmentedControl setBackgroundColor:[UIColor clearColor]];
        [_segmentedControl setSelectionIndicatorColor:[UIColor colorFromHexString:@"#212121"]];
        [_segmentedControl setSelectionIndicatorHeight:2];
//        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//        [_segmentedControl setTag:2];
        __weak __typeof(&*self)weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            weakSelf.index = index;
            
            if (index == 1){
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                [weakSelf.thePageViewController setViewControllers:@[weakSelf.msgController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            } else {
                [weakSelf.thePageViewController setViewControllers:@[weakSelf.activeController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
        }];
    }
    return _segmentedControl;
}

- (MessageController *)msgController
{
    if (!_msgController) {
        _msgController = [[MessageController alloc] init];
    }
    return _msgController;
}

- (ActiveController *)activeController
{
    if (!_activeController) {
        _activeController = [[ActiveController alloc] init];
    }
    return _activeController;
}

- (UIPageViewController *)thePageViewController
{
    if (!_thePageViewController) {
        _thePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _thePageViewController.dataSource = self;
        _thePageViewController.delegate = self;
    }
    return _thePageViewController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowBadge" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HideBadge" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.titleView = self.segmentedControl;
    
    self.thePageViewController.view.deFrameSize = CGSizeMake(kScreenWidth, kScreenHeight);

    [self.thePageViewController setViewControllers:@[self.activeController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    [self.thePageViewController setViewControllers:@[self.activeController, self.msgController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadge) name:@"ShowBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBadge) name:@"HideBadge" object:nil];
    
//    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
    [self.view addSubview:self.thePageViewController.view];
    [self addChildViewController:self.thePageViewController];
}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[MessageController class]]) {
        return self.activeController;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[ActiveController class]]) {
        return self.msgController;
    }
    return nil;
}

#pragma mark - <UIPageViewControllerDelegate>
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
//    DDLogError(@"index %ld", self.index);
    self.index = 0;
    if (completed) {
//        DDLogError(@"index %@", pageViewController.viewControllers);
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[MessageController class]]) {
            self.index = 1;
        }
        
        [self.segmentedControl setSelectedSegmentIndex:self.index animated:YES];
    }
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {

    UIViewController *currentViewController = [self.thePageViewController.viewControllers objectAtIndex:0];

    NSArray * view_controllers = [NSArray arrayWithObjects:currentViewController, nil];
    [self.thePageViewController setViewControllers:view_controllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    self.thePageViewController.doubleSided = NO;
//    [self.segmentedControl setSelectedSegmentIndex:self.index animated:YES];
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark badge
- (void)addBadge
{
//    [self removeBadge];
//    [self tabBadge:YES];

    self.segmentedControl.badgeCenterOffset = CGPointMake(-45, 5.);
    self.segmentedControl.badgeBgColor      = [UIColor colorFromHexString:@"#f70866"];
    [self.segmentedControl showBadge];
}

- (void)removeBadge
{
    [self.segmentedControl clearBadge];
}


#pragma mark -
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
//    NSUInteger index = ;
    self.index = segmentedControl.selectedSegmentIndex;
    
    if (segmentedControl.selectedSegmentIndex == 1){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.thePageViewController setViewControllers:@[self.msgController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else {
        [self.thePageViewController setViewControllers:@[self.activeController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
}
@end
