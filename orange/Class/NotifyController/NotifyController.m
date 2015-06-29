//
//  NotifyController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "NotifyController.h"
#import "HMSegmentedControl.h"
#import "MessageController.h"
#import "ActiveController.h"

@interface NotifyController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController * thePageViewController;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger index;
//@property (strong, nonatomic) NSArray * 
@property (strong, nonatomic) MessageController * msgController;
@property (strong, nonatomic) ActiveController * activeController;

@end

@implementation NotifyController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle: NSLocalizedStringFromTable(@"notify", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_notifaction"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_notifaction"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        self.tabBarItem = item;
        self.index = 0;
    }
    return self;
}

#pragma mark - init view
- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        
        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"activity", kLocalizedFile, nil), NSLocalizedStringFromTable(@"message", kLocalizedFile, nil)]];
        [_segmentedControl setSelectedSegmentIndex:0 animated:NO];
//        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
        [_segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        [_segmentedControl setTextColor:UIColorFromRGB(0x9d9e9f)];
        [_segmentedControl setSelectedTextColor:UIColorFromRGB(0x414243)];
        [_segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
        [_segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xFF1F77)];
        [_segmentedControl setSelectionIndicatorHeight:1.5];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setTag:2];
        
        
        UIView * V = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2,44/2-7, 1,14 )];
        V.backgroundColor = UIColorFromRGB(0xebebeb);
        [_segmentedControl addSubview:V];
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
        //        _thePageViewController.view.frame = CGRectMake(0., 0., WIDTH, HEIGHT - 100.);
        _thePageViewController.dataSource = self;
        _thePageViewController.delegate = self;
        
    }
    return _thePageViewController;
}

//- (void)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"notify", kLocalizedFile, nil);
    
    [self.view addSubview:self.segmentedControl];

    [self addChildViewController:self.thePageViewController];
    
    self.thePageViewController.view.frame = CGRectMake(0, 44., kScreenWidth, kScreenHeight - 44.);

    [self.thePageViewController setViewControllers:@[self.activeController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    [self.thePageViewController setViewControllers:@[self.activeController, self.msgController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
//    DDLogError(@"before %@", viewController);
    if ([viewController isKindOfClass:[MessageController class]]) {
        return self.activeController;
    }
    return nil;
//    if (self.index == 0) {
//        return nil;
//    }
//    self.index --;
//    return self.activeController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[ActiveController class]]) {
        return self.msgController;
    }
    return nil;
//    DDLogError(@"after %@", viewController);
//    
//    if (self.index == 1) {
//        return nil;
//    }
//    self.index ++;
//    return self.msgController;
//    DDLogError(@"after %@", viewController);
    
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

#pragma mark -
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
//    NSUInteger index = ;
    self.index = segmentedControl.selectedSegmentIndex;
    
    if (segmentedControl.selectedSegmentIndex == 1){
        [self.thePageViewController setViewControllers:@[self.msgController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.thePageViewController setViewControllers:@[self.activeController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
}
@end
