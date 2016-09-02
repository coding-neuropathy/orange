//
//  SelectionController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SelectionController.h"
//#import "HMSegmentedControl.h"
//#import "HomeController.h"
#import "SelectionViewController.h"
#import "ArticlesController.h"

#import <HMSegmentedControl/HMSegmentedControl.h>

@interface SelectionController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController * thePageViewController;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) SelectionViewController * entityVC;
@property (strong, nonatomic) ArticlesController * articleVC;


@end

@implementation SelectionController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle: @"" image:[[UIImage imageNamed:@"featured"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"featured_on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 32)];
    
//        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"selection-nav-recommend", kLocalizedFile, nil), NSLocalizedStringFromTable(@"selection-nav-entity", kLocalizedFile, nil),NSLocalizedStringFromTable(@"selection-nav-article", kLocalizedFile, nil)]];
        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"selection-nav-entity", kLocalizedFile, nil),NSLocalizedStringFromTable(@"selection-nav-article", kLocalizedFile, nil)]];
        [_segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        [_segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];

        NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIColor colorFromHexString:@"#212121"] forKey:NSForegroundColorAttributeName];
        [_segmentedControl setSelectedTitleTextAttributes:dict2];
        UIFont *font = [UIFont boldSystemFontOfSize:17.];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                               forKey:NSFontAttributeName];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setValue:font forKey:NSFontAttributeName];
        [attributes setValue:[UIColor colorFromHexString:@"#757575"] forKey:NSForegroundColorAttributeName];
        [_segmentedControl setTitleTextAttributes:attributes];
    
        [_segmentedControl setBackgroundColor:[UIColor clearColor]];
        [_segmentedControl setSelectionIndicatorColor:[UIColor colorFromHexString:@"#212121"]];
        [_segmentedControl setSelectionIndicatorHeight:2];
//        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        __weak __typeof(&*self)weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            switch (index) {
                case SelectionArticleType:
                    weakSelf.index  = SelectionArticleType;
                    [weakSelf.thePageViewController setViewControllers:@[weakSelf.articleVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
                    break;
                    
                default:
                    weakSelf.index  = SelectionEntityType;
                    [weakSelf.thePageViewController setViewControllers:@[weakSelf.entityVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                    break;
            }
        }];
        
        [_segmentedControl setTag:2];
        
//        _segmentedControl.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    }
    return _segmentedControl;
}

- (SelectionViewController *)entityVC
{
    if (!_entityVC) {
        _entityVC = [[SelectionViewController alloc] init];
    }
    return _entityVC;
}

- (ArticlesController *)articleVC
{
    if (!_articleVC) {
        _articleVC = [[ArticlesController alloc] init];
    }
    return _articleVC;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.title = NSLocalizedStringFromTable(@"Selection", kLocalizedFile, nil);
    
    self.navigationItem.titleView = self.segmentedControl;
    
    [self addChildViewController:self.thePageViewController];
    
    self.thePageViewController.view.frame = CGRectMake(0, 0, kScreenWidth,  kScreenHeight);

    if (self.segmentedControl.selectedSegmentIndex == SelectionEntityType) {
        [self.thePageViewController setViewControllers:@[self.entityVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.thePageViewController setViewControllers:@[self.articleVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoubleClickAction:) name:kDoubleClickTabItemNotification object:nil];
}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[ArticlesController class]]) {
        self.index  = SelectionEntityType;
        return self.entityVC;
    }
//    if ([viewController isKindOfClass:[SelectionViewController class]]) {
//        return self.homeVC;
//    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
//     if ([viewController isKindOfClass:[ArticlesController class]]) {
         //return self.homeVC;
//     }
     if ([viewController isKindOfClass:[SelectionViewController class]]) {
         self.index = SelectionArticleType;
         return self.articleVC;
     }
     return nil;
}

#pragma mark - <UIPageViewControllerDelegate>
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.index = 0;
    if (completed) {
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[SelectionViewController class]]) {
            self.index = SelectionEntityType;
        }
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[ArticlesController class]]) {
            self.index = SelectionArticleType;
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
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - set selection type
- (void)setSelectedWithType:(SelectionType)type
{
    switch (type) {
        case SelectionEntityType:
            [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
            [self.thePageViewController setViewControllers:@[self.entityVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            
            break;
        case SelectionArticleType:
            [self.segmentedControl setSelectedSegmentIndex:1 animated:NO];
            [self.thePageViewController setViewControllers:@[self.articleVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

            break;
    }
    self.index = type;
}

#pragma mark - notification
- (void)DoubleClickAction:(NSNotification *)notify
{
    switch (self.index) {
        case SelectionArticleType:
        {
            if (self.articleVC.articles.count > 0) {
                [self.articleVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        }
//            [self.articleVC.collectionView triggerPullToRefresh];
            break;
            
        default:
        {
            if (self.entityVC.entityList.count > 0) {
                [self.entityVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
//            [UIView animateWithDuration:0.5 animations:^{
//
//            } completion:^(BOOL finished) {
//                [self.entityVC.collectionView triggerPullToRefresh];
//            }];
        }
            break;
    }
}

//#pragma mark - 
//- (void)refreshSelection
//{
//    [self.entityVC refreshSelection];
//}

@end
